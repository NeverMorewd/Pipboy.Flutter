import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Draws a CRT horizontal scanline overlay on top of [child].
///
/// Renders evenly-spaced horizontal lines that simulate a phosphor CRT screen.
///
/// ```dart
/// PipboyScanlineOverlay(
///   spacing: 3.0,
///   opacity: 0.15,
///   child: MyContent(),
/// )
/// ```
class PipboyScanlineOverlay extends StatelessWidget {
  const PipboyScanlineOverlay({
    super.key,
    required this.child,
    this.spacing = 4.0,
    this.opacity = 0.12,
    this.lineThickness = 1.0,
    this.color,
  });

  final Widget child;

  /// Spacing between scanlines in logical pixels.
  final double spacing;

  /// Opacity of the scanlines (0.0 – 1.0).
  final double opacity;

  /// Thickness of each scanline in logical pixels.
  final double lineThickness;

  /// Color of the scanlines. Defaults to black.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ScanlinePainter(
                spacing: spacing,
                opacity: opacity,
                lineThickness: lineThickness,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  const _ScanlinePainter({
    required this.spacing,
    required this.opacity,
    required this.lineThickness,
    required this.color,
  });

  final double spacing;
  final double opacity;
  final double lineThickness;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..strokeWidth = lineThickness
      ..style = PaintingStyle.stroke;

    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter oldDelegate) =>
      oldDelegate.spacing != spacing ||
      oldDelegate.opacity != opacity ||
      oldDelegate.lineThickness != lineThickness ||
      oldDelegate.color != color;
}

/// Applies a vignette (darkened edges) effect over [child].
class PipboyVignetteOverlay extends StatelessWidget {
  const PipboyVignetteOverlay({
    super.key,
    required this.child,
    this.intensity = 0.6,
  });

  final Widget child;

  /// Vignette intensity from 0.0 (none) to 1.0 (very dark edges).
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _VignettePainter(intensity: intensity),
            ),
          ),
        ),
      ],
    );
  }
}

class _VignettePainter extends CustomPainter {
  const _VignettePainter({required this.intensity});
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        rect.center,
        rect.longestSide * 0.7,
        [
          Colors.transparent,
          Colors.black.withOpacity(intensity.clamp(0.0, 1.0)),
        ],
        [0.5, 1.0],
      );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_VignettePainter old) => old.intensity != intensity;
}
