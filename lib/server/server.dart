import 'dart:convert';

import 'package:pushover/controller/player_controller.dart';
import 'package:pushover/main.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf_static/shelf_static.dart';

class GameServer {
  static void startServer() {
    final router = Router();

    // Deploy the actual code for the controller web app
    final staticHandler = createStaticHandler(
      controlPath,
      defaultDocument: "index.html",
    );
    router.get("/", staticHandler);
    router.get("/<something>", staticHandler);

    final ws = webSocketHandler((webSocket, subprotocol) {
      PlayerController.registerNewPlayer(webSocket);
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
