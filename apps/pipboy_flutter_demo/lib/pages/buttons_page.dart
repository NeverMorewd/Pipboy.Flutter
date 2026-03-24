import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BUTTONS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'PipboyButton Variants',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PipboyButton(onPressed: () {}, child: const Text('STANDARD')),
                  PipboyButton(
                    variant: PipboyButtonVariant.accent,
                    onPressed: () {},
                    child: const Text('ACCENT'),
                  ),
                  PipboyButton(
                    variant: PipboyButtonVariant.ghost,
                    onPressed: () {},
                    child: const Text('GHOST'),
                  ),
                  PipboyButton(
                    variant: PipboyButtonVariant.danger,
                    onPressed: () {},
                    child: const Text('DANGER'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Disabled State',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PipboyButton(onPressed: null, child: const Text('STANDARD')),
                  PipboyButton(
                    variant: PipboyButtonVariant.accent,
                    onPressed: null,
                    child: const Text('ACCENT'),
                  ),
                  PipboyButton(
                    variant: PipboyButtonVariant.ghost,
                    onPressed: null,
                    child: const Text('GHOST'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Material ElevatedButton',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('ELEVATED'),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: const Text('DISABLED'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Material FilledButton',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(onPressed: () {}, child: const Text('FILLED')),
                  FilledButton(onPressed: null, child: const Text('DISABLED')),
                ],
              ),
            ),
            DemoSection(
              title: 'Material OutlinedButton',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('OUTLINED'),
                  ),
                  OutlinedButton(
                    onPressed: null,
                    child: const Text('DISABLED'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Material TextButton',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(onPressed: () {}, child: const Text('TEXT')),
                  TextButton(onPressed: null, child: const Text('DISABLED')),
                ],
              ),
            ),
            DemoSection(
              title: 'IconButton',
              child: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Settings',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    tooltip: 'Favourite',
                  ),
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.block_outlined),
                    tooltip: 'Disabled',
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'FloatingActionButton',
              child: Wrap(
                spacing: 12,
                children: [
                  FloatingActionButton(
                    heroTag: 'fab1',
                    onPressed: () {},
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton.small(
                    heroTag: 'fab2',
                    onPressed: () {},
                    child: const Icon(Icons.edit),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'fab3',
                    onPressed: () {},
                    icon: const Icon(Icons.navigation),
                    label: const Text('FAST TRAVEL'),
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
