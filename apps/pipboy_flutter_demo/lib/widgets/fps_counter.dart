import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// A small Pip-Boy–styled FPS counter overlay.
///
/// Uses [SchedulerBinding.addTimingsCallback] so it works on all platforms
/// including WASM / CanvasKit web — no platform-specific code required.
class FpsCounter extends StatefulWidget {
  const FpsCounter({super.key});

  @override
  State<FpsCounter> createState() => _FpsCounterState();
}

class _FpsCounterState extends State<FpsCounter> {
  // Rolling window of recent frame durations (µs).
  final List<int> _durations = [];

  /// How many recent frames to average over.
  static const _windowSize = 30;

  double _fps = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    super.dispose();
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      final us = t.totalSpan.inMicroseconds;
      // On WASM/web the raster phase is browser-managed so totalSpan may
      // reflect only the build phase. We still use it — any positive value
      // gives a meaningful FPS reading.
      if (us > 0) {
        _durations.add(us);
      }
    }

    // Keep only the most recent window.
    if (_durations.length > _windowSize) {
      _durations.removeRange(0, _durations.length - _windowSize);
    }

    if (_durations.isEmpty || !mounted) return;

    final avgUs = _durations.reduce((a, b) => a + b) / _durations.length;
    final fps = avgUs > 0 ? 1000000 / avgUs : 0.0;

    setState(() => _fps = fps);
  }

  Color _fpsColor(PipboyColorPalette palette) {
    if (_fps >= 55) return palette.success;
    if (_fps >= 30) return palette.warning;
    return palette.error;
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final color = _fpsColor(palette);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.85),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Blinking indicator dot — green when smooth, changes color with fps
          _BlinkDot(color: color),
          const SizedBox(width: 6),
          Text(
            'FPS  ${_fps.toStringAsFixed(1).padLeft(5)}',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tiny blinking dot that pulses once per second — Pip-Boy HUD feel.
class _BlinkDot extends StatefulWidget {
  const _BlinkDot({required this.color});
  final Color color;

  @override
  State<_BlinkDot> createState() => _BlinkDotState();
}

class _BlinkDotState extends State<_BlinkDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
