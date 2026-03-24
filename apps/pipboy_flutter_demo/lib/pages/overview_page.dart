import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// Full-screen Pip-Boy mockup overview page.
class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  double _hp = 0.85;
  double _ap = 0.60;
  double _rad = 0.15;
  int _tab = 0;

  static const _tabs = ['STAT', 'INV', 'DATA', 'MAP', 'RADIO'];

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar
          _TopBar(palette: palette),
          // Tab strip
          PipboyTabStrip(
            tabs: _tabs,
            selectedIndex: _tab,
            onTabSelected: (i) => setState(() => _tab = i),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status bars
                  PipboyPanel(
                    title: 'CONDITION',
                    child: Column(
                      children: [
                        _StatBar(label: 'HP', value: _hp, palette: palette),
                        const SizedBox(height: 8),
                        _StatBar(label: 'AP', value: _ap, palette: palette),
                        const SizedBox(height: 8),
                        _StatBar(
                          label: 'RAD',
                          value: _rad,
                          palette: palette,
                          color: palette.warning,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            PipboyButton(
                              variant: PipboyButtonVariant.ghost,
                              onPressed: () => setState(() {
                                _hp = (_hp - 0.1).clamp(0.0, 1.0);
                              }),
                              child: const Text('- HP'),
                            ),
                            const SizedBox(width: 8),
                            PipboyButton(
                              variant: PipboyButtonVariant.accent,
                              onPressed: () => setState(() {
                                _hp = (_hp + 0.1).clamp(0.0, 1.0);
                              }),
                              child: const Text('+ HP'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // S.P.E.C.I.A.L
                  PipboyPanel(
                    title: 'S.P.E.C.I.A.L.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PipboyRatedAttribute(label: 'STR', value: 7),
                        const SizedBox(height: 6),
                        PipboyRatedAttribute(label: 'PER', value: 5),
                        const SizedBox(height: 6),
                        PipboyRatedAttribute(label: 'END', value: 6),
                        const SizedBox(height: 6),
                        PipboyRatedAttribute(label: 'CHA', value: 3),
                        const SizedBox(height: 6),
                        PipboyRatedAttribute(label: 'INT', value: 9),
                        const SizedBox(height: 6),
                        PipboyRatedAttribute(label: 'AGI', value: 8),
                        const SizedBox(height: 6),
                        PipboyRatedAttribute(label: 'LCK', value: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Terminal
                  PipboyTerminalPanel(
                    lines: const [
                      'ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM',
                      'COPYRIGHT 2075-2077 ROBCO INDUSTRIES',
                      '',
                      'VAULT-TEC ASSISTED TARGETING SYSTEM',
                      'V.A.T.S. READY',
                      '',
                      'SYSTEM STATUS: NOMINAL',
                      'POWER: FUSION CELL 98%',
                    ],
                    typewriter: true,
                    minHeight: 140,
                  ),
                ],
              ),
            ),
          ),
          // Bottom countdown
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: palette.surface,
              border: Border(top: BorderSide(color: palette.border)),
            ),
            child: Center(
              child: PipboyCountdown(
                duration: const Duration(hours: 1, minutes: 23, seconds: 45),
                label: 'NEXT QUEST MARKER',
                autoStart: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.palette});
  final PipboyColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Row(
        children: [
          Text(
            'PIP-BOY 3000 MARK IV',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: palette.primary,
              letterSpacing: 2.0,
            ),
          ),
          const Spacer(),
          PipboyBlinkText(
            '● REC',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 11,
              color: palette.warning,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'LVL 42',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 11,
              color: palette.textDim,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.value,
    required this.palette,
    this.color,
  });

  final String label;
  final double value;
  final PipboyColorPalette palette;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: palette.textDim,
            ),
          ),
        ),
        Expanded(
          child: PipboySegmentedBar(
            value: value,
            color: color,
            showLabel: false,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '${(value * 100).round()}%',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 10,
              color: palette.textDim,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
