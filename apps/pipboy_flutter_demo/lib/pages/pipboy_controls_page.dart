import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class PipboyControlsPage extends StatefulWidget {
  const PipboyControlsPage({super.key});

  @override
  State<PipboyControlsPage> createState() => _PipboyControlsPageState();
}

class _PipboyControlsPageState extends State<PipboyControlsPage> {
  int _tabIndex = 0;
  bool _bracketSelected = false;
  bool _panelClosed = false;
  bool _blinkEnabled = true;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PIP-BOY CONTROLS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'PipboyPanel',
              child: Column(
                children: [
                  if (!_panelClosed)
                    PipboyPanel(
                      title: 'VAULT STATUS',
                      onClose: () => setState(() => _panelClosed = true),
                      footer: Row(
                        children: [PipboyDimText('Last updated: 2077-10-23')],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PipboyRatedAttribute(label: 'STR', value: 7),
                          const SizedBox(height: 6),
                          PipboyRatedAttribute(label: 'INT', value: 9),
                          const SizedBox(height: 6),
                          PipboyRatedAttribute(label: 'LCK', value: 4),
                        ],
                      ),
                    )
                  else
                    PipboyButton(
                      variant: PipboyButtonVariant.ghost,
                      onPressed: () => setState(() => _panelClosed = false),
                      child: const Text('REOPEN PANEL'),
                    ),
                  const SizedBox(height: 12),
                  PipboyPanel(
                    title: 'ALERT',
                    variant: PipboyPanelVariant.warning,
                    child: PipboyWarningText(
                      'RADIATION LEVELS EXCEEDING SAFE THRESHOLD',
                    ),
                  ),
                  const SizedBox(height: 12),
                  PipboyPanel(
                    title: 'MISSION COMPLETE',
                    variant: PipboyPanelVariant.accent,
                    child: PipboySuccessText('Vault 111 security disabled.'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyTabStrip',
              child: Column(
                children: [
                  PipboyTabStrip(
                    tabs: const ['STAT', 'INV', 'DATA', 'MAP', 'RADIO'],
                    selectedIndex: _tabIndex,
                    onTabSelected: (i) => setState(() => _tabIndex = i),
                  ),
                  Container(
                    height: 60,
                    color: palette.surface.withAlpha(128),
                    alignment: Alignment.center,
                    child: PipboyAccentText('Tab ${_tabIndex + 1} selected'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyBracketHighlight',
              child: Row(
                children: [
                  PipboyBracketHighlight(
                    selected: _bracketSelected,
                    child: const Text('SELECT ME'),
                  ),
                  const SizedBox(width: 16),
                  PipboyButton(
                    variant: PipboyButtonVariant.ghost,
                    onPressed: () =>
                        setState(() => _bracketSelected = !_bracketSelected),
                    child: Text(_bracketSelected ? 'DESELECT' : 'SELECT'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyBlinkText',
              child: Row(
                children: [
                  PipboyBlinkText(
                    '>> AWAITING INPUT <<',
                    enabled: _blinkEnabled,
                  ),
                  const SizedBox(width: 16),
                  PipboyButton(
                    variant: PipboyButtonVariant.ghost,
                    onPressed: () =>
                        setState(() => _blinkEnabled = !_blinkEnabled),
                    child: Text(_blinkEnabled ? 'STOP' : 'START'),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboySegmentedBar',
              child: Column(
                children: [
                  PipboySegmentedBar(
                    value: 0.85,
                    label: 'HP',
                    segmentCount: 20,
                  ),
                  const SizedBox(height: 8),
                  PipboySegmentedBar(
                    value: 0.55,
                    label: 'AP',
                    segmentCount: 20,
                  ),
                  const SizedBox(height: 8),
                  PipboySegmentedBar(
                    value: 0.2,
                    label: 'RAD',
                    segmentCount: 20,
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyRatedAttribute',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PipboyRatedAttribute(label: 'STR', value: 7),
                  SizedBox(height: 6),
                  PipboyRatedAttribute(label: 'PER', value: 5),
                  SizedBox(height: 6),
                  PipboyRatedAttribute(label: 'END', value: 6),
                  SizedBox(height: 6),
                  PipboyRatedAttribute(label: 'CHA', value: 3),
                  SizedBox(height: 6),
                  PipboyRatedAttribute(label: 'INT', value: 9),
                  SizedBox(height: 6),
                  PipboyRatedAttribute(label: 'AGI', value: 8),
                  SizedBox(height: 6),
                  PipboyRatedAttribute(label: 'LCK', value: 4),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyTerminalPanel',
              child: PipboyTerminalPanel(
                lines: const [
                  'ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM',
                  'COPYRIGHT 2075-2077 ROBCO INDUSTRIES',
                  '',
                  '> ACCESSING VAULT-TEC DATABASE...',
                  '> AUTHENTICATION: GRANTED',
                  '> WELCOME, OVERSEER',
                ],
                typewriter: true,
              ),
            ),
            DemoSection(
              title: 'PipboyCountdown',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PipboyCountdown(
                    duration: const Duration(minutes: 5, seconds: 30),
                    label: 'BOMB TIMER',
                    autoStart: false,
                  ),
                  PipboyCountdown(
                    duration: const Duration(hours: 2),
                    precision: PipboyCountdownPrecision.tenths,
                    label: 'MISSION TIME',
                    autoStart: false,
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyCard & PipboyHud',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  PipboyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        PipboyH2('Standard Card'),
                        SizedBox(height: 8),
                        PipboyDimText('16px padding, border styled.'),
                      ],
                    ),
                  ),
                  PipboyCard(
                    elevated: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        PipboyH2('Elevated Card'),
                        SizedBox(height: 8),
                        PipboyDimText('surfaceHigh background.'),
                      ],
                    ),
                  ),
                  const PipboyHud(child: Text('HUD READOUT: OK')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
