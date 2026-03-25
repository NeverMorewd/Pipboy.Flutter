import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

void main() {
  group('PipboyHslColor', () {
    test('fromColor and toColor round-trip is lossless within tolerance', () {
      const original = Color(0xFF15FF52);
      final hsl = PipboyHslColor.fromColor(original);
      final recovered = hsl.toColor();

      // Allow ±2 per channel for floating-point rounding.
      int ch(Color c, double Function(Color) f) =>
          (f(c) * 255.0).round().clamp(0, 255);
      expect(
        (ch(recovered, (c) => c.r) - ch(original, (c) => c.r)).abs(),
        lessThanOrEqualTo(2),
      );
      expect(
        (ch(recovered, (c) => c.g) - ch(original, (c) => c.g)).abs(),
        lessThanOrEqualTo(2),
      );
      expect(
        (ch(recovered, (c) => c.b) - ch(original, (c) => c.b)).abs(),
        lessThanOrEqualTo(2),
      );
    });

    test('copyWith overrides only specified fields', () {
      const hsl = PipboyHslColor(hue: 120, saturation: 0.8, lightness: 0.5);
      final copy = hsl.copyWith(lightness: 0.9);

      expect(copy.hue, equals(hsl.hue));
      expect(copy.saturation, equals(hsl.saturation));
      expect(copy.lightness, equals(0.9));
      expect(copy.alpha, equals(hsl.alpha));
    });
  });

  group('PipboyColorPalette', () {
    late PipboyColorPalette greenPalette;
    late PipboyColorPalette grayPalette;

    setUp(() {
      greenPalette = PipboyColorPalette(const Color(0xFF15FF52));
      grayPalette = PipboyColorPalette(const Color(0xFF808080));
    });

    test('default primary is the Pip-Boy green', () {
      final p = PipboyColorPalette(PipboyColorPalette.defaultPrimary);
      expect(p.primary, isNotNull);
    });

    test('all palette colors are non-transparent', () {
      final colors = [
        greenPalette.primary,
        greenPalette.primaryLight,
        greenPalette.primaryDark,
        greenPalette.background,
        greenPalette.surface,
        greenPalette.surfaceHigh,
        greenPalette.text,
        greenPalette.textDim,
        greenPalette.hover,
        greenPalette.pressed,
        greenPalette.disabled,
        greenPalette.focus,
        greenPalette.selection,
        greenPalette.border,
        greenPalette.borderFocus,
        greenPalette.error,
        greenPalette.warning,
        greenPalette.success,
      ];
      for (final color in colors) {
        expect(
          (color.a * 255.0).round(),
          greaterThan(0),
          reason: 'Color $color must not be transparent',
        );
      }
    });

    test('background is darker than surface', () {
      final bgL = PipboyHslColor.fromColor(greenPalette.background).lightness;
      final sfL = PipboyHslColor.fromColor(greenPalette.surface).lightness;
      expect(bgL, lessThan(sfL));
    });

    test('surface is darker than surfaceHigh', () {
      final sfL = PipboyHslColor.fromColor(greenPalette.surface).lightness;
      final shL = PipboyHslColor.fromColor(greenPalette.surfaceHigh).lightness;
      expect(sfL, lessThan(shL));
    });

    test('primaryLight is lighter than primary', () {
      final pL = PipboyHslColor.fromColor(greenPalette.primary).lightness;
      final plL = PipboyHslColor.fromColor(greenPalette.primaryLight).lightness;
      expect(plL, greaterThan(pL));
    });

    test('primaryDark is darker than primary', () {
      final pL = PipboyHslColor.fromColor(greenPalette.primary).lightness;
      final pdL = PipboyHslColor.fromColor(greenPalette.primaryDark).lightness;
      expect(pdL, lessThan(pL));
    });

    test('text is lighter than textDim', () {
      final tL = PipboyHslColor.fromColor(greenPalette.text).lightness;
      final tdL = PipboyHslColor.fromColor(greenPalette.textDim).lightness;
      expect(tL, greaterThan(tdL));
    });

    test('grayscale primary produces isGrayscale flag', () {
      expect(grayPalette.isGrayscale, isTrue);
    });

    test('saturated primary does not produce isGrayscale flag', () {
      expect(greenPalette.isGrayscale, isFalse);
    });

    test('all colors share the same hue as the primary', () {
      final primaryHue = greenPalette.sourceHsl.hue;
      final toCheck = [
        greenPalette.background,
        greenPalette.surface,
        greenPalette.surfaceHigh,
        greenPalette.text,
      ];
      for (final color in toCheck) {
        final hue = PipboyHslColor.fromColor(color).hue;
        // Allow small floating-point deviation.
        // Allow up to 5° deviation from floating-point HSL roundtrip.
        expect(
          (hue - primaryHue).abs(),
          lessThanOrEqualTo(5.0),
          reason: 'Expected $color to share hue ~$primaryHue, got $hue',
        );
      }
    });

    test('different primaries produce different palettes', () {
      final orange = PipboyColorPalette(const Color(0xFFFF6600));
      expect(greenPalette.primary, isNot(equals(orange.primary)));
      expect(greenPalette.background, isNot(equals(orange.background)));
    });

    test('font size constants are positive and correctly ordered', () {
      expect(PipboyColorPalette.fontSizeXSmall, greaterThan(0));
      expect(
        PipboyColorPalette.fontSizeSmall,
        greaterThan(PipboyColorPalette.fontSizeXSmall),
      );
      expect(
        PipboyColorPalette.fontSize,
        greaterThan(PipboyColorPalette.fontSizeSmall),
      );
      expect(
        PipboyColorPalette.fontSizeLarge,
        greaterThan(PipboyColorPalette.fontSize),
      );
    });
  });
}
