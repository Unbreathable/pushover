import 'package:flutter/material.dart';
import 'package:pushover/util/vertical_spacing.dart';
import 'package:signals/signals_flutter.dart';

class LobbyPage extends StatelessWidget {
  final Signal<String> status;

  const LobbyPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SizedBox(
        width: 700,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Watch(
              (ctx) =>
                  Text(status.value, style: theme.textTheme.headlineMedium),
            ),
            verticalSpacing(sectionSpacing * 2),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Team Blue selection
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onInverseSurface,
                      borderRadius: BorderRadius.circular(sectionSpacing),
                    ),
                    padding: EdgeInsets.all(sectionSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Blue", style: theme.textTheme.headlineMedium),
                        verticalSpacing(sectionSpacing),
                        Text(
                          "This team is currently empty.",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpacing(sectionSpacing * 2),

                // Team red selection
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onInverseSurface,
                      borderRadius: BorderRadius.circular(sectionSpacing),
                    ),
                    padding: EdgeInsets.all(sectionSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Red", style: theme.textTheme.headlineMedium),
                        verticalSpacing(sectionSpacing),
                        Text(
                          "This team is currently empty.",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            verticalSpacing(sectionSpacing * 2),

            // Team selection
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(sectionSpacing),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(sectionSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Join the game", style: theme.textTheme.headlineMedium),
                  verticalSpacing(sectionSpacing),
                  Row(
                    children: [
                      // QR Code in the future
                      Container(color: Colors.red, width: 150, height: 150),
                      horizontalSpacing(sectionSpacing),

                      // Instructions for joining the game
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. Connect to the same WiFi as this Computer.",
                              style: theme.textTheme.bodyLarge,
                            ),
                            verticalSpacing(elementSpacing),
                            Text(
                              "2. Scan the QR Code or enter the URL below to join.",
                              style: theme.textTheme.bodyLarge,
                            ),
                            verticalSpacing(defaultSpacing),

                            // URL for the game
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(
                                  defaultSpacing,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: defaultSpacing,
                                horizontal: defaultSpacing,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                  horizontalSpacing(defaultSpacing),
                                  Text(
                                    "https://liphium.com/pushover",
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
