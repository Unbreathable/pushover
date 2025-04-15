import 'dart:convert';

import 'package:pushover/controller/player_controller.dart';
import 'package:pushover/main.dart';
import 'package:pushover/util/vertical_spacing.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf_static/shelf_static.dart';

class GameServer {
  static void startServer() {
    final router = Router();

    // Deploy the actual code for the controller web app (if desired)
    if (controlPath != "-") {
      final staticHandler = createStaticHandler(
        controlPath,
        defaultDocument: "index.html",
      );
      router.get("/", staticHandler);
      router.get("/<something>", staticHandler);
    } else {
      sendLog(
        "INFO: Not returning frontend code. Please use --dart-define FRONTEND_PATH=\"/your/path\" to define the location at build time.",
      );
    }

    // Register the websocket handler for the game
    final ws = webSocketHandler((webSocket, subprotocol) {
      final player = PlayerController.registerNewPlayer(webSocket);
      if (player == null) {
        return;
      }

      // Listen to all the events sent through the connection
      webSocket.stream.listen(
        (msg) {
          // Make sure it's a JSON
          if (msg is! String) {
            webSocket.sink.close();
            sendLog("warning: didn't receive string, closing connection");
            return;
          }

          // Parse to an event
          final event = Event.fromJson(msg);
          sendLog(event);
        },
        onDone: () {
          PlayerController.handlePlayerDisconnect(player);
        },
        onError: (e) {
          sendLog("WebSocket Error: $e");
          PlayerController.handlePlayerDisconnect(player);
        },
        cancelOnError: true,
      );
    });

    router.get("/api/connect", ws);

    final app = Pipeline().addMiddleware(logRequests()).addHandler(router.call);
    io.serve(app, "localhost", 8080);
  }
}

class Event {
  final String name;
  final dynamic data;

  Event(this.name, this.data);

  factory Event.fromJson(String data) {
    final json = jsonDecode(data);
    return Event(json[0], json[1]);
  }

  dynamic toJson() => jsonEncode([name, data]);

  @override
  String toString() {
    return "$name: $data";
  }
}
