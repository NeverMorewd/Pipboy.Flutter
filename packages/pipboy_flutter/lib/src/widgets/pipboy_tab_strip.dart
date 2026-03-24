import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/widgets/pipboy_bracket_highlight.dart';

/// A Pip-Boy styled horizontal tab strip with bracket selection animation.
///
/// Used as a top-level page navigator — mirrors the Avalonia `PipboyTabStrip`.
///
/// ```dart
/// PipboyTabStrip(
///   tabs: ['STAT', 'INV', 'DATA', 'MAP', 'RADIO'],
///   selectedIndex: _selectedIndex,
///   onTabSelected: (i) => setState(() => _selectedIndex = i),
/// )
/// ```
class PipboyTabStrip extends StatelessWidget {
  const PipboyTabStrip({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.height = 40.0,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final selected = index == selectedIndex;

          return _PipboyTab(
            label: label,
            selected: selected,
            onTap: () => onTabSelected(index),
            palette: palette,
          );
        }).toList(),
      ),
    );
  }
}

class _PipboyTab extends StatelessWidget {
  const _PipboyTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.palette,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final PipboyColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: palette.hover,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? palette.selection : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: selected ? palette.primary : Colors.transparent,
              width: 2,
            ),
            right: BorderSide(color: palette.border.withValues(alpha: 0.30)),
          ),
        ),
        child: Center(
          child: PipboyBracketHighlight(
            selected: selected,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: PipboyColorPalette.fontSizeSmall,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? palette.primary : palette.textDim,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A complete tabbed layout widget combining [PipboyTabStrip] with content pages.
///
/// ```dart
/// PipboyTabbedView(
///   tabs: ['STAT', 'INV', 'DATA'],
///   pages: [StatPage(), InvPage(), DataPage()],
/// )
/// ```
class PipboyTabbedView extends StatefulWidget {
  const PipboyTabbedView({
    super.key,
    required this.tabs,
    required this.pages,
    this.initialIndex = 0,
  }) : assert(tabs.length == pages.length);

  final List<String> tabs;
  final List<Widget> pages;
  final int initialIndex;

  @override
  State<PipboyTabbedView> createState() => _PipboyTabbedViewState();
}

class _PipboyTabbedViewState extends State<PipboyTabbedView> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PipboyTabStrip(
          tabs: widget.tabs,
          selectedIndex: _selectedIndex,
          onTabSelected: (i) => setState(() => _selectedIndex = i),
        ),
        Expanded(child: widget.pages[_selectedIndex]),
      ],
    );
  }
}
