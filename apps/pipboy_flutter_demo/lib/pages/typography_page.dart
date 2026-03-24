import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('TYPOGRAPHY')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'Pipboy Heading Widgets',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PipboyH1('Heading 1 (H1)'),
                  SizedBox(height: 8),
                  PipboyH2('Heading 2 (H2)'),
                  SizedBox(height: 8),
                  PipboyAccentText('Accent Text', bold: true),
                  SizedBox(height: 8),
                  PipboyDimText('Dim / Secondary Text'),
                  SizedBox(height: 8),
                  PipboyErrorText('Error Text'),
                  SizedBox(height: 8),
                  PipboyWarningText('Warning Text'),
                  SizedBox(height: 8),
                  PipboySuccessText('Success Text'),
                ],
              ),
            ),
            DemoSection(
              title: 'Material TextTheme Scale',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ThemeRow('displayLarge', tt.displayLarge, palette),
                  _ThemeRow('displayMedium', tt.displayMedium, palette),
                  _ThemeRow('displaySmall', tt.displaySmall, palette),
                  _ThemeRow('headlineLarge', tt.headlineLarge, palette),
                  _ThemeRow('headlineMedium', tt.headlineMedium, palette),
                  _ThemeRow('headlineSmall', tt.headlineSmall, palette),
                  _ThemeRow('titleLarge', tt.titleLarge, palette),
                  _ThemeRow('titleMedium', tt.titleMedium, palette),
                  _ThemeRow('titleSmall', tt.titleSmall, palette),
                  _ThemeRow('bodyLarge', tt.bodyLarge, palette),
                  _ThemeRow('bodyMedium', tt.bodyMedium, palette),
                  _ThemeRow('bodySmall', tt.bodySmall, palette),
                  _ThemeRow('labelLarge', tt.labelLarge, palette),
                  _ThemeRow('labelMedium', tt.labelMedium, palette),
                  _ThemeRow('labelSmall', tt.labelSmall, palette),
                ],
              ),
            ),
            DemoSection(
              title: 'SelectableText',
              child: SelectableText(
                'ROBCO INDUSTRIES (TM) TERMLINK PROTOCOL\n'
                'ENTER PASSWORD NOW\n\n'
                '15 ATTEMPTS REMAINING',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 13,
                  color: palette.primary,
                  height: 1.7,
                ),
              ),
            ),
            DemoSection(
              title: 'RichText',
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 13,
                    color: palette.text,
                  ),
                  children: [
                    const TextSpan(text: 'STATUS: '),
                    TextSpan(
                      text: 'OPERATIONAL',
                      style: TextStyle(
                        color: palette.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '\nALERT: '),
                    TextSpan(
                      text: 'RADIATION DETECTED',
                      style: TextStyle(
                        color: palette.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '\nERROR: '),
                    TextSpan(
                      text: 'SYSTEM FAILURE',
                      style: TextStyle(
                        color: palette.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  const _ThemeRow(this.name, this.style, this.palette);
  final String name;
  final TextStyle? style;
  final PipboyColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 9,
                color: palette.textDim,
              ),
            ),
          ),
          Expanded(child: Text('Aa Bb Cc', style: style)),
        ],
      ),
    );
  }
}
