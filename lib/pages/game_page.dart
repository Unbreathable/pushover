import 'package:flutter/material.dart';
import 'package:pushover/controller/state_controller.dart';
import 'package:signals/signals_flutter.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.inverseSurface,
      body: Watch((ctx) => StateController.currentState.value.render()),
    );
  }
}
