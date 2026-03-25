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
///
/// ## Why no Opacity widget
/// `Opacity` delegates to [RenderOpacity], which calls
/// `markNeedsSemanticsUpdate()` whenever the opacity crosses the transparent
/// threshold (0.0 ↔ non-zero).  When a `Positioned` or `Stack` ancestor's
/// parent-data is dirty in the same frame this raises:
///
///   `!semantics.parentDataDirty` assertion in rendering/object.dart
///
/// The fix encodes fade transparency directly into the [TextStyle] color
/// alpha so no [RenderOpacity] node is created.
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
        // Encode fade as text color alpha — avoids RenderOpacity entirely.
        final Color? fadeColor = bracketStyle.color?.withValues(
          alpha: _fade.value,
        );
        final TextStyle fadedStyle = bracketStyle.copyWith(color: fadeColor);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left bracket: slides in from left, fades via color alpha.
            ClipRect(
              child: Align(
                widthFactor: _slide.value,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text('>', style: fadedStyle),
                ),
              ),
            ),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: widget.selected ? palette.primary : palette.text,
              ),
              child: widget.child,
            ),
            // Right bracket: slides in from right, fades via color alpha.
            ClipRect(
              child: Align(
                widthFactor: _slide.value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text('<', style: fadedStyle),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
