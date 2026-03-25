import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// Builds and provides the complete Pip-Boy [ThemeData] for use with
/// [MaterialApp.theme].
///
/// Covers every Material 3 widget component theme with sharp (zero border
/// radius) styling and a monochromatic HSL palette.
class PipboyTheme {
  PipboyTheme._();

  /// Builds a complete [ThemeData] using the given [palette].
  ///
  /// If [palette] is omitted the default Pip-Boy green palette is used.
  static ThemeData buildTheme({PipboyColorPalette? palette}) {
    final p = palette ?? PipboyColorPalette(PipboyColorPalette.defaultPrimary);
    return _build(p);
  }

  static ThemeData _build(PipboyColorPalette p) {
    const fontFamily = 'Courier New';
    const radius = BorderRadius.zero;
    const shape = RoundedRectangleBorder();

    final textTheme = _buildTextTheme(p, fontFamily);
    final colorScheme = _buildColorScheme(p);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.surface,
      cardColor: p.surface,
      dividerColor: p.border,
      hintColor: p.textDim,
      splashColor: p.hover.withValues(alpha: 0.5),
      highlightColor: p.pressed.withValues(alpha: 0.5),
      focusColor: p.focus.withValues(alpha: 0.2),
      hoverColor: p.hover.withValues(alpha: 0.3),
      disabledColor: p.disabled,
      extensions: [PipboyThemeData(palette: p)],

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: p.surface,
        foregroundColor: p.primary,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: p.primary,
          letterSpacing: 2.0,
        ),
        iconTheme: IconThemeData(color: p.primary),
        actionsIconTheme: IconThemeData(color: p.primary),
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: p.border)),
      ),

      // ── Card ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide(color: p.border)),
        margin: EdgeInsets.zero,
      ),

      // ── Buttons ────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buildElevatedButtonStyle(p, shape),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buildTextButtonStyle(p, shape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buildOutlinedButtonStyle(p, shape),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buildFilledButtonStyle(p, shape),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return p.disabled;
            if (states.contains(WidgetState.pressed)) return p.primaryDark;
            if (states.contains(WidgetState.hovered)) return p.primaryLight;
            return p.primary;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return p.pressed;
            if (states.contains(WidgetState.hovered)) return p.hover;
            return Colors.transparent;
          }),
          shape: const WidgetStatePropertyAll(shape),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),

      // ── Input / TextField ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        hintStyle: TextStyle(
          color: p.textDim,
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
        ),
        labelStyle: TextStyle(
          color: p.textDim,
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
        ),
        floatingLabelStyle: TextStyle(
          color: p.primary,
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
        ),
        prefixStyle: TextStyle(color: p.text, fontFamily: fontFamily),
        suffixStyle: TextStyle(color: p.text, fontFamily: fontFamily),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.disabled.withValues(alpha: 0.3)),
        ),
        errorStyle: TextStyle(
          color: p.error,
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
        ),
      ),

      // ── Checkbox ───────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return p.disabled;
          if (states.contains(WidgetState.selected)) return p.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(p.background),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return p.pressed;
          if (states.contains(WidgetState.hovered)) return p.hover;
          return Colors.transparent;
        }),
        side: BorderSide(color: p.border, width: 1.5),
        shape: const RoundedRectangleBorder(),
      ),

      // ── Radio ──────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return p.disabled;
          if (states.contains(WidgetState.selected)) return p.primary;
          return p.border;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return p.pressed;
          if (states.contains(WidgetState.hovered)) return p.hover;
          return Colors.transparent;
        }),
      ),

      // ── Switch ─────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return p.disabled;
          if (states.contains(WidgetState.selected)) return p.background;
          return p.textDim;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return p.disabled.withValues(alpha: 0.3);
          }
          if (states.contains(WidgetState.selected)) return p.primary;
          return p.surface;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return p.border;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return p.pressed;
          if (states.contains(WidgetState.hovered)) return p.hover;
          return Colors.transparent;
        }),
      ),

      // ── Slider ─────────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: p.primary,
        inactiveTrackColor: p.border,
        thumbColor: p.primary,
        overlayColor: p.hover.withValues(alpha: 0.3),
        disabledActiveTrackColor: p.disabled,
        disabledInactiveTrackColor: p.disabled.withValues(alpha: 0.3),
        disabledThumbColor: p.disabled,
        valueIndicatorColor: p.surfaceHigh,
        valueIndicatorTextStyle: TextStyle(
          color: p.primary,
          fontFamily: fontFamily,
        ),
        trackShape: const RectangularSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
      ),

      // ── ProgressIndicator ──────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
        linearTrackColor: p.border,
        circularTrackColor: p.border,
        linearMinHeight: 6,
      ),

      // ── ListTile ───────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        textColor: p.text,
        iconColor: p.primary,
        tileColor: Colors.transparent,
        selectedColor: p.primary,
        selectedTileColor: p.selection,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: shape,
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 8),

      // ── TabBar ─────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: p.primary,
        unselectedLabelColor: p.textDim,
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          letterSpacing: 1.0,
        ),
        indicatorColor: p.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: p.border,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return p.pressed;
          if (states.contains(WidgetState.hovered)) return p.hover;
          return Colors.transparent;
        }),
        splashFactory: NoSplash.splashFactory,
      ),

      // ── Tooltip ────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.surfaceHigh,
          border: Border.all(color: p.border),
          borderRadius: radius,
        ),
        textStyle: TextStyle(
          color: p.text,
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      // ── SnackBar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.surfaceHigh,
        contentTextStyle: TextStyle(
          color: p.text,
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
        ),
        actionTextColor: p.primary,
        shape: shape,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Dialog ─────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide(color: p.border)),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeH2,
          fontWeight: FontWeight.bold,
          color: p.primary,
          letterSpacing: 1.5,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          color: p.text,
        ),
      ),

      // ── Drawer ─────────────────────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),

      // ── NavigationBar ──────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: p.selection,
        indicatorShape: shape,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: fontFamily,
            fontSize: PipboyColorPalette.fontSizeSmall,
            color: selected ? p.primary : p.textDim,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? p.primary : p.textDim);
        }),
      ),

      // ── NavigationRail ─────────────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: p.surface,
        selectedIconTheme: IconThemeData(color: p.primary),
        unselectedIconTheme: IconThemeData(color: p.textDim),
        selectedLabelTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
          color: p.primary,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
          color: p.textDim,
        ),
        indicatorColor: p.selection,
        indicatorShape: shape,
        elevation: 0,
      ),

      // ── FloatingActionButton ───────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.primary,
        foregroundColor: p.background,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        shape: shape,
        splashColor: p.primaryDark,
      ),

      // ── Chip ───────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        selectedColor: p.selection,
        disabledColor: p.surface.withValues(alpha: 0.5),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
          color: p.text,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeSmall,
          color: p.primary,
        ),
        side: BorderSide(color: p.border),
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 0,
        pressElevation: 0,
        deleteIconColor: p.textDim,
        iconTheme: IconThemeData(color: p.primary, size: 16),
      ),

      // ── PopupMenu ──────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide(color: p.border)),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          color: p.text,
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: fontFamily,
            fontSize: PipboyColorPalette.fontSize,
            color: p.text,
          ),
        ),
      ),

      // ── BottomSheet ────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide(color: p.border)),
      ),

      // ── DropdownMenu ───────────────────────────────────────────────────────
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSize,
          color: p.text,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(p.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(side: BorderSide(color: p.border)),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        ),
      ),

      // ── ExpansionTile ──────────────────────────────────────────────────────
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: p.primary,
        collapsedIconColor: p.textDim,
        textColor: p.primary,
        collapsedTextColor: p.text,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
        shape: Border(bottom: BorderSide(color: p.border)),
        collapsedShape: Border(bottom: BorderSide(color: p.border)),
      ),

      // ── Badge ──────────────────────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: p.primary,
        textColor: p.background,
        smallSize: 6,
        largeSize: 16,
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: PipboyColorPalette.fontSizeXSmall,
          fontWeight: FontWeight.bold,
        ),
      ),

      // ── DatePicker ─────────────────────────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide(color: p.border)),
        headerBackgroundColor: p.surfaceHigh,
        headerForegroundColor: p.primary,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.background;
          if (states.contains(WidgetState.disabled)) return p.disabled;
          return p.text;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.primary;
          return Colors.transparent;
        }),
        todayForegroundColor: WidgetStatePropertyAll(p.primary),
        todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        todayBorder: BorderSide(color: p.primary),
        dayShape: const WidgetStatePropertyAll(shape),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.background;
          return p.text;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.primary;
          return Colors.transparent;
        }),
        rangePickerBackgroundColor: p.surface,
      ),

      // ── TimePicker ─────────────────────────────────────────────────────────
      timePickerTheme: TimePickerThemeData(
        backgroundColor: p.surface,
        dialBackgroundColor: p.surfaceHigh,
        dialHandColor: p.primary,
        dialTextColor: p.text,
        hourMinuteTextColor: p.text,
        hourMinuteColor: p.surfaceHigh,
        dayPeriodTextColor: p.text,
        dayPeriodColor: p.surfaceHigh,
        dayPeriodShape: shape,
        shape: RoundedRectangleBorder(side: BorderSide(color: p.border)),
        entryModeIconColor: p.primary,
      ),

      // ── SearchBar ──────────────────────────────────────────────────────────
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(p.surface),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return p.pressed;
          if (states.contains(WidgetState.hovered)) return p.hover;
          return Colors.transparent;
        }),
        side: WidgetStatePropertyAll(BorderSide(color: p.border)),
        shape: const WidgetStatePropertyAll(shape),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: fontFamily,
            fontSize: PipboyColorPalette.fontSize,
            color: p.text,
          ),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: fontFamily,
            fontSize: PipboyColorPalette.fontSize,
            color: p.textDim,
          ),
        ),
      ),
    );
  }

  // ── Button styles ────────────────────────────────────────────────────────

  static ButtonStyle _buildElevatedButtonStyle(
    PipboyColorPalette p,
    OutlinedBorder shape,
  ) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return p.surface;
        if (states.contains(WidgetState.pressed)) return p.pressed;
        if (states.contains(WidgetState.hovered)) return p.hover;
        return p.surface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return p.disabled;
        if (states.contains(WidgetState.pressed)) return p.primaryDark;
        if (states.contains(WidgetState.hovered)) return p.primaryLight;
        return p.text;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: p.disabled.withValues(alpha: 0.3));
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return BorderSide(color: p.primary);
        }
        return BorderSide(color: p.border);
      }),
      shape: WidgetStatePropertyAll(shape),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      minimumSize: const WidgetStatePropertyAll(
        Size(64, PipboyColorPalette.controlHeight),
      ),
    );
  }

  static ButtonStyle _buildTextButtonStyle(
    PipboyColorPalette p,
    OutlinedBorder shape,
  ) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return p.pressed;
        if (states.contains(WidgetState.hovered)) return p.hover;
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return p.disabled;
        return p.primary;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(shape),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static ButtonStyle _buildOutlinedButtonStyle(
    PipboyColorPalette p,
    OutlinedBorder shape,
  ) {
    return ButtonStyle(
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
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: p.disabled.withValues(alpha: 0.3));
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return BorderSide(color: p.borderFocus);
        }
        return BorderSide(color: p.primary);
      }),
      shape: WidgetStatePropertyAll(shape),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      minimumSize: const WidgetStatePropertyAll(
        Size(64, PipboyColorPalette.controlHeight),
      ),
    );
  }

  static ButtonStyle _buildFilledButtonStyle(
    PipboyColorPalette p,
    OutlinedBorder shape,
  ) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return p.disabled;
        if (states.contains(WidgetState.pressed)) return p.primaryDark;
        if (states.contains(WidgetState.hovered)) return p.primaryLight;
        return p.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return p.background;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(shape),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      minimumSize: const WidgetStatePropertyAll(
        Size(64, PipboyColorPalette.controlHeight),
      ),
    );
  }

  // ── Text theme ───────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(PipboyColorPalette p, String fontFamily) {
    TextStyle base({
      required double size,
      FontWeight weight = FontWeight.normal,
      Color? color,
      double letterSpacing = 0.5,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color ?? p.text,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      displayLarge: base(
        size: 32,
        weight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 3.0,
      ),
      displayMedium: base(
        size: 28,
        weight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 2.5,
      ),
      displaySmall: base(
        size: 24,
        weight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 2.0,
      ),
      headlineLarge: base(
        size: PipboyColorPalette.fontSizeH1,
        weight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 2.0,
      ),
      headlineMedium: base(
        size: PipboyColorPalette.fontSizeH2,
        weight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 1.5,
      ),
      headlineSmall: base(
        size: PipboyColorPalette.fontSizeLarge,
        weight: FontWeight.bold,
        color: p.primary,
        letterSpacing: 1.5,
      ),
      titleLarge: base(
        size: PipboyColorPalette.fontSizeLarge,
        weight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
      titleMedium: base(
        size: PipboyColorPalette.fontSize,
        weight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
      titleSmall: base(
        size: PipboyColorPalette.fontSizeSmall,
        weight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
      bodyLarge: base(size: PipboyColorPalette.fontSize),
      bodyMedium: base(size: PipboyColorPalette.fontSizeSmall),
      bodySmall: base(size: PipboyColorPalette.fontSizeXSmall),
      labelLarge: base(
        size: PipboyColorPalette.fontSizeSmall,
        letterSpacing: 1.5,
      ),
      labelMedium: base(
        size: PipboyColorPalette.fontSizeXSmall,
        letterSpacing: 1.0,
      ),
      labelSmall: base(
        size: PipboyColorPalette.fontSizeXSmall,
        letterSpacing: 0.8,
      ),
    );
  }

  static ColorScheme _buildColorScheme(PipboyColorPalette p) {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: p.primary,
      onPrimary: p.background,
      primaryContainer: p.selection,
      onPrimaryContainer: p.primary,
      secondary: p.primaryDark,
      onSecondary: p.background,
      secondaryContainer: p.surfaceHigh,
      onSecondaryContainer: p.text,
      tertiary: p.primaryLight,
      onTertiary: p.background,
      tertiaryContainer: p.surface,
      onTertiaryContainer: p.text,
      error: p.error,
      onError: p.background,
      errorContainer: p.pressed,
      onErrorContainer: p.error,
      surface: p.surface,
      onSurface: p.text,
      surfaceContainerHighest: p.surfaceHigh,
      onSurfaceVariant: p.textDim,
      outline: p.border,
      outlineVariant: p.border.withValues(alpha: 0.5),
      shadow: Colors.black,
      scrim: Colors.black.withValues(alpha: 0.6),
      inverseSurface: p.text,
      onInverseSurface: p.background,
      inversePrimary: p.primaryDark,
    );
  }
}
