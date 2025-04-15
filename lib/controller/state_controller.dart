import 'package:flutter/material.dart';
import 'package:pushover/controller/player_controller.dart';
import 'package:pushover/controller/states/lobby_state.dart';
import 'package:pushover/server/server.dart';
import 'package:signals/signals_flutter.dart';

class StateController {
  static final currentState = signal<GameState>(LobbyState());

  /// Set the current game state
  static void setGameState(GameState state) {
    currentState.value.end();
    currentState.value = state;
    state.start();

    // Tell everyone that the game state changed
    PlayerController.sendEventToAll(Event("state_change", state.eventName));
  }

  /// Get the event used to notify the clienot of the current state
  static Event currentStateEvent() {
    return Event("state_change", currentState.peek().eventName);
  }
}

abstract class GameState {
  final String eventName; // Name in the game state change event
  final bool allowNewPlayers;

  GameState(this.eventName, this.allowNewPlayers);

  void start();
  void onEvent(Event event);
  void end() {}
  Widget render();
}
