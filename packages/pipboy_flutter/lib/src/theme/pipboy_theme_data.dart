import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';

/// A [ThemeExtension] that makes the full [PipboyColorPalette] available
/// anywhere in the widget tree via `Theme.of(context).extension<PipboyThemeData>()`.
class PipboyThemeData extends ThemeExtension<PipboyThemeData> {
  const PipboyThemeData({required this.palette});

  final PipboyColorPalette palette;

  @override
  PipboyThemeData copyWith({PipboyColorPalette? palette}) {
    return PipboyThemeData(palette: palette ?? this.palette);
  }

  @override
  PipboyThemeData lerp(PipboyThemeData? other, double t) {
    if (other == null) return this;
    // For simplicity we snap at t=1; true color interpolation would require
    // per-field Color.lerp calls across all 18 palette entries.
    return t < 0.5 ? this : other;
  }

  /// Retrieves [PipboyThemeData] from the nearest [BuildContext].
  /// Throws if the extension is not registered on the current [ThemeData].
  static PipboyThemeData of(BuildContext context) {
    final ext = Theme.of(context).extension<PipboyThemeData>();
    assert(
      ext != null,
      'PipboyThemeData not found. '
      'Make sure you are using PipboyTheme.buildTheme() as your MaterialApp theme.',
    );
    return ext!;
  }

  /// Retrieves the [PipboyColorPalette] from the nearest [BuildContext].
  static PipboyColorPalette paletteOf(BuildContext context) =>
      of(context).palette;
}
