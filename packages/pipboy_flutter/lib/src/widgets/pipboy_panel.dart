import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';

/// Visual variant for [PipboyPanel].
enum PipboyPanelVariant {
  /// Default: border uses [PipboyColorPalette.border].
  standard,

  /// Accent: border uses [PipboyColorPalette.primary].
  accent,

  /// Warning: border uses [PipboyColorPalette.warning].
  warning,
}

/// A Pip-Boy styled container panel with a title bar, corner decorations,
/// and optional close button.
///
/// Mirrors the `PipboyPanel` control from the Avalonia library.
///
/// ```dart
/// PipboyPanel(
///   title: 'STATUS',
///   child: Text('HP: 100'),
/// )
/// ```
class PipboyPanel extends StatelessWidget {
  const PipboyPanel({
    super.key,
    required this.title,
    required this.child,
    this.variant = PipboyPanelVariant.standard,
    this.onClose,
    this.footer,
    this.padding = const EdgeInsets.all(14),
    this.minWidth = 160.0,
  });

  final String title;
  final Widget child;
  final PipboyPanelVariant variant;

  /// If non-null, shows a close button `[X]` that calls this callback.
  final VoidCallback? onClose;

  /// Optional footer widget, separated by a top border.
  final Widget? footer;

  final EdgeInsetsGeometry padding;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    final borderColor = switch (variant) {
      PipboyPanelVariant.accent => palette.primary,
      PipboyPanelVariant.warning => palette.warning,
      PipboyPanelVariant.standard => palette.border,
    };

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(
              title: title,
              borderColor: borderColor,
              palette: palette,
              onClose: onClose,
            ),
            _CornerDecorated(
              palette: palette,
              borderColor: borderColor,
              padding: padding,
              child: child,
            ),
            if (footer != null) ...[
              Divider(height: 1, color: borderColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: footer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({
    required this.title,
    required this.borderColor,
    required this.palette,
    this.onClose,
  });

  final String title;
  final Color borderColor;
  final PipboyColorPalette palette;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Text(
            '─[ ',
            style: TextStyle(
              color: palette.textDim,
              fontFamily: 'Courier New',
              fontSize: PipboyColorPalette.fontSizeSmall,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: palette.primary,
              fontFamily: 'Courier New',
              fontSize: PipboyColorPalette.fontSizeSmall,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            ' ]─',
            style: TextStyle(
              color: palette.textDim,
              fontFamily: 'Courier New',
              fontSize: PipboyColorPalette.fontSizeSmall,
            ),
          ),
          const Spacer(),
          if (onClose != null)
            InkWell(
              onTap: onClose,
              child: Text(
                '[X]',
                style: TextStyle(
                  color: palette.textDim,
                  fontFamily: 'Courier New',
                  fontSize: PipboyColorPalette.fontSizeSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CornerDecorated extends StatelessWidget {
  const _CornerDecorated({
    required this.palette,
    required this.borderColor,
    required this.padding,
    required this.child,
  });

  final PipboyColorPalette palette;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(padding: padding, child: child),
        // Top-left corner square
        Positioned(
          top: 3,
          left: 3,
          child: _CornerSquare(color: borderColor),
        ),
        // Top-right corner square
        Positioned(
          top: 3,
          right: 3,
          child: _CornerSquare(color: borderColor),
        ),
        // Bottom-left corner square
        Positioned(
          bottom: 3,
          left: 3,
          child: _CornerSquare(color: borderColor),
        ),
        // Bottom-right corner square
        Positioned(
          bottom: 3,
          right: 3,
          child: _CornerSquare(color: borderColor),
        ),
      ],
    );
  }
}

class _CornerSquare extends StatelessWidget {
  const _CornerSquare({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 5,
      height: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
        ),
      ),
    );
  }
}
