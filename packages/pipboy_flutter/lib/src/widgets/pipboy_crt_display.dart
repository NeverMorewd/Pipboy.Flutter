import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/widgets/pipboy_scanline_overlay.dart';

/// A full CRT-effect display container.
///
/// Layers multiple optional effects on top of [child]:
/// - Horizontal scanlines
/// - Animated scan beam (vertical sweep)
/// - Vignette (darkened edges)
/// - Screen flicker (random brightness variation)
///
/// Mirrors the Avalonia `CrtDisplay` control.
///
/// ```dart
/// PipboyCrtDisplay(
///   scanlines: true,
///   scanBeam: true,
///   vignette: true,
///   child: MyTerminalContent(),
/// )
/// ```
class PipboyCrtDisplay extends StatefulWidget {
  const PipboyCrtDisplay({
    super.key,
    required this.child,
    this.scanlines = true,
    this.scanBeam = true,
    this.vignette = true,
    this.flicker = false,
    this.scanlineSpacing = 4.0,
    this.scanlineOpacity = 0.12,
    this.scanBeamHeight = 60.0,
    this.scanBeamOpacity = 0.06,
    this.vignetteIntensity = 0.55,
    this.flickerIntensity = 0.04,
    this.scanBeamDuration = const Duration(seconds: 4),
    this.backgroundColor,
  });

  final Widget child;
  final bool scanlines;
  final bool scanBeam;
  final bool vignette;
  final bool flicker;

  final double scanlineSpacing;
  final double scanlineOpacity;
  final double scanBeamHeight;
  final double scanBeamOpacity;
  final double vignetteIntensity;
  final double flickerIntensity;
  final Duration scanBeamDuration;
  final Color? backgroundColor;

  @override
  State<PipboyCrtDisplay> createState() => _PipboyCrtDisplayState();
}

class _PipboyCrtDisplayState extends State<PipboyCrtDisplay>
    with TickerProviderStateMixin {
  late final AnimationController _beamController;
  late final AnimationController _flickerController;
  late final Animation<double> _beamPosition;
  double _flickerValue = 1.0;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    _beamController = AnimationController(
      vsync: this,
      duration: widget.scanBeamDuration,
    )..repeat();

    _beamPosition = Tween<double>(
      begin: -0.1,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _beamController, curve: Curves.linear));

    _flickerController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 80),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _flickerValue =
                1.0 - (_random.nextDouble() * widget.flickerIntensity);
            if (widget.flicker) {
              Future.delayed(
                Duration(milliseconds: 200 + _random.nextInt(800)),
                () {
                  if (mounted) _flickerController.forward(from: 0);
                },
              );
            }
          }
        });

    if (widget.flicker) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _flickerController.forward();
      });
    }
  }

  @override
  void dispose() {
    _beamController.dispose();
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final bg = widget.backgroundColor ?? palette.background;

    Widget content = Container(color: bg, child: widget.child);

    if (widget.scanlines) {
      content = PipboyScanlineOverlay(
        spacing: widget.scanlineSpacing,
        opacity: widget.scanlineOpacity,
        child: content,
      );
    }

    if (widget.scanBeam) {
      content = AnimatedBuilder(
        animation: _beamPosition,
        builder: (context, child) => Stack(
          children: [
            child!,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ScanBeamPainter(
                    position: _beamPosition.value,
                    height: widget.scanBeamHeight,
                    color: palette.primary,
                    opacity: widget.scanBeamOpacity,
                  ),
                ),
              ),
            ),
          ],
        ),
        child: content,
      );
    }

    if (widget.vignette) {
      content = PipboyVignetteOverlay(
        intensity: widget.vignetteIntensity,
        child: content,
      );
    }

    if (widget.flicker) {
      content = AnimatedBuilder(
        animation: _flickerController,
        builder: (context, child) =>
            Opacity(opacity: _flickerValue, child: child),
        child: content,
      );
    }

    return ClipRect(child: content);
  }
}

class _ScanBeamPainter extends CustomPainter {
  const _ScanBeamPainter({
    required this.position,
    required this.height,
    required this.color,
    required this.opacity,
  });

  final double position;
  final double height;
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = position * size.height;
    final top = centerY - height / 2;
    final rect = Rect.fromLTWH(0, top, size.width, height);

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          color.withOpacity(opacity),
          color.withOpacity(opacity * 1.5),
          color.withOpacity(opacity),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_ScanBeamPainter old) =>
      old.position != position || old.color != color || old.opacity != opacity;
}
