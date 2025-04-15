import 'package:flutter/material.dart';
import 'package:pushover/controller/state_controller.dart';
import 'package:pushover/pages/lobby_page.dart';
import 'package:pushover/server/server.dart';
import 'package:signals/signals_flutter.dart';

class LobbyState extends GameState {
  final _status = signal("Waiting for players...");

  LobbyState() : super("lobby", true);

  @override
  void start() {}

  @override
  Widget render() {
    return LobbyPage(status: _status);
  }

  @override
  void end() {
    _status.dispose();
  }

  @override
  void onEvent(Event event) {
    switch (event.name) {}
  }
}
