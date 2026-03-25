import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = PipboyThemeManager.of(context);
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('THEME')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'Preset Colors',
              description:
                  'Tap any preset to switch the primary color at runtime.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PipboyThemeManager.presets.entries.map((entry) {
                  final isActive = manager.primaryColor == entry.value;
                  return InkWell(
                    onTap: () => manager.setPrimaryColor(entry.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? palette.selection : palette.surface,
                        border: Border.all(
                          color: isActive ? entry.value : palette.border,
                          width: isActive ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: entry.value,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.key.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 10,
                              color: isActive ? palette.primary : palette.text,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            DemoSection(
              title: 'Current Palette',
              child: _PaletteDisplay(palette: palette),
            ),
            DemoSection(
              title: 'Live Preview',
              child: Column(
                children: [
                  PipboyPanel(
                    title: 'PREVIEW',
                    variant: PipboyPanelVariant.accent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PipboyH1('Pip-Boy UI'),
                        const SizedBox(height: 4),
                        PipboyDimText('Current primary color applied.'),
                        const SizedBox(height: 12),
                        PipboySegmentedBar(value: 0.72, label: 'HP'),
                        const SizedBox(height: 8),
                        PipboySegmentedBar(value: 0.45, label: 'AP'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            PipboyButton(
                              variant: PipboyButtonVariant.accent,
                              onPressed: () {},
                              child: const Text('ACCEPT'),
                            ),
                            const SizedBox(width: 8),
                            PipboyButton(
                              variant: PipboyButtonVariant.ghost,
                              onPressed: () {},
                              child: const Text('CANCEL'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteDisplay extends StatelessWidget {
  const _PaletteDisplay({required this.palette});
  final PipboyColorPalette palette;

  @override
  Widget build(BuildContext context) {
    final swatches = [
      ('primary', palette.primary),
      ('primaryLight', palette.primaryLight),
      ('primaryDark', palette.primaryDark),
      ('background', palette.background),
      ('surface', palette.surface),
      ('surfaceHigh', palette.surfaceHigh),
      ('text', palette.text),
      ('textDim', palette.textDim),
      ('hover', palette.hover),
      ('pressed', palette.pressed),
      ('disabled', palette.disabled),
      ('border', palette.border),
      ('borderFocus', palette.borderFocus),
      ('error', palette.error),
      ('warning', palette.warning),
      ('success', palette.success),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: swatches.map((s) {
        return Tooltip(
          message: s.$1,
          child: Container(
            width: 48,
            height: 48,
            color: s.$2,
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                s.$1.substring(0, s.$1.length.clamp(0, 7)),
                style: const TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 7,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
