import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// A text widget that blinks at a configurable interval.
///
/// Matches the Avalonia `BlinkText` control.
///
/// ```dart
/// PipboyBlinkText(
///   '>> LOADING <<',
///   interval: Duration(milliseconds: 500),
/// )
/// ```
class PipboyBlinkText extends StatefulWidget {
  const PipboyBlinkText(
    this.text, {
    super.key,
    this.interval = const Duration(milliseconds: 600),
    this.style,
    this.enabled = true,
  });

  final String text;
  final Duration interval;
  final TextStyle? style;

  /// When `false` the text is always visible (no blinking).
  final bool enabled;

  @override
  State<PipboyBlinkText> createState() => _PipboyBlinkTextState();
}

class _PipboyBlinkTextState extends State<PipboyBlinkText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.interval)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    if (widget.enabled) _controller.forward();
  }

  @override
  void didUpdateWidget(PipboyBlinkText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.forward();
      } else {
        _controller.stop();
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final style =
        widget.style ??
        TextStyle(
          fontFamily: 'Courier New',
          fontSize: PipboyColorPalette.fontSize,
          color: palette.primary,
        );

    if (!widget.enabled) {
      return Text(widget.text, style: style);
    }

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) => Opacity(
        opacity: _opacity.value,
        child: Text(widget.text, style: style),
      ),
    );
  }
}
