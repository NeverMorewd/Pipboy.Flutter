import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/widgets/pipboy_scanline_overlay.dart';

/// A full CRT-effect display container.
///
/// Layers multiple optional effects on top of [child]:
/// - Horizontal scanlines (optionally animated with upward scroll)
/// - Animated scan beam (vertical sweep)
/// - Vignette (darkened edges)
/// - Screen flicker (random brightness variation)
/// - Static noise (random bright pixel speckles)
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
    this.scanlineAnimation = false,
    this.scanlineAnimSpeed = 30.0,
    this.noise = false,
    this.noiseDensity = 0.02,
    this.noiseOpacity = 0.06,
    this.noiseRefreshInterval = const Duration(milliseconds: 100),
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

  /// Enable animated upward-scrolling scanlines (Avalonia parity).
  final bool scanlineAnimation;

  /// Speed of scanline scroll in logical pixels per second.
  final double scanlineAnimSpeed;

  /// Enable static noise speckle effect (Avalonia parity).
  final bool noise;

  /// Probability per virtual grid cell that a noise pixel is drawn (0–1).
  final double noiseDensity;

  /// Opacity of each noise pixel.
  final double noiseOpacity;

  /// How often the noise pattern is regenerated.
  final Duration noiseRefreshInterval;

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

  // Scanline animation
  AnimationController? _scanlineAnimController;
  double _scanlinePhase = 0.0;

  // Flicker delay timer (cancellable, replaces Future.delayed)
  Timer? _flickerDelayTimer;

  // Noise
  Timer? _noiseTimer;
  List<Offset>? _noisePixels;

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
              _flickerDelayTimer = Timer(
                Duration(milliseconds: 200 + _random.nextInt(800)),
                () {
                  if (mounted) _flickerController.forward(from: 0);
                },
              );
            }
          }
        });

    if (widget.flicker) {
      _flickerDelayTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) _flickerController.forward();
      });
    }

    if (widget.scanlineAnimation) {
      _scanlineAnimController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      )..repeat();
      _scanlineAnimController!.addListener(() {
        setState(() {
          _scanlinePhase =
              (_scanlineAnimController!.value * widget.scanlineAnimSpeed) %
              widget.scanlineSpacing;
        });
      });
    }

    if (widget.noise) {
      _refreshNoise();
      _noiseTimer = Timer.periodic(widget.noiseRefreshInterval, (_) {
        _refreshNoise();
      });
    }
  }

  @override
  void dispose() {
    _beamController.dispose();
    _flickerController.dispose();
    _flickerDelayTimer?.cancel();
    _scanlineAnimController?.dispose();
    _noiseTimer?.cancel();
    super.dispose();
  }

  void _refreshNoise() {
    if (!mounted) return;
    const gridSize = 200;
    final pixels = <Offset>[];
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        if (_random.nextDouble() < widget.noiseDensity) {
          pixels.add(Offset(x / gridSize, y / gridSize));
        }
      }
    }
    setState(() => _noisePixels = pixels);
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
        phase: _scanlinePhase,
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

    if (widget.noise && _noisePixels != null && _noisePixels!.isNotEmpty) {
      content = Stack(
        children: [
          content,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _NoisePainter(
                  pixels: _noisePixels!,
                  color: palette.primary,
                  opacity: widget.noiseOpacity,
                ),
              ),
            ),
          ),
        ],
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
          color.withValues(alpha: opacity),
          color.withValues(alpha: (opacity * 1.5).clamp(0.0, 1.0)),
          color.withValues(alpha: opacity),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_ScanBeamPainter old) =>
      old.position != position || old.color != color || old.opacity != opacity;
}

class _NoisePainter extends CustomPainter {
  const _NoisePainter({
    required this.pixels,
    required this.color,
    required this.opacity,
  });

  /// Normalised [0, 1] positions.
  final List<Offset> pixels;
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: opacity);
    for (final p in pixels) {
      canvas.drawRect(
        Rect.fromLTWH(p.dx * size.width, p.dy * size.height, 1.5, 1.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => old.pixels != pixels;
}
