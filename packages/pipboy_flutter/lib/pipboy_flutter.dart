/// Pipboy Flutter — A Fallout Pip-Boy inspired UI theme library.
///
/// Usage:
/// ```dart
/// import 'package:pipboy_flutter/pipboy_flutter.dart';
///
/// MaterialApp(
///   theme: PipboyTheme.buildTheme(),
///   home: PipboyThemeManager(
///     child: MyApp(),
///   ),
/// );
/// ```
library pipboy_flutter;

// Theme core
export 'src/theme/pipboy_color_palette.dart';
export 'src/theme/pipboy_theme.dart';
export 'src/theme/pipboy_theme_manager.dart';
export 'src/theme/pipboy_theme_data.dart';

// Custom widgets
export 'src/widgets/pipboy_panel.dart';
export 'src/widgets/pipboy_segmented_bar.dart';
export 'src/widgets/pipboy_rated_attribute.dart';
export 'src/widgets/pipboy_blink_text.dart';
export 'src/widgets/pipboy_scanline_overlay.dart';
export 'src/widgets/pipboy_bracket_highlight.dart';
export 'src/widgets/pipboy_crt_display.dart';
export 'src/widgets/pipboy_tab_strip.dart';
export 'src/widgets/pipboy_terminal_panel.dart';
export 'src/widgets/pipboy_countdown.dart';
export 'src/widgets/pipboy_button.dart';
export 'src/widgets/pipboy_text_styles.dart';
