import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// Wraps a widget with animated Pip-Boy bracket indicators `> ... <`.
///
/// When [selected] is true the brackets slide in from outside and the child
/// is highlighted. Mirrors the Avalonia `BracketHighlight` control.
///
/// ```dart
/// PipboyBracketHighlight(
///   selected: _isSelected,
///   child: Text('ITEMS'),
/// )
/// ```
class PipboyBracketHighlight extends StatefulWidget {
  const PipboyBracketHighlight({
    super.key,
    required this.child,
    this.selected = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.bracketStyle,
  });

  final Widget child;
  final bool selected;
  final Duration animationDuration;
  final TextStyle? bracketStyle;

  @override
  State<PipboyBracketHighlight> createState() => _PipboyBracketHighlightState();
}

class _PipboyBracketHighlightState extends State<PipboyBracketHighlight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _slide = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.selected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(PipboyBracketHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    final bracketStyle =
        widget.bracketStyle ??
        TextStyle(
          fontFamily: PipboyColorPalette.fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          color: palette.primary,
          fontWeight: FontWeight.bold,
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left bracket fades and slides from left
            ClipRect(
              child: Align(
                widthFactor: _slide.value,
                child: Opacity(
                  opacity: _fade.value,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text('>', style: bracketStyle),
                  ),
                ),
              ),
            ),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: widget.selected ? palette.primary : palette.text,
              ),
              child: widget.child,
            ),
            // Right bracket fades and slides from right
            ClipRect(
              child: Align(
                widthFactor: _slide.value,
                child: Opacity(
                  opacity: _fade.value,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('<', style: bracketStyle),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
