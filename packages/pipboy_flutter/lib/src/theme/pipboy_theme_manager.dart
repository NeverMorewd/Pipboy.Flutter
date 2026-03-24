import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme.dart';

/// Manages runtime Pip-Boy theme color switching.
///
/// Wrap your [MaterialApp] with [PipboyThemeManager] and use
/// [PipboyThemeManager.of] to update the primary color at any time.
///
/// ```dart
/// PipboyThemeManager(
///   child: Builder(
///     builder: (context) => MaterialApp(
///       theme: PipboyThemeManager.of(context).currentTheme,
///       home: const MyHome(),
///     ),
///   ),
/// )
/// ```
class PipboyThemeManager extends StatefulWidget {
  const PipboyThemeManager({
    super.key,
    required this.child,
    this.initialColor = PipboyColorPalette.defaultPrimary,
  });

  final Widget child;
  final Color initialColor;

  /// Retrieves the nearest [PipboyThemeManagerState] from the widget tree.
  static PipboyThemeManagerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<PipboyThemeManagerState>();
    assert(
      state != null,
      'PipboyThemeManager not found in widget tree. '
      'Wrap your app with PipboyThemeManager.',
    );
    return state!;
  }

  /// Returns null if no [PipboyThemeManager] is in the tree.
  static PipboyThemeManagerState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<PipboyThemeManagerState>();

  /// Preset Pip-Boy color themes, accessible without a [BuildContext].
  static const Map<String, Color> presets = {
    'Green (Classic)': Color(0xFF15FF52),
    'Amber (Fallout 3)': Color(0xFFFFB000),
    'Blue (Institute)': Color(0xFF00CFFF),
    'Red (Alert)': Color(0xFFFF3030),
    'White (Terminal)': Color(0xFFDDDDDD),
    'Purple (Vault)': Color(0xFFBB88FF),
    'Orange (Fire)': Color(0xFFFF6600),
    'Cyan (Water)': Color(0xFF00FFD0),
  };

  @override
  State<PipboyThemeManager> createState() => PipboyThemeManagerState();
}

class PipboyThemeManagerState extends State<PipboyThemeManager> {
  late Color _primaryColor;
  late PipboyColorPalette _palette;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _primaryColor = widget.initialColor;
    _palette = PipboyColorPalette(_primaryColor);
    _theme = PipboyTheme.buildTheme(palette: _palette);
  }

  /// The currently active primary color.
  Color get primaryColor => _primaryColor;

  /// The currently active palette.
  PipboyColorPalette get palette => _palette;

  /// The currently active [ThemeData].
  ThemeData get currentTheme => _theme;

  /// Updates the primary color and rebuilds the theme.
  void setPrimaryColor(Color color) {
    if (color == _primaryColor) return;
    setState(() {
      _primaryColor = color;
      _palette = PipboyColorPalette(color);
      _theme = PipboyTheme.buildTheme(palette: _palette);
    });
  }

  /// Preset Pip-Boy color themes.
  static const Map<String, Color> presets = {
    'Green (Classic)': Color(0xFF15FF52),
    'Amber (Fallout 3)': Color(0xFFFFB000),
    'Blue (Institute)': Color(0xFF00CFFF),
    'Red (Alert)': Color(0xFFFF3030),
    'White (Terminal)': Color(0xFFDDDDDD),
    'Purple (Vault)': Color(0xFFBB88FF),
    'Orange (Fire)': Color(0xFFFF6600),
    'Cyan (Water)': Color(0xFF00FFD0),
  };

  @override
  Widget build(BuildContext context) => widget.child;
}
