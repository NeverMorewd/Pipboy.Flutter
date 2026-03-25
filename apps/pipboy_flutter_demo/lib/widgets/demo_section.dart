import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// A labelled demo section used across all showcase pages.
class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final Widget child;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '// ',
                style: TextStyle(
                  fontFamily: PipboyColorPalette.fontFamily,
                  fontSize: 11,
                  color: palette.textDim,
                ),
              ),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontFamily: PipboyColorPalette.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: palette.textDim,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style: TextStyle(
                fontFamily: PipboyColorPalette.fontFamily,
                fontSize: 10,
                color: palette.textDim.withAlpha(153),
              ),
            ),
          ],
          const SizedBox(height: 10),
          child,
          const SizedBox(height: 12),
          Divider(color: palette.border.withAlpha(77), height: 1),
        ],
      ),
    );
  }
}
