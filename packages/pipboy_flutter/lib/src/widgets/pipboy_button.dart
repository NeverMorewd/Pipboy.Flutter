import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// Button variant for [PipboyButton].
enum PipboyButtonVariant {
  /// Default: surface background, text foreground, simple border.
  standard,

  /// Accent: filled with primary color.
  accent,

  /// Ghost: transparent background, primary color border.
  ghost,

  /// Danger: error-color border and text.
  danger,
}

/// A Pip-Boy styled button with four visual variants.
///
/// This is a convenience wrapper around Flutter's [ElevatedButton] that
/// applies Pip-Boy semantics. For most use-cases the global theme on
/// [ElevatedButton], [OutlinedButton], etc. is sufficient — use this widget
/// when you need the `danger` or named variant API.
///
/// ```dart
/// PipboyButton(
///   onPressed: () {},
///   variant: PipboyButtonVariant.accent,
///   child: Text('CONFIRM'),
/// )
/// ```
class PipboyButton extends StatelessWidget {
  const PipboyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = PipboyButtonVariant.standard,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final PipboyButtonVariant variant;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    final style = switch (variant) {
      PipboyButtonVariant.standard => _standardStyle(palette),
      PipboyButtonVariant.accent => _accentStyle(palette),
      PipboyButtonVariant.ghost => _ghostStyle(palette),
      PipboyButtonVariant.danger => _dangerStyle(palette),
    };

    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      focusNode: focusNode,
      autofocus: autofocus,
      style: style,
      child: child,
    );
  }

  static ButtonStyle _base(PipboyColorPalette p) => const ButtonStyle(
    elevation: WidgetStatePropertyAll(0),
    shadowColor: WidgetStatePropertyAll(Colors.transparent),
    surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    minimumSize: WidgetStatePropertyAll(
      Size(64, PipboyColorPalette.controlHeight),
    ),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
  );

  ButtonStyle _standardStyle(PipboyColorPalette p) => _base(p).copyWith(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return p.pressed;
      if (states.contains(WidgetState.hovered)) return p.hover;
      return p.surface;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return p.disabled;
      return p.text;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: p.disabled.withValues(alpha: 0.30));
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.pressed)) {
        return BorderSide(color: p.primary);
      }
      return BorderSide(color: p.border);
    }),
  );

  ButtonStyle _accentStyle(PipboyColorPalette p) => _base(p).copyWith(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return p.disabled;
      if (states.contains(WidgetState.pressed)) return p.primaryDark;
      if (states.contains(WidgetState.hovered)) return p.primaryLight;
      return p.primary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return p.background.withValues(alpha: 0.70);
      }
      return p.background;
    }),
    side: const WidgetStatePropertyAll(BorderSide.none),
  );

  ButtonStyle _ghostStyle(PipboyColorPalette p) => _base(p).copyWith(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return p.pressed;
      if (states.contains(WidgetState.hovered)) return p.hover;
      return Colors.transparent;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return p.disabled;
      if (states.contains(WidgetState.pressed)) return p.primaryDark;
      if (states.contains(WidgetState.hovered)) return p.primaryLight;
      return p.primary;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: p.disabled.withValues(alpha: 0.30));
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.pressed)) {
        return BorderSide(color: p.borderFocus);
      }
      return BorderSide(color: p.primary);
    }),
  );

  ButtonStyle _dangerStyle(PipboyColorPalette p) => _base(p).copyWith(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return p.pressed;
      if (states.contains(WidgetState.hovered)) return p.hover;
      return p.surface;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return p.disabled;
      return p.error;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: p.disabled.withValues(alpha: 0.30));
      }
      if (states.contains(WidgetState.pressed) ||
          states.contains(WidgetState.hovered)) {
        return BorderSide(color: p.error.withValues(alpha: 0.70));
      }
      return BorderSide(color: p.error);
    }),
  );
}
