import 'dart:async';
import 'dart:ui' show FramePhase;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// A Pip-Boy–styled FPS counter overlay.
///
/// ## How FPS is measured
/// Uses [SchedulerBinding.addTimingsCallback] to receive [FrameTiming] objects.
/// FPS is derived from the **wall-clock interval between consecutive frame
/// raster-finish timestamps** — NOT the frame work duration (build+raster time).
/// Using work duration would show artificially high numbers on fast GPUs that
/// finish rendering in just a few milliseconds even at a 60 Hz display rate.
///
/// ## Why a periodic timer for setState
/// [SchedulerBinding.addTimingsCallback] fires inside the frame pipeline.
/// Calling [setState] directly from that callback marks the widget dirty
/// during the same frame, which triggers the
/// `!semantics.parentDataDirty` assertion on Windows / desktop.
/// A [Timer.periodic] fires outside the frame pipeline and is safe.
class FpsCounter extends StatefulWidget {
  const FpsCounter({super.key});

  @override
  State<FpsCounter> createState() => _FpsCounterState();
}

class _FpsCounterState extends State<FpsCounter> {
  // Rolling window of frame intervals in µs (rasterFinish[n] - rasterFinish[n-1]).
  final List<int> _intervals = [];
  static const _windowSize = 60;

  // Timestamp (µs) of the previous frame's rasterFinish, or null if first frame.
  int? _prevRasterFinish;

  // Computed FPS, written only by the periodic display timer.
  double _fps = 0;

  // Intermediate value updated by _onTimings; consumed by the display timer.
  double _pendingFps = 0;

  // Timer that updates the widget at ~2 Hz so we don't rebuild every frame.
  Timer? _displayTimer;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
    // Refresh the displayed FPS value twice per second.
    _displayTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted && (_pendingFps - _fps).abs() > 0.5) {
        setState(() => _fps = _pendingFps);
      }
    });
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    super.dispose();
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      final finish = t.timestampInMicroseconds(FramePhase.rasterFinish);
      if (_prevRasterFinish != null) {
        final interval = finish - _prevRasterFinish!;
        // Sanity-clamp: ignore intervals outside 2 Hz – 1000 Hz (500ms – 1ms).
        if (interval >= 1000 && interval <= 500000) {
          _intervals.add(interval);
        }
      }
      _prevRasterFinish = finish;
    }

    while (_intervals.length > _windowSize) {
      _intervals.removeAt(0);
    }

    if (_intervals.isEmpty) return;
    final avgUs = _intervals.reduce((a, b) => a + b) / _intervals.length;
    _pendingFps = avgUs > 0 ? 1e6 / avgUs : 0;
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
          // Square blink dot — Pip-Boy HUD aesthetic (no circles).
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

/// A 6×6 square that fades in and out — sharp Pip-Boy HUD style.
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
      child: SizedBox(
        width: 6,
        height: 6,
        child: ColoredBox(color: widget.color),
      ),
    );
  }
}
