import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class CrtDisplayPage extends StatefulWidget {
  const CrtDisplayPage({super.key});

  @override
  State<CrtDisplayPage> createState() => _CrtDisplayPageState();
}

class _CrtDisplayPageState extends State<CrtDisplayPage> {
  bool _scanlines = true;
  bool _scanBeam = true;
  bool _vignette = true;
  bool _flicker = false;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('CRT DISPLAY')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'Effect Toggles',
              child: Column(
                children: [
                  PipboySwitchTile(
                    value: _scanlines,
                    onChanged: (v) => setState(() => _scanlines = v),
                    title: const Text('SCANLINES'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  PipboySwitchTile(
                    value: _scanBeam,
                    onChanged: (v) => setState(() => _scanBeam = v),
                    title: const Text('SCAN BEAM'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  PipboySwitchTile(
                    value: _vignette,
                    onChanged: (v) => setState(() => _vignette = v),
                    title: const Text('VIGNETTE'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  PipboySwitchTile(
                    value: _flicker,
                    onChanged: (v) => setState(() => _flicker = v),
                    title: const Text('FLICKER'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboyCrtDisplay',
              child: SizedBox(
                height: 300,
                child: PipboyCrtDisplay(
                  scanlines: _scanlines,
                  scanBeam: _scanBeam,
                  vignette: _vignette,
                  flicker: _flicker,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ROBCO INDUSTRIES (TM) TERMLINK PROTOCOL',
                          style: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 13,
                            color: palette.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ENTER PASSWORD NOW',
                          style: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 13,
                            color: palette.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '15 ATTEMPT(S) REMAINING: ■ ■ ■ ■',
                          style: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 12,
                            color: palette.textDim,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...const [
                          'VAULT111  NUCLEAR   SHELTER  CITIZEN',
                          'OVERSEER  MANKIND   SHELTER  REACTOR',
                          'FALLOUT   NUCLEAR   SHELTER  BUNKER',
                          'SURVIVAL  PROTECT   SHELTER  DEATHCL',
                        ].map(
                          (line) => Text(
                            line,
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 12,
                              color: palette.primary,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              '>',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 13,
                                color: palette.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            PipboyBlinkText(
                              '_',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 13,
                                color: palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            DemoSection(
              title: 'Scanline Overlay Only',
              child: SizedBox(
                height: 100,
                child: PipboyScanlineOverlay(
                  spacing: 3,
                  opacity: 0.2,
                  child: Container(
                    color: palette.surface,
                    alignment: Alignment.center,
                    child: Text(
                      'SCANLINE EFFECT',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
                        color: palette.primary,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DemoSection(
              title: 'Vignette Overlay Only',
              child: SizedBox(
                height: 100,
                child: PipboyVignetteOverlay(
                  intensity: 0.7,
                  child: Container(
                    color: palette.surface,
                    alignment: Alignment.center,
                    child: Text(
                      'VIGNETTE EFFECT',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
                        color: palette.primary,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
