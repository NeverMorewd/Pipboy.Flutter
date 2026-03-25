import 'dart:async';

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
///
/// ## Why Timer instead of AnimationController + Opacity
/// `Opacity` delegates to [RenderOpacity], which calls
/// `markNeedsSemanticsUpdate()` every time the opacity value crosses the
/// transparent threshold (0.0).  When a `Positioned` ancestor's parent-data
/// is dirty in the same frame this raises:
///
///   `!semantics.parentDataDirty` assertion in rendering/object.dart
///
/// A [Timer.periodic] toggle avoids [RenderOpacity] entirely: the widget
/// flips between `style.color` and `Colors.transparent` so layout is
/// unaffected and no opacity node is ever created.
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

class _PipboyBlinkTextState extends State<PipboyBlinkText> {
  bool _visible = true;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      if (mounted) setState(() => _visible = !_visible);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _startTimer();
  }

  @override
  void didUpdateWidget(PipboyBlinkText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final enabledChanged = widget.enabled != oldWidget.enabled;
    final intervalChanged = widget.interval != oldWidget.interval;
    if (enabledChanged || (widget.enabled && intervalChanged)) {
      if (widget.enabled) {
        _visible = true;
        _startTimer();
      } else {
        _timer?.cancel();
        _timer = null;
        if (!_visible) setState(() => _visible = true);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final style =
        widget.style ??
        TextStyle(
          fontFamily: PipboyColorPalette.fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          color: palette.primary,
        );

    // Render with transparent color when "off" so layout size is preserved.
    // No Opacity/RenderOpacity involved — avoids the semantics assertion.
    final effectiveColor = _visible ? style.color : Colors.transparent;
    return Text(widget.text, style: style.copyWith(color: effectiveColor));
  }
}
