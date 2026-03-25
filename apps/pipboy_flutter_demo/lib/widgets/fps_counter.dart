import 'dart:async';
import 'dart:ui' show FramePhase;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// A Pip-Boy–styled FPS counter overlay.
///
/// ## How FPS is measured
/// Derived from the wall-clock interval between consecutive `rasterFinish`
/// timestamps in [FrameTiming].  Using the frame *work duration*
/// (`totalSpan`) would show artificially high numbers on fast GPUs that
/// finish in a few milliseconds at a 60 Hz display rate.
///
/// ## Why ExcludeSemantics
/// `_BlinkDot` previously used `FadeTransition` with `AnimationController
/// .repeat(reverse: true)`.  `RenderOpacity` calls
/// `markNeedsSemanticsUpdate()` whenever opacity crosses the transparent
/// threshold; while a `Positioned` ancestor's parent-data is dirty in the
/// same layout pass this raises:
///
///   `!semantics.parentDataDirty` assertion in rendering/object.dart
///
/// Wrapping the entire counter in [ExcludeSemantics] prevents it from
/// participating in the accessibility tree at all, so no semantics node is
/// created or updated for this widget — the assertion can never fire.
/// The FPS overlay is a debug HUD; it carries no accessibility value.
///
/// ## Why Timer.periodic for setState
/// [SchedulerBinding.addTimingsCallback] fires *inside* the frame pipeline.
/// Calling [setState] from there marks the widget dirty mid-frame and can
/// still interfere with semantics on some platforms.  A [Timer.periodic]
/// fires from the event loop, well outside any frame build.
class FpsCounter extends StatefulWidget {
  const FpsCounter({super.key});

  @override
  State<FpsCounter> createState() => _FpsCounterState();
}

class _FpsCounterState extends State<FpsCounter> {
  final List<int> _intervals = [];
  static const _windowSize = 60;

  int? _prevRasterFinish;
  double _fps = 0;
  double _pendingFps = 0;
  Timer? _displayTimer;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
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
    final avg = _intervals.reduce((a, b) => a + b) / _intervals.length;
    _pendingFps = avg > 0 ? 1e6 / avg : 0;
  }

  Color _fpsColor(PipboyColorPalette p) {
    if (_fps >= 55) return p.success;
    if (_fps >= 30) return p.warning;
    return p.error;
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final color = _fpsColor(palette);

    // ExcludeSemantics: this is a debug overlay — no accessibility entry
    // needed, and excluding it prevents the !semantics.parentDataDirty
    // assertion that fires when _BlinkDot's opacity animation interacts with
    // the Positioned ancestor's dirty parent-data during the semantics pass.
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: palette.background.withValues(alpha: 0.85),
          border: Border.all(color: color.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BlinkDot(color: color),
            const SizedBox(width: 6),
            Text(
              'FPS  ${_fps.toStringAsFixed(1).padLeft(5)}',
              style: TextStyle(
                fontFamily: PipboyColorPalette.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A 6×6 square indicator that blinks once per second using a [Timer],
/// toggling visibility with [Visibility] rather than [FadeTransition].
///
/// [FadeTransition] + [AnimationController.repeat] calls
/// [RenderOpacity.markNeedsSemanticsUpdate] on every frame, which is the
/// direct trigger for the `!semantics.parentDataDirty` assertion.
/// A plain boolean toggled by a [Timer] avoids any opacity-driven semantics
/// updates entirely.
class _BlinkDot extends StatefulWidget {
  const _BlinkDot({required this.color});
  final Color color;

  @override
  State<_BlinkDot> createState() => _BlinkDotState();
}

class _BlinkDotState extends State<_BlinkDot> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _visible = !_visible);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 6,
      height: 6,
      child: _visible ? ColoredBox(color: widget.color) : null,
    );
  }
}
