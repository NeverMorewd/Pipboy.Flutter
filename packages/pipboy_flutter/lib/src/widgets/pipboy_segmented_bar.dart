import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// A discrete segmented progress bar styled after the HP/AP/RAD bars
/// in the Pip-Boy HUD.
///
/// Displays [segmentCount] rectangular segments, filling [value] of them
/// (proportionally).
///
/// ```dart
/// PipboySegmentedBar(
///   value: 0.65,
///   segmentCount: 20,
///   label: 'HP',
/// )
/// ```
class PipboySegmentedBar extends StatelessWidget {
  const PipboySegmentedBar({
    super.key,
    required this.value,
    this.segmentCount = 20,
    this.label,
    this.height = 14.0,
    this.segmentGap = 2.0,
    this.color,
    this.emptyColor,
    this.showLabel = true,
  }) : assert(value >= 0.0 && value <= 1.0);

  /// Fill level from 0.0 to 1.0.
  final double value;

  /// Total number of segments.
  final int segmentCount;

  /// Optional label displayed to the left (e.g. `'HP'`).
  final String? label;

  /// Height of the bar.
  final double height;

  /// Gap between segments in logical pixels.
  final double segmentGap;

  /// Override the filled segment color.
  final Color? color;

  /// Override the empty segment color.
  final Color? emptyColor;

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final filledColor = color ?? palette.primary;
    final unfilledColor = emptyColor ?? palette.border;

    final filledCount = (segmentCount * value).round().clamp(0, segmentCount);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && showLabel) ...[
          SizedBox(
            width: 32,
            child: Text(
              label!,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: PipboyColorPalette.fontSizeSmall,
                color: palette.textDim,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: CustomPaint(
            size: Size.fromHeight(height),
            painter: _SegmentedBarPainter(
              segmentCount: segmentCount,
              filledCount: filledCount,
              filledColor: filledColor,
              emptyColor: unfilledColor,
              gap: segmentGap,
            ),
          ),
        ),
      ],
    );
  }
}

class _SegmentedBarPainter extends CustomPainter {
  const _SegmentedBarPainter({
    required this.segmentCount,
    required this.filledCount,
    required this.filledColor,
    required this.emptyColor,
    required this.gap,
  });

  final int segmentCount;
  final int filledCount;
  final Color filledColor;
  final Color emptyColor;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    if (segmentCount <= 0) return;

    final totalGaps = (segmentCount - 1) * gap;
    final segmentWidth = (size.width - totalGaps) / segmentCount;

    for (var i = 0; i < segmentCount; i++) {
      final left = i * (segmentWidth + gap);
      final rect = Rect.fromLTWH(left, 0, segmentWidth, size.height);
      final paint = Paint()
        ..color = i < filledCount ? filledColor : emptyColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_SegmentedBarPainter oldDelegate) =>
      oldDelegate.filledCount != filledCount ||
      oldDelegate.filledColor != filledColor ||
      oldDelegate.emptyColor != emptyColor ||
      oldDelegate.segmentCount != segmentCount ||
      oldDelegate.gap != gap;
}
