import 'dart:math' as math;
import 'package:flutter/painting.dart';

/// HSL-space color utilities used by [PipboyColorPalette].
class PipboyHslColor {
  const PipboyHslColor({
    required this.hue,
    required this.saturation,
    required this.lightness,
    this.alpha = 1.0,
  }) : assert(hue >= 0.0 && hue <= 360.0),
       assert(saturation >= 0.0 && saturation <= 1.0),
       assert(lightness >= 0.0 && lightness <= 1.0),
       assert(alpha >= 0.0 && alpha <= 1.0);

  final double hue;
  final double saturation;
  final double lightness;
  final double alpha;

  /// Converts a Flutter [Color] to [PipboyHslColor].
  factory PipboyHslColor.fromColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return PipboyHslColor(
      hue: hsl.hue,
      saturation: hsl.saturation,
      lightness: hsl.lightness,
      alpha: hsl.alpha,
    );
  }

  /// Converts this to a Flutter [Color].
  Color toColor() {
    return HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor();
  }

  /// Returns a copy with overridden fields.
  PipboyHslColor copyWith({
    double? hue,
    double? saturation,
    double? lightness,
    double? alpha,
  }) {
    return PipboyHslColor(
      hue: hue ?? this.hue,
      saturation: saturation ?? this.saturation,
      lightness: lightness ?? this.lightness,
      alpha: alpha ?? this.alpha,
    );
  }
}

/// Monochromatic color palette derived from a single primary [Color].
///
/// All derived colors share the same hue and saturation as the primary color,
/// varying only in lightness. This creates the cohesive Pip-Boy phosphor
/// aesthetic seen in Fallout 4.
///
/// Example:
/// ```dart
/// final palette = PipboyColorPalette(const Color(0xFF15FF52));
/// final theme = PipboyTheme.buildTheme(palette: palette);
/// ```
class PipboyColorPalette {
  /// Default Pip-Boy green (`#15FF52`), the iconic Fallout 4 phosphor color.
  static const Color defaultPrimary = Color(0xFF15FF52);

  /// Constructs a palette from the given [primaryColor].
  factory PipboyColorPalette(Color primaryColor) {
    final hsl = PipboyHslColor.fromColor(primaryColor);
    return PipboyColorPalette._compute(hsl);
  }

  PipboyColorPalette._({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.text,
    required this.textDim,
    required this.hover,
    required this.pressed,
    required this.disabled,
    required this.focus,
    required this.selection,
    required this.border,
    required this.borderFocus,
    required this.error,
    required this.warning,
    required this.success,
    required this.sourceHsl,
  });

  factory PipboyColorPalette._compute(PipboyHslColor hsl) {
    // Saturation scaling: prevents desaturation for low-saturation sources.
    // Gray primaries (S=0) produce a pure grey palette.
    final ss = math.min(hsl.saturation / 0.25, 1.0);

    Color derived({
      double? saturation,
      required double lightness,
      double? alpha,
    }) {
      return hsl
          .copyWith(
            saturation: saturation != null
                ? math.min(saturation, 1.0)
                : hsl.saturation,
            lightness: lightness.clamp(0.0, 1.0),
            alpha: alpha,
          )
          .toColor();
    }

    return PipboyColorPalette._(
      sourceHsl: hsl,
      primary: derived(lightness: hsl.lightness),
      primaryLight: derived(lightness: math.min(hsl.lightness + 0.25, 1.0)),
      primaryDark: derived(lightness: math.max(hsl.lightness - 0.25, 0.0)),
      background: derived(
        saturation: 0.30 * ss * hsl.saturation,
        lightness: 0.05,
      ),
      surface: derived(saturation: 0.28 * ss * hsl.saturation, lightness: 0.09),
      surfaceHigh: derived(
        saturation: 0.25 * ss * hsl.saturation,
        lightness: 0.14,
      ),
      text: derived(saturation: 0.70 * ss * hsl.saturation, lightness: 0.85),
      textDim: derived(saturation: 0.45 * ss * hsl.saturation, lightness: 0.58),
      hover: derived(
        saturation: math.min(hsl.saturation * 0.60, 0.55),
        lightness: 0.20,
      ),
      pressed: derived(
        saturation: math.min(hsl.saturation * 0.50, 0.45),
        lightness: 0.13,
      ),
      disabled: derived(
        saturation: 0.15 * ss * hsl.saturation,
        lightness: 0.35,
      ),
      focus: derived(lightness: math.min(hsl.lightness + 0.30, 0.95)),
      selection: derived(lightness: math.min(hsl.lightness * 0.45, 0.30)),
      border: derived(lightness: math.max(hsl.lightness - 0.10, 0.0)),
      borderFocus: derived(lightness: math.min(hsl.lightness + 0.25, 0.90)),
      error: derived(
        saturation: math.min(hsl.saturation * 1.1 * ss, 0.95),
        lightness: 0.93,
      ),
      warning: derived(
        saturation: math.min(hsl.saturation * 1.1 * ss, 0.95),
        lightness: 0.78,
      ),
      success: derived(
        saturation: math.min(hsl.saturation * 1.1 * ss, 0.95),
        lightness: 0.60,
      ),
    );
  }

  /// The source HSL values for this palette.
  final PipboyHslColor sourceHsl;

  // Core colors
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  // Backgrounds
  final Color background;
  final Color surface;
  final Color surfaceHigh;

  // Text
  final Color text;
  final Color textDim;

  // Interaction states
  final Color hover;
  final Color pressed;
  final Color disabled;
  final Color focus;
  final Color selection;

  // Borders
  final Color border;
  final Color borderFocus;

  // Semantic
  final Color error;
  final Color warning;
  final Color success;

  // Typography constants
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 11.0;
  static const double fontSize = 13.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeH2 = 16.0;
  static const double fontSizeH1 = 20.0;

  // Layout constants
  static const double controlHeight = 30.0;
  static const double popupMaxHeight = 200.0;
  static const double iconStrokeThickness = 1.5;
  static const double disabledOpacity = 0.45;
  static const double dimOpacity = 0.70;

  /// Returns `true` if the primary color has effectively zero saturation.
  bool get isGrayscale => sourceHsl.saturation < 0.01;
}
