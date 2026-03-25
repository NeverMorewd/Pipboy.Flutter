import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// Displays a S.P.E.C.I.A.L.-style attribute with dot indicators.
///
/// Shows a row of filled/empty dots representing a rated value,
/// matching the Avalonia `RatedAttribute` control.
///
/// ```dart
/// PipboyRatedAttribute(
///   label: 'STR',
///   value: 7,
///   maxValue: 10,
/// )
/// ```
class PipboyRatedAttribute extends StatelessWidget {
  const PipboyRatedAttribute({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 10,
    this.dotSize = 10.0,
    this.dotGap = 4.0,
    this.color,
  }) : assert(value >= 0 && value <= maxValue);

  final String label;
  final int value;
  final int maxValue;
  final double dotSize;
  final double dotGap;

  /// Override dot fill color (defaults to [PipboyColorPalette.primary]).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final dotColor = color ?? palette.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: PipboyColorPalette.fontSizeSmall,
              color: palette.textDim,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(maxValue, (i) {
          final filled = i < value;
          return Padding(
            padding: EdgeInsets.only(right: i < maxValue - 1 ? dotGap : 0),
            child: _Dot(
              size: dotSize,
              filled: filled,
              color: dotColor,
              emptyColor: palette.border,
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          '$value',
          style: TextStyle(
            fontFamily: 'Courier New',
            fontSize: PipboyColorPalette.fontSizeSmall,
            color: palette.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.size,
    required this.filled,
    required this.color,
    required this.emptyColor,
  });

  final double size;
  final bool filled;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          border: Border.all(color: filled ? color : emptyColor),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
