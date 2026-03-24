import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

void main() {
  group('PipboyThemeManager', () {
    testWidgets('initializes with default green palette', (tester) async {
      late PipboyThemeManagerState manager;

      await tester.pumpWidget(
        PipboyThemeManager(
          child: Builder(
            builder: (context) {
              manager = PipboyThemeManager.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(manager.primaryColor,
          equals(PipboyColorPalette.defaultPrimary));
    });

    testWidgets('initializes with custom color', (tester) async {
      const custom = Color(0xFFFFB000);
      late PipboyThemeManagerState manager;

      await tester.pumpWidget(
        PipboyThemeManager(
          initialColor: custom,
          child: Builder(
            builder: (context) {
              manager = PipboyThemeManager.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(manager.primaryColor, equals(custom));
    });

    testWidgets('setPrimaryColor updates theme', (tester) async {
      const newColor = Color(0xFFFF6600);
      late PipboyThemeManagerState manager;

      await tester.pumpWidget(
        PipboyThemeManager(
          child: Builder(
            builder: (context) {
              manager = PipboyThemeManager.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      manager.setPrimaryColor(newColor);
      await tester.pump();

      expect(manager.primaryColor, equals(newColor));
      expect(manager.palette.primary, isNotNull);
    });

    testWidgets('setPrimaryColor with same color is a no-op', (tester) async {
      late PipboyThemeManagerState manager;

      await tester.pumpWidget(
        PipboyThemeManager(
          child: Builder(
            builder: (context) {
              manager = PipboyThemeManager.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      final themeBefore = manager.currentTheme;
      manager.setPrimaryColor(PipboyColorPalette.defaultPrimary);
      await tester.pump();

      // Same object reference since no rebuild was triggered.
      expect(manager.currentTheme, same(themeBefore));
    });

    testWidgets('presets map contains 8 entries', (tester) async {
      expect(PipboyThemeManager.presets.length, equals(8));
    });

    testWidgets('maybeOf returns null when not in tree', (tester) async {
      late PipboyThemeManagerState? result;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            result = PipboyThemeManager.maybeOf(context);
            return const SizedBox();
          },
        ),
      );

      expect(result, isNull);
    });
  });
}
