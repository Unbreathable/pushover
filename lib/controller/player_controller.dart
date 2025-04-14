import 'package:pushover/server/server.dart';
import 'package:pushover/util/vertical_spacing.dart';
import 'package:signals/signals_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayerController {
  static final _teams = <TeamType, Team>{
    TeamType.blue: Team(TeamType.blue),
    TeamType.red: Team(TeamType.red),
  };

  static void registerNewPlayer(WebSocketChannel channel) {
    // Add a new player to the team with the least players
    var toAdd = TeamType.blue;
    for (var entry in _teams.entries) {
      if (_teams[toAdd]!.players.length > entry.value.players.length) {
        toAdd = entry.key;
      }
    }
    final player = Player("Player ${getRandomString(6)}", toAdd, channel);

    // Listen to all the things from the player
    channel.stream.listen(
      (msg) {
        // Make sure it's a JSON
        if (msg is! String) {
          channel.sink.close();
          sendLog("warning: didn't receive string, closing connection");
          return;
        }

        // Parse to an event
        final event = Event.fromJson(msg);
        sendLog(event);
      },
      onDone: () {
        handlePlayerDisconnect(player);
      },
      onError: (e) {
        sendLog("WebSocket Error: $e");
        handlePlayerDisconnect(player);
      },
      cancelOnError: true,
    );
  }

  static void _sendTeamChange() {
    // Construct the event
    final teamsMap = _teams.values.map((t) => t.toJson()).toList();
    final event = Event("team_update", teamsMap);

    for (var team in _teams.values) {
      for (var player in team.players) {
        player.connection.sink.add(Event("team_update", {""}));
      }
    }
  }

  static void handlePlayerDisconnect(Player player) {
    _teams[player.team]!.players.remove(player);
  }
}

enum TeamType { blue, red }

class Team {
  final TeamType type;
  final players = listSignal(<Player>[]);

  Team(this.type);

  dynamic toJson() => {
    "i": type.index,
    "players": players.peek().map((p) => p.toJson()).toList(),
  };
}

class Player {
  final WebSocketChannel connection;
  final String name;
  final TeamType team;

  Player(this.name, this.team, this.connection);

  dynamic toJson() => {"name": name};
}
