import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import 'widgets/fps_counter.dart';
import 'pages/overview_page.dart';
import 'pages/buttons_page.dart';
import 'pages/text_input_page.dart';
import 'pages/toggles_page.dart';
import 'pages/slider_progress_page.dart';
import 'pages/lists_page.dart';
import 'pages/typography_page.dart';
import 'pages/pipboy_controls_page.dart';
import 'pages/crt_display_page.dart';
import 'pages/theme_page.dart';
import 'pages/dialogs_page.dart';
import 'pages/navigation_page.dart';

class PipboyDemoApp extends StatefulWidget {
  const PipboyDemoApp({super.key});

  @override
  State<PipboyDemoApp> createState() => _PipboyDemoAppState();
}

class _PipboyDemoAppState extends State<PipboyDemoApp> {
  // We rebuild MaterialApp whenever the theme manager notifies us.
  // PipboyThemeManager.of() triggers a rebuild when setPrimaryColor is called
  // because it calls setState on PipboyThemeManagerState.
  @override
  Widget build(BuildContext context) {
    final manager = PipboyThemeManager.of(context);
    return MaterialApp(
      title: 'Pipboy Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: manager.currentTheme,
      home: const _DemoShell(),
    );
  }
}

class _DemoShell extends StatefulWidget {
  const _DemoShell();

  @override
  State<_DemoShell> createState() => _DemoShellState();
}

class _DemoShellState extends State<_DemoShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    (icon: Icons.home_outlined, label: 'OVERVIEW'),
    (icon: Icons.smart_button_outlined, label: 'BUTTONS'),
    (icon: Icons.text_fields_outlined, label: 'INPUTS'),
    (icon: Icons.toggle_on_outlined, label: 'TOGGLES'),
    (icon: Icons.linear_scale_outlined, label: 'SLIDERS'),
    (icon: Icons.list_outlined, label: 'LISTS'),
    (icon: Icons.font_download_outlined, label: 'TYPOGRAPHY'),
    (icon: Icons.widgets_outlined, label: 'PIP-BOY'),
    (icon: Icons.monitor_outlined, label: 'CRT'),
    (icon: Icons.palette_outlined, label: 'THEME'),
    (icon: Icons.chat_bubble_outline, label: 'DIALOGS'),
    (icon: Icons.navigation_outlined, label: 'NAV'),
  ];

  static const _pages = [
    OverviewPage(),
    ButtonsPage(),
    TextInputPage(),
    TogglesPage(),
    SliderProgressPage(),
    ListsPage(),
    TypographyPage(),
    PipboyControlsPage(),
    CrtDisplayPage(),
    ThemePage(),
    DialogsPage(),
    NavigationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);
    final isWide = MediaQuery.of(context).size.width >= 800;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            _SideNav(
              selectedIndex: _selectedIndex,
              onSelect: (i) => setState(() => _selectedIndex = i),
              items: _navItems,
              palette: palette,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Stack(
                children: [
                  _pages[_selectedIndex],
                  const Positioned(top: 8, right: 8, child: FpsCounter()),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          const Positioned(top: 8, right: 8, child: FpsCounter()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(palette),
    );
  }

  Widget _buildBottomNav(PipboyColorPalette palette) {
    const visibleCount = 5;
    final clampedIndex = _selectedIndex < visibleCount ? _selectedIndex : 0;
    return BottomNavigationBar(
      currentIndex: clampedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      type: BottomNavigationBarType.fixed,
      backgroundColor: palette.surface,
      selectedItemColor: palette.primary,
      unselectedItemColor: palette.textDim,
      selectedLabelStyle: TextStyle(
        fontFamily: PipboyColorPalette.fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: PipboyColorPalette.fontFamily,
        fontSize: 10,
      ),
      items: _navItems
          .take(visibleCount)
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.selectedIndex,
    required this.onSelect,
    required this.items,
    required this.palette,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<({IconData icon, String label})> items;
  final PipboyColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Container(
        color: palette.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: palette.border)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'PIP-BOY UI',
                style: TextStyle(
                  fontFamily: PipboyColorPalette.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: palette.primary,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  final selected = i == selectedIndex;
                  return InkWell(
                    onTap: () => onSelect(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? palette.selection
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: selected
                                ? palette.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: palette.border.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 16,
                            color: selected ? palette.primary : palette.textDim,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: PipboyColorPalette.fontFamily,
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected
                                  ? palette.primary
                                  : palette.textDim,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
