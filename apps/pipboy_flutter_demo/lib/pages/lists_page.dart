import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  int? _selectedItem;

  static const _items = [
    (name: '10mm Pistol', qty: 1, weight: 2.5),
    (name: 'Stimpak', qty: 12, weight: 0.1),
    (name: 'Nuka-Cola', qty: 3, weight: 1.0),
    (name: 'Bobby Pin', qty: 47, weight: 0.0),
    (name: 'Fusion Core', qty: 2, weight: 1.0),
    (name: 'Rad-X', qty: 5, weight: 0.0),
    (name: 'RadAway', qty: 4, weight: 0.5),
    (name: 'Psycho', qty: 1, weight: 0.0),
  ];

  bool _node1Expanded = true;
  bool _node2Expanded = false;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('LISTS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'ListTile',
              child: Column(
                children: _items.take(3).map((item) {
                  return ListTile(
                    leading: Icon(
                      Icons.inventory_2_outlined,
                      color: palette.primary,
                      size: 18,
                    ),
                    title: Text(item.name),
                    trailing: Text(
                      'x${item.qty}',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 11,
                        color: palette.textDim,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            DemoSection(
              title: 'Selectable ListView',
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: palette.border),
                ),
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    final selected = _selectedItem == i;
                    return InkWell(
                      onTap: () => setState(() => _selectedItem = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        color:
                            selected ? palette.selection : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            PipboyBracketHighlight(
                              selected: selected,
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontFamily: 'Courier New',
                                  fontSize: 12,
                                  color: selected
                                      ? palette.primary
                                      : palette.text,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'x${item.qty}',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 11,
                                color: palette.textDim,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${item.weight}kg',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 11,
                                color: palette.textDim,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            DemoSection(
              title: 'TreeView (ExpansionTile)',
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  children: [
                    ExpansionTile(
                      initiallyExpanded: _node1Expanded,
                      onExpansionChanged: (v) =>
                          setState(() => _node1Expanded = v),
                      leading: Icon(
                        Icons.folder_outlined,
                        color: palette.primary,
                        size: 16,
                      ),
                      title: const Text('WEAPONS'),
                      children: const [
                        ListTile(
                          leading: SizedBox(width: 16),
                          title: Text('10mm Pistol'),
                          trailing: Text('DMG: 18'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        ),
                        ListTile(
                          leading: SizedBox(width: 16),
                          title: Text('Combat Shotgun'),
                          trailing: Text('DMG: 55'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      initiallyExpanded: _node2Expanded,
                      onExpansionChanged: (v) =>
                          setState(() => _node2Expanded = v),
                      leading: Icon(
                        Icons.folder_outlined,
                        color: palette.primary,
                        size: 16,
                      ),
                      title: const Text('ARMOR'),
                      children: const [
                        ListTile(
                          title: Text('Combat Armor'),
                          trailing: Text('DR: 20'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        ),
                        ListTile(
                          title: Text('Power Armor T-60'),
                          trailing: Text('DR: 60'),
                          contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DemoSection(
              title: 'Chips',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  const Chip(label: Text('RARE')),
                  const Chip(label: Text('LEGENDARY')),
                  Chip(
                    label: const Text('QUEST ITEM'),
                    avatar: Icon(Icons.star, size: 14, color: palette.primary),
                  ),
                  InputChip(
                    label: const Text('VAULT 111'),
                    onPressed: () {},
                    onDeleted: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
