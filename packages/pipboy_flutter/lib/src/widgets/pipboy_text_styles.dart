import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';

/// Typography helper widgets for the Pip-Boy design system.
///
/// These map directly to the Avalonia style classes:
/// `h1`, `h2`, `dim`, `accent`, `error`, `warning`, `success`.

/// Heading 1 — 20px bold, primary color.
class PipboyH1 extends StatelessWidget {
  const PipboyH1(this.text, {super.key, this.textAlign});
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: PipboyColorPalette.fontSizeH1,
        fontWeight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 2.0,
      ),
    );
  }
}

/// Heading 2 — 16px bold, primary color.
class PipboyH2 extends StatelessWidget {
  const PipboyH2(this.text, {super.key, this.textAlign});
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: PipboyColorPalette.fontSizeH2,
        fontWeight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 1.5,
      ),
    );
  }
}

/// Dim text — secondary / label text at reduced lightness.
class PipboyDimText extends StatelessWidget {
  const PipboyDimText(this.text, {super.key, this.textAlign, this.fontSize});
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: fontSize ?? PipboyColorPalette.fontSize,
        color: p.textDim,
      ),
    );
  }
}

/// Accent text — primary color.
class PipboyAccentText extends StatelessWidget {
  const PipboyAccentText(
    this.text, {
    super.key,
    this.textAlign,
    this.fontSize,
    this.bold = false,
  });
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: fontSize ?? PipboyColorPalette.fontSize,
        color: p.primary,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

/// Error text — error color.
class PipboyErrorText extends StatelessWidget {
  const PipboyErrorText(this.text, {super.key, this.textAlign});
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: PipboyColorPalette.fontSize,
        color: p.error,
      ),
    );
  }
}

/// Warning text — warning color.
class PipboyWarningText extends StatelessWidget {
  const PipboyWarningText(this.text, {super.key, this.textAlign});
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: PipboyColorPalette.fontSize,
        color: p.warning,
      ),
    );
  }
}

/// Success text — success color.
class PipboySuccessText extends StatelessWidget {
  const PipboySuccessText(this.text, {super.key, this.textAlign});
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Courier New',
        fontSize: PipboyColorPalette.fontSize,
        color: p.success,
      ),
    );
  }
}

/// A card-style container matching the `.card` class in Avalonia.
class PipboyCard extends StatelessWidget {
  const PipboyCard({super.key, required this.child, this.elevated = false});
  final Widget child;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: elevated ? p.surfaceHigh : p.surface,
        border: Border.all(color: elevated ? p.primaryDark : p.border),
      ),
      child: child,
    );
  }
}

/// A HUD-style container (compact, `.hud` class equivalent).
class PipboyHud extends StatelessWidget {
  const PipboyHud({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
      ),
      child: child,
    );
  }
}
