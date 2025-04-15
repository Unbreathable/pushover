import 'package:flutter/material.dart';
import 'package:pushover/util/vertical_spacing.dart';

// Config
const xSize = 32;
const ySize = 16;
const tickRate = 50;
const lockZoneOffset = 4;
const lockZoneRed = lockZoneOffset;
const lockZoneBlue = xSize - lockZoneOffset + 1;

class IngamePage extends StatefulWidget {
  const IngamePage({super.key});

  @override
  State<IngamePage> createState() => _IngamePageState();
}

class _IngamePageState extends State<IngamePage> with TickerProviderStateMixin {
  final GlobalKey key = GlobalKey();
  late final AnimationController _ctrl;

  @override
  void initState() {
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // keeps firing every frame
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              key: key,
              aspectRatio: xSize / ySize,
              child: ClipRect(
                child: Listener(
                  onPointerDown: (event) {},
                  onPointerMove: (event) {},
                  onPointerUp: (event) {},
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: GamePainter(theme, PixelPosition.zero, _ctrl),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(defaultSpacing),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.inverseSurface.withAlpha(200),
                  borderRadius: BorderRadius.circular(sectionSpacing),
                  border: Border.all(color: Colors.white.withAlpha(25)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: sectionSpacing,
                  vertical: defaultSpacing,
                ),
                child: Text(
                  "Pixel grid!",
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PixelPosition getPixelPos(Offset localPos) {
    final pixelSize = key.currentContext!.size!.width / xSize;
    final pixelX = (localPos.dx / pixelSize).floor();
    final pixelY = (localPos.dy / pixelSize).floor();
    return PixelPosition(pixelX + 1, pixelY + 1);
  }
}

class GamePainter extends CustomPainter {
  final ThemeData theme;
  final PixelPosition mousePos;

  GamePainter(this.theme, this.mousePos, AnimationController repaint)
    : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / xSize;
    final rect = Rect.fromLTWH(
      0,
      0,
      pixelSize + 1,
      pixelSize + 1,
    ); // Increase size by 1 to overlap

    final paint = Paint();
    for (int x = 1; x <= xSize; x++) {
      for (int y = 1; y <= ySize; y++) {
        // Make sure neighbouring pixels have different colors
        paint.color =
            (x + y) % 2 == 0
                ? theme.colorScheme.inverseSurface
                : theme.colorScheme.onInverseSurface;

        // Color the lock zone
        if (x == lockZoneBlue) {
          paint.color = addBlueTint(paint.color);
        } else if (x == lockZoneRed) {
          paint.color = addRedTint(paint.color);
        }

        // Draw the actual pixel at the correct position
        canvas.drawRect(
          rect.shift(Offset((x - 1) * pixelSize, (y - 1) * pixelSize)),
          paint,
        );
      }
    }
  }

  Color addBlueTint(Color color) {
    final newBlue = (color.b + 0.12).clamp(0.0, 1.0);
    return Color.from(red: color.r, green: color.g, blue: newBlue, alpha: 1);
  }

  Color addRedTint(Color color) {
    final newRed = (color.r + 0.12).clamp(0.0, 1.0);
    return Color.from(red: newRed, green: color.g, blue: color.b, alpha: 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PixelPosition {
  static PixelPosition zero = PixelPosition(0, 0);

  final int x;
  final int y;

  PixelPosition(this.x, this.y);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is PixelPosition && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
