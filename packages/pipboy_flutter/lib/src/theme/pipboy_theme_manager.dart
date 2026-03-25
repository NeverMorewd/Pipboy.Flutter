import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme.dart';

/// Manages runtime Pip-Boy theme color switching.
///
/// Wrap your [MaterialApp] (or the widget that reads [currentTheme]) with
/// [PipboyThemeManager].  Call [PipboyThemeManager.of] to read the current
/// state or trigger a color change.
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
///
/// ## Reactivity
/// Uses [InheritedWidget] internally so every widget that calls
/// [PipboyThemeManager.of] is automatically rebuilt when the primary color
/// changes.
///
/// ## Performance (WASM / web)
/// All eight preset [ThemeData] objects are pre-computed lazily after the
/// first frame — one per event-loop tick — so button clicks are instant even
/// on WASM where there is no JIT compiler.
class PipboyThemeManager extends StatefulWidget {
  const PipboyThemeManager({
    super.key,
    required this.child,
    this.initialColor = PipboyColorPalette.defaultPrimary,
  });

  final Widget child;
  final Color initialColor;

  /// Returns the nearest [PipboyThemeManagerState] and subscribes the calling
  /// widget to future color changes via [InheritedWidget] dependency tracking.
  static PipboyThemeManagerState of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_PipboyThemeScope>();
    assert(
      scope != null,
      'PipboyThemeManager not found in widget tree. '
      'Wrap your app with PipboyThemeManager.',
    );
    return scope!.state;
  }

  /// Like [of] but returns null instead of throwing when not in the tree.
  static PipboyThemeManagerState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PipboyThemeScope>()?.state;

  /// Built-in preset colors, accessible without a [BuildContext].
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

  // Pre-computed cache keyed by primary color.
  // Avoids expensive ThemeData reconstruction on every color switch,
  // which is especially important on WASM where there is no JIT.
  final _cache = <Color, ({PipboyColorPalette palette, ThemeData theme})>{};

  @override
  void initState() {
    super.initState();
    _primaryColor = widget.initialColor;
    _palette = PipboyColorPalette(_primaryColor);
    _theme = PipboyTheme.buildTheme(palette: _palette);
    _cache[_primaryColor] = (palette: _palette, theme: _theme);

    // Pre-warm the remaining preset themes after the first frame so startup
    // is not blocked.  We yield between each computation so the UI stays
    // responsive throughout.
    WidgetsBinding.instance.addPostFrameCallback((_) => _preWarmPresets());
  }

  /// Builds all preset [ThemeData] objects in the background, yielding to the
  /// event loop between each one so frames are not dropped.
  Future<void> _preWarmPresets() async {
    for (final color in PipboyThemeManager.presets.values) {
      if (!mounted) return;
      if (_cache.containsKey(color)) continue;
      // Yield one event-loop turn before each computation.
      await Future<void>.delayed(Duration.zero);
      if (!mounted) return;
      final palette = PipboyColorPalette(color);
      _cache[color] = (
        palette: palette,
        theme: PipboyTheme.buildTheme(palette: palette),
      );
    }
  }

  /// The currently active primary color.
  Color get primaryColor => _primaryColor;

  /// The currently active palette.
  PipboyColorPalette get palette => _palette;

  /// The currently active [ThemeData].
  ThemeData get currentTheme => _theme;

  /// Switches to a new primary [color].
  ///
  /// If the color is already cached (e.g. a preset that was pre-warmed) the
  /// switch is synchronous and allocation-free.  Otherwise a new palette and
  /// theme are computed and stored for future reuse.
  void setPrimaryColor(Color color) {
    if (color == _primaryColor) return;
    setState(() {
      _primaryColor = color;
      if (_cache.containsKey(color)) {
        final entry = _cache[color]!;
        _palette = entry.palette;
        _theme = entry.theme;
      } else {
        _palette = PipboyColorPalette(color);
        _theme = PipboyTheme.buildTheme(palette: _palette);
        _cache[color] = (palette: _palette, theme: _theme);
      }
    });
  }

  @override
  Widget build(BuildContext context) => _PipboyThemeScope(
    state: this,
    primaryColor: _primaryColor,
    child: widget.child,
  );
}

/// Private [InheritedWidget] that propagates the theme manager to descendants.
///
/// Stores [primaryColor] as a value for [updateShouldNotify] so dependents
/// are rebuilt exactly when the color changes — not on every setState call
/// that leaves the color unchanged.
class _PipboyThemeScope extends InheritedWidget {
  const _PipboyThemeScope({
    required this.state,
    required this.primaryColor,
    required super.child,
  });

  final PipboyThemeManagerState state;
  final Color primaryColor;

  @override
  bool updateShouldNotify(_PipboyThemeScope old) =>
      primaryColor != old.primaryColor;
}
