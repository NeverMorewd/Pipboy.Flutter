import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';

/// Precision level for displaying the countdown.
enum PipboyCountdownPrecision {
  /// `HH:MM:SS`
  seconds,

  /// `HH:MM:SS.t`
  tenths,

  /// `HH:MM:SS.tt`
  hundredths,
}

/// A countdown timer widget with Pip-Boy digital display styling.
///
/// Mirrors the Avalonia `PipboyCountdown` control.
///
/// ```dart
/// PipboyCountdown(
///   duration: Duration(minutes: 5),
///   onComplete: () => print('DETONATION'),
/// )
/// ```
class PipboyCountdown extends StatefulWidget {
  const PipboyCountdown({
    super.key,
    required this.duration,
    this.precision = PipboyCountdownPrecision.seconds,
    this.autoStart = true,
    this.onComplete,
    this.label,
    this.fontSize,
    this.color,
  });

  final Duration duration;
  final PipboyCountdownPrecision precision;
  final bool autoStart;
  final VoidCallback? onComplete;
  final String? label;
  final double? fontSize;
  final Color? color;

  @override
  State<PipboyCountdown> createState() => PipboyCountdownState();
}

class PipboyCountdownState extends State<PipboyCountdown> {
  late Duration _remaining;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    if (widget.autoStart) start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Starts or resumes the countdown.
  void start() {
    if (_running || _remaining == Duration.zero) return;
    _running = true;
    final tickMs = switch (widget.precision) {
      PipboyCountdownPrecision.seconds => 1000,
      PipboyCountdownPrecision.tenths => 100,
      PipboyCountdownPrecision.hundredths => 10,
    };
    _timer = Timer.periodic(Duration(milliseconds: tickMs), (_) {
      if (!mounted) {
        _timer?.cancel();
        return;
      }
      final next = _remaining - Duration(milliseconds: tickMs);
      if (next <= Duration.zero) {
        setState(() {
          _remaining = Duration.zero;
          _running = false;
        });
        _timer?.cancel();
        widget.onComplete?.call();
      } else {
        setState(() => _remaining = next);
      }
    });
  }

  /// Pauses the countdown.
  void pause() {
    _timer?.cancel();
    _running = false;
  }

  /// Resets to the original duration.
  void reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.duration;
      _running = false;
    });
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');

    return switch (widget.precision) {
      PipboyCountdownPrecision.seconds => '$h:$m:$s',
      PipboyCountdownPrecision.tenths =>
        '$h:$m:$s.${((d.inMilliseconds % 1000) ~/ 100)}',
      PipboyCountdownPrecision.hundredths =>
        '$h:$m:$s.${((d.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0')}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final textColor = widget.color ??
        (_remaining == Duration.zero ? palette.error : palette.primary);
    final fontSize = widget.fontSize ?? PipboyColorPalette.fontSizeH1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: PipboyColorPalette.fontSizeSmall,
              color: palette.textDim,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          _format(_remaining),
          style: TextStyle(
            fontFamily: 'Courier New',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}
