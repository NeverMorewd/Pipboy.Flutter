import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/widgets/pipboy_blink_text.dart';

/// A terminal-styled container that optionally types out its content
/// character by character (typewriter effect).
///
/// Mirrors the Avalonia `TerminalPanel` control.
///
/// ```dart
/// PipboyTerminalPanel(
///   lines: [
///     'ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM',
///     'COPYRIGHT 2075-2077 ROBCO INDUSTRIES',
///     '> _',
///   ],
/// )
/// ```
class PipboyTerminalPanel extends StatefulWidget {
  const PipboyTerminalPanel({
    super.key,
    required this.lines,
    this.typewriter = true,
    this.typewriterSpeed = const Duration(milliseconds: 30),
    this.showCursor = true,
    this.padding = const EdgeInsets.all(16),
    this.minHeight,
    this.maxHeight,
  });

  final List<String> lines;
  final bool typewriter;
  final Duration typewriterSpeed;
  final bool showCursor;
  final EdgeInsetsGeometry padding;
  final double? minHeight;
  final double? maxHeight;

  @override
  State<PipboyTerminalPanel> createState() => _PipboyTerminalPanelState();
}

class _PipboyTerminalPanelState extends State<PipboyTerminalPanel> {
  int _visibleChars = 0;
  late String _fullText;

  @override
  void initState() {
    super.initState();
    _fullText = widget.lines.join('\n');
    if (widget.typewriter) {
      _startTypewriter();
    } else {
      _visibleChars = _fullText.length;
    }
  }

  @override
  void didUpdateWidget(PipboyTerminalPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lines != widget.lines) {
      _fullText = widget.lines.join('\n');
      _visibleChars = 0;
      if (widget.typewriter)
        _startTypewriter();
      else
        setState(() => _visibleChars = _fullText.length);
    }
  }

  void _startTypewriter() {
    Future.doWhile(() async {
      if (!mounted) return false;
      if (_visibleChars >= _fullText.length) return false;
      await Future.delayed(widget.typewriterSpeed);
      if (!mounted) return false;
      setState(() => _visibleChars++);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final displayText = _fullText.substring(0, _visibleChars);
    final isComplete = _visibleChars >= _fullText.length;

    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? 0,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border.all(color: palette.primary),
      ),
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayText,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: PipboyColorPalette.fontSize,
              color: palette.primary,
              height: 1.6,
            ),
          ),
          if (widget.showCursor)
            PipboyBlinkText(
              '_',
              enabled: isComplete,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: PipboyColorPalette.fontSize,
                color: palette.primary,
              ),
            ),
        ],
      ),
    );
  }
}
