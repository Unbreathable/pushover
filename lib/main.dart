import 'package:flutter/material.dart';
import 'package:pushover/pages/lobby_page.dart';
import 'package:pushover/server/server.dart';
import 'package:pushover/util/theme.dart';

const controlPath = "/Users/julian/Documents/workspace/pushover/control_client";

void main() {
  GameServer.startServer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushover',
      theme: darkMetalTheme,
      home: LobbyPage(),
    );
  }
}
