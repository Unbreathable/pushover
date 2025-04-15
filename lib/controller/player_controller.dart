import 'dart:convert';

import 'package:pushover/controller/state_controller.dart';
import 'package:pushover/server/server.dart';
import 'package:pushover/util/vertical_spacing.dart';
import 'package:signals/signals_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayerController {
  static final _teams = <TeamType, Team>{
    TeamType.blue: Team(TeamType.blue),
    TeamType.red: Team(TeamType.red),
  };

  static Player? registerNewPlayer(WebSocketChannel channel) {
    // Make sure players are allowed
    if (!StateController.currentState.peek().allowNewPlayers) {
      channel.sink.close();
      return null;
    }

    // Add a new player to the team with the least players
    var toAdd = TeamType.blue;
    for (var entry in _teams.entries) {
      if (_teams[toAdd]!.players.length > entry.value.players.length) {
        toAdd = entry.key;
      }
    }

    return Player("Player ${getRandomString(6)}", toAdd, channel);
  }

  static void handlePlayerDisconnect(Player player) {
    _teams[player.team]!.players.remove(player);
  }

  /// Send an event to all players in the game.
  static void sendEventToAll(Event event) {
    for (var entry in _teams.entries) {
      for (var player in entry.value.players) {
        player.connection.sink.add(jsonEncode(event.toJson()));
      }
    }
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
