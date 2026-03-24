import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class TextInputPage extends StatefulWidget {
  const TextInputPage({super.key});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  final _controller = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INPUTS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'TextField',
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'VAULT NUMBER',
                      hintText: 'e.g. 111',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'ACCESS CODE',
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'With prefix/suffix',
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'SEARCH DATABASE',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.clear),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'CAPS',
                      prefixText: '[ ',
                      suffixText: ' ]',
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Multiline',
              child: TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'JOURNAL ENTRY',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            DemoSection(
              title: 'Disabled',
              child: const TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'LOCKED TERMINAL',
                  hintText: 'ACCESS DENIED',
                ),
              ),
            ),
            DemoSection(
              title: 'Form Validation',
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'REQUIRED FIELD',
                        hintText: 'Cannot be empty',
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'FIELD REQUIRED' : null,
                    ),
                    const SizedBox(height: 12),
                    PipboyButton(
                      variant: PipboyButtonVariant.accent,
                      onPressed: () => _formKey.currentState?.validate(),
                      child: const Text('VALIDATE'),
                    ),
                  ],
                ),
              ),
            ),
            DemoSection(
              title: 'SearchBar',
              child: SearchBar(
                hintText: 'Search terminals...',
                leading: const Icon(Icons.search),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.mic_none),
                    onPressed: () {},
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
