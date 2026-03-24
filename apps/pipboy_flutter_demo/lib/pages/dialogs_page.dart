import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class DialogsPage extends StatelessWidget {
  const DialogsPage({super.key});

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('SYSTEM ALERT'),
        content: const Text(
          'Radiation levels have exceeded safe threshold.\n'
          'Recommend immediate evacuation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DISMISS'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('EVACUATE'),
          ),
        ],
      ),
    );
  }

  void _showConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('CONFIRM ACTION'),
        content: const Text('Launch nuclear warhead? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          PipboyButton(
            variant: PipboyButtonVariant.danger,
            onPressed: () => Navigator.pop(context),
            child: const Text('LAUNCH'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('QUEST COMPLETED: THE FIRST STEP'),
        action: SnackBarAction(label: 'VIEW', onPressed: () {}),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final palette = PipboyThemeData.paletteOf(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PipboyH2('ITEM OPTIONS'),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: palette.primary,
                  size: 18,
                ),
                title: const Text('EXAMINE'),
                contentPadding: EdgeInsets.zero,
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(
                  Icons.back_hand_outlined,
                  color: palette.primary,
                  size: 18,
                ),
                title: const Text('EQUIP'),
                contentPadding: EdgeInsets.zero,
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: palette.error,
                  size: 18,
                ),
                title: Text('DROP', style: TextStyle(color: palette.error)),
                contentPadding: EdgeInsets.zero,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime(2077, 10, 23),
      firstDate: DateTime(2070),
      lastDate: DateTime(2280),
    );
  }

  void _showTimePicker(BuildContext context) async {
    await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DIALOGS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'AlertDialog',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PipboyButton(
                    onPressed: () => _showAlert(context),
                    child: const Text('SHOW ALERT'),
                  ),
                  PipboyButton(
                    variant: PipboyButtonVariant.danger,
                    onPressed: () => _showConfirm(context),
                    child: const Text('CONFIRM DIALOG'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'SnackBar',
              child: PipboyButton(
                variant: PipboyButtonVariant.accent,
                onPressed: () => _showSnackbar(context),
                child: const Text('SHOW SNACKBAR'),
              ),
            ),
            DemoSection(
              title: 'BottomSheet',
              child: PipboyButton(
                onPressed: () => _showBottomSheet(context),
                child: const Text('ITEM OPTIONS'),
              ),
            ),
            DemoSection(
              title: 'DatePicker & TimePicker',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PipboyButton(
                    onPressed: () => _showDatePicker(context),
                    child: const Text('DATE PICKER'),
                  ),
                  PipboyButton(
                    onPressed: () => _showTimePicker(context),
                    child: const Text('TIME PICKER'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Tooltip',
              child: Wrap(
                spacing: 12,
                children: [
                  Tooltip(
                    message: 'Restore 50 HP immediately.',
                    child: PipboyButton(
                      variant: PipboyButtonVariant.ghost,
                      onPressed: () {},
                      child: const Text('STIMPAK'),
                    ),
                  ),
                  Tooltip(
                    message: 'Reduces radiation by 150 rads.',
                    child: PipboyButton(
                      variant: PipboyButtonVariant.ghost,
                      onPressed: () {},
                      child: const Text('RADAWAY'),
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Badge',
              child: Row(
                children: [
                  Badge(
                    label: const Text('3'),
                    child: Icon(Icons.notifications_outlined, size: 28),
                  ),
                  const SizedBox(width: 24),
                  Badge(child: Icon(Icons.mail_outline, size: 28)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
