import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

void main() {
  group('PipboyTheme', () {
    test('buildTheme returns a valid ThemeData', () {
      final theme = PipboyTheme.buildTheme();
      expect(theme, isA<ThemeData>());
    });

    test('buildTheme with default palette uses green primary', () {
      final theme = PipboyTheme.buildTheme();
      final ext = theme.extension<PipboyThemeData>();
      expect(ext, isNotNull);
      expect(ext!.palette.isGrayscale, isFalse);
    });

    test('buildTheme with custom palette propagates the palette', () {
      final palette = PipboyColorPalette(const Color(0xFFFFB000));
      final theme = PipboyTheme.buildTheme(palette: palette);
      final ext = theme.extension<PipboyThemeData>();
      expect(ext, isNotNull);
      expect(ext!.palette.primary, equals(palette.primary));
    });

    test('theme uses Material3', () {
      final theme = PipboyTheme.buildTheme();
      expect(theme.useMaterial3, isTrue);
    });

    test('theme brightness is dark', () {
      final theme = PipboyTheme.buildTheme();
      expect(theme.colorScheme.brightness, equals(Brightness.dark));
    });

    test('scaffoldBackgroundColor matches palette background', () {
      final palette = PipboyColorPalette(const Color(0xFF15FF52));
      final theme = PipboyTheme.buildTheme(palette: palette);
      expect(theme.scaffoldBackgroundColor, equals(palette.background));
    });

    test('cardColor matches palette surface', () {
      final palette = PipboyColorPalette(const Color(0xFF15FF52));
      final theme = PipboyTheme.buildTheme(palette: palette);
      expect(theme.cardColor, equals(palette.surface));
    });

    test('colorScheme.primary matches palette.primary', () {
      final palette = PipboyColorPalette(const Color(0xFF00CFFF));
      final theme = PipboyTheme.buildTheme(palette: palette);
      expect(theme.colorScheme.primary, equals(palette.primary));
    });

    test('PipboyThemeData extension is registered', () {
      final theme = PipboyTheme.buildTheme();
      expect(theme.extensions.containsKey(PipboyThemeData), isTrue);
    });
  });

  group('PipboyThemeData', () {
    testWidgets('paletteOf retrieves palette from context', (tester) async {
      final palette = PipboyColorPalette(const Color(0xFF15FF52));
      late PipboyColorPalette retrieved;

      await tester.pumpWidget(
        MaterialApp(
          theme: PipboyTheme.buildTheme(palette: palette),
          home: Builder(
            builder: (context) {
              retrieved = PipboyThemeData.paletteOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrieved.primary, equals(palette.primary));
    });

    test('copyWith overrides palette', () {
      final p1 = PipboyColorPalette(const Color(0xFF15FF52));
      final p2 = PipboyColorPalette(const Color(0xFFFF6600));
      final data = PipboyThemeData(palette: p1);
      final copy = data.copyWith(palette: p2);
      expect(copy.palette.primary, equals(p2.primary));
    });

    test('lerp at t=0 returns original', () {
      final p1 = PipboyColorPalette(const Color(0xFF15FF52));
      final p2 = PipboyColorPalette(const Color(0xFFFF6600));
      final d1 = PipboyThemeData(palette: p1);
      final d2 = PipboyThemeData(palette: p2);
      final result = d1.lerp(d2, 0.0);
      expect(result.palette.primary, equals(p1.primary));
    });

    test('lerp at t=1 returns other', () {
      final p1 = PipboyColorPalette(const Color(0xFF15FF52));
      final p2 = PipboyColorPalette(const Color(0xFFFF6600));
      final d1 = PipboyThemeData(palette: p1);
      final d2 = PipboyThemeData(palette: p2);
      final result = d1.lerp(d2, 1.0);
      expect(result.palette.primary, equals(p2.primary));
    });
  });
}
