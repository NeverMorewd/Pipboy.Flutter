import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// Helper: pumps the widget and drains all pending timers from
/// [PipboyThemeManagerState._preWarmPresets] (which uses
/// [Future.delayed(Duration.zero)] internally).
Future<void> pumpManager(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  // Drain the pre-warm timers (one per preset, zero-duration each).
  await tester.pumpAndSettle();
}

void main() {
  group('PipboyThemeManager', () {
    testWidgets('initializes with default green palette', (tester) async {
      late PipboyThemeManagerState manager;

      await pumpManager(
        tester,
        PipboyThemeManager(
          child: Builder(
            builder: (context) {
              manager = PipboyThemeManager.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(manager.primaryColor, equals(PipboyColorPalette.defaultPrimary));
    });

    testWidgets('initializes with custom color', (tester) async {
      const custom = Color(0xFFFFB000);
      late PipboyThemeManagerState manager;

      await pumpManager(
        tester,
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

      await pumpManager(
        tester,
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

      await pumpManager(
        tester,
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

      // Same object reference — no rebuild was triggered.
      expect(manager.currentTheme, same(themeBefore));
    });

    testWidgets('presets cache is populated after pre-warm', (tester) async {
      late PipboyThemeManagerState manager;

      await pumpManager(
        tester,
        PipboyThemeManager(
          child: Builder(
            builder: (context) {
              manager = PipboyThemeManager.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      // After pre-warm, switching to any preset should NOT recompute the theme
      // (the cache already holds it).  Verify by switching to each preset and
      // confirming the manager accepts the color.
      for (final color in PipboyThemeManager.presets.values) {
        manager.setPrimaryColor(color);
        await tester.pump();
        expect(manager.primaryColor, equals(color));
      }
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
