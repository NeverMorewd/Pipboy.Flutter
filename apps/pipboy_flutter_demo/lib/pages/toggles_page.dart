import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class TogglesPage extends StatefulWidget {
  const TogglesPage({super.key});

  @override
  State<TogglesPage> createState() => _TogglesPageState();
}

class _TogglesPageState extends State<TogglesPage> {
  bool _check1 = true;
  bool _check2 = false;
  final bool _check3 = false;
  int _radio = 0;
  bool _switch1 = true;
  bool _switch2 = false;
  String? _dropdown = 'Vault 111';
  final _dropdownItems = [
    'Vault 111',
    'Vault 81',
    'Vault 95',
    'Vault 101',
    'Vault 87',
  ];
  final List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('TOGGLES')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'Checkbox',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    value: _check1,
                    onChanged: (v) => setState(() => _check1 = v!),
                    title: const Text('POWER ARMOR EQUIPPED'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    value: _check2,
                    onChanged: (v) => setState(() => _check2 = v!),
                    title: const Text('STEALTH BOY ACTIVE'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    value: _check3,
                    onChanged: null,
                    title: Text(
                      'LOCKED (DISABLED)',
                      style: TextStyle(color: palette.textDim),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Radio Button',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _dropdownItems.length,
                  (i) => PipboyRadioTile<int>(
                    value: i,
                    groupValue: _radio,
                    onChanged: (v) => setState(() => _radio = v ?? _radio),
                    title: Text(_dropdownItems[i]),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            DemoSection(
              title: 'Switch',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PipboySwitchTile(
                    value: _switch1,
                    onChanged: (v) => setState(() => _switch1 = v),
                    title: const Text('TURRETS ENABLED'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  PipboySwitchTile(
                    value: _switch2,
                    onChanged: (v) => setState(() => _switch2 = v),
                    title: const Text('ALARM SYSTEM'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  PipboySwitchTile(
                    value: true,
                    onChanged: null,
                    title: Text(
                      'DISABLED SWITCH',
                      style: TextStyle(color: palette.textDim),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'DropdownButton',
              child: DropdownButton<String>(
                value: _dropdown,
                isExpanded: true,
                dropdownColor: palette.surface,
                style: TextStyle(
                  fontFamily: PipboyColorPalette.fontFamily,
                  fontSize: 13,
                  color: palette.text,
                ),
                underline: Container(height: 1, color: palette.border),
                icon: Icon(Icons.arrow_drop_down, color: palette.primary),
                items: _dropdownItems
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => _dropdown = v),
              ),
            ),
            DemoSection(
              title: 'DropdownMenu (Material 3)',
              child: DropdownMenu<String>(
                initialSelection: _dropdown,
                label: const Text('SELECT VAULT'),
                expandedInsets: EdgeInsets.zero,
                dropdownMenuEntries: _dropdownItems
                    .map((v) => DropdownMenuEntry(value: v, label: v))
                    .toList(),
                onSelected: (v) => setState(() => _dropdown = v),
              ),
            ),
            DemoSection(
              title: 'FilterChip',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: ['WEAPONS', 'ARMOR', 'AID', 'MISC', 'AMMO', 'JUNK']
                    .map((label) {
                      final selected = _selected.contains(label);
                      return FilterChip(
                        label: Text(label),
                        selected: selected,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _selected.add(label);
                          } else {
                            _selected.remove(label);
                          }
                        }),
                      );
                    })
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
