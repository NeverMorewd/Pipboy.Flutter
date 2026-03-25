import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  int _navBarIndex = 0;
  int _navRailIndex = 0;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('NAVIGATION')),
      drawer: _buildDrawer(palette),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'TabBar + TabBarView',
              child: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'STAT'),
                        Tab(text: 'INV'),
                        Tab(text: 'DATA'),
                        Tab(text: 'MAP'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _TabContent('Statistics panel', palette),
                          _TabContent('Inventory panel', palette),
                          _TabContent('Data panel', palette),
                          _TabContent('Map panel', palette),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DemoSection(
              title: 'PipboyTabStrip',
              child: PipboyTabbedView(
                tabs: const ['WEAPONS', 'ARMOR', 'AID', 'MISC'],
                pages: [
                  _TabContent('Weapons inventory', palette),
                  _TabContent('Armor & clothing', palette),
                  _TabContent('Aid items', palette),
                  _TabContent('Misc & junk', palette),
                ],
              ),
            ),
            DemoSection(
              title: 'NavigationBar',
              child: NavigationBar(
                selectedIndex: _navBarIndex,
                onDestinationSelected: (i) => setState(() => _navBarIndex = i),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'HOME',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon: Icon(Icons.inventory_2),
                    label: 'INV',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.map_outlined),
                    selectedIcon: Icon(Icons.map),
                    label: 'MAP',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: 'SYSTEM',
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'NavigationRail',
              child: SizedBox(
                height: 200,
                child: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _navRailIndex,
                      onDestinationSelected: (i) =>
                          setState(() => _navRailIndex = i),
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('HOME'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.search),
                          label: Text('SEARCH'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          label: Text('PROFILE'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Section ${_navRailIndex + 1}',
                          style: TextStyle(
                            fontFamily: PipboyColorPalette.fontFamily,
                            color: palette.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DemoSection(
              title: 'Drawer',
              child: Builder(
                builder: (ctx) => PipboyButton(
                  onPressed: () => _openDrawer(ctx),
                  child: const Text('OPEN DRAWER'),
                ),
              ),
            ),
            DemoSection(
              title: 'PopupMenuButton',
              child: PopupMenuButton<String>(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'examine', child: Text('EXAMINE')),
                  PopupMenuItem(value: 'equip', child: Text('EQUIP')),
                  PopupMenuDivider(),
                  PopupMenuItem(value: 'drop', child: Text('DROP')),
                ],
                child: PipboyButton(
                  onPressed: null, // handled by PopupMenuButton
                  child: const Text('ITEM MENU ▾'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(PipboyColorPalette palette) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: palette.surface,
              border: Border(bottom: BorderSide(color: palette.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PipboyH1('PIP-BOY'),
                const SizedBox(height: 4),
                PipboyDimText('3000 Mark IV — Vault-Tec'),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: palette.primary,
              size: 18,
            ),
            title: const Text('OVERVIEW'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(
              Icons.inventory_2_outlined,
              color: palette.primary,
              size: 18,
            ),
            title: const Text('INVENTORY'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.map_outlined, color: palette.primary, size: 18),
            title: const Text('MAP'),
            onTap: () => Navigator.pop(context),
          ),
          Divider(color: palette.border),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: palette.textDim,
              size: 18,
            ),
            title: Text('SETTINGS', style: TextStyle(color: palette.textDim)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent(this.label, this.palette);
  final String label;
  final PipboyColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: palette.background,
      alignment: Alignment.center,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: PipboyColorPalette.fontFamily,
          fontSize: 12,
          color: palette.textDim,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
