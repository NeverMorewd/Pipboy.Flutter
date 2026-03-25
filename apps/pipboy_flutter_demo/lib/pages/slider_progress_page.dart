import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import '../widgets/demo_section.dart';

class SliderProgressPage extends StatefulWidget {
  const SliderProgressPage({super.key});

  @override
  State<SliderProgressPage> createState() => _SliderProgressPageState();
}

class _SliderProgressPageState extends State<SliderProgressPage> {
  double _slider1 = 0.5;
  double _slider2 = 30;
  RangeValues _range = const RangeValues(20, 70);
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('SLIDERS & PROGRESS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'Slider',
              child: Column(
                children: [
                  Slider(
                    value: _slider1,
                    onChanged: (v) => setState(() => _slider1 = v),
                    label: '${(_slider1 * 100).round()}%',
                    divisions: 10,
                  ),
                  Text(
                    'Volume: ${(_slider1 * 100).round()}%',
                    style: TextStyle(
                      fontFamily: PipboyColorPalette.fontFamily,
                      fontSize: 11,
                      color: palette.textDim,
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Slider with Range',
              child: Column(
                children: [
                  Slider(
                    value: _slider2,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_slider2.round()}',
                    onChanged: (v) => setState(() => _slider2 = v),
                  ),
                  Text(
                    'Radiation: ${_slider2.round()} rads',
                    style: TextStyle(
                      fontFamily: PipboyColorPalette.fontFamily,
                      fontSize: 11,
                      color: palette.textDim,
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'RangeSlider',
              child: Column(
                children: [
                  RangeSlider(
                    values: _range,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    labels: RangeLabels(
                      _range.start.round().toString(),
                      _range.end.round().toString(),
                    ),
                    onChanged: (v) => setState(() => _range = v),
                  ),
                  Text(
                    'Level range: ${_range.start.round()} – ${_range.end.round()}',
                    style: TextStyle(
                      fontFamily: PipboyColorPalette.fontFamily,
                      fontSize: 11,
                      color: palette.textDim,
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Disabled Slider',
              child: Slider(value: 0.4, onChanged: null),
            ),
            DemoSection(
              title: 'LinearProgressIndicator',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: 0.75),
                  const SizedBox(height: 8),
                  Text(
                    'XP: 75%',
                    style: TextStyle(
                      fontFamily: PipboyColorPalette.fontFamily,
                      fontSize: 11,
                      color: palette.textDim,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: 0.3),
                  const SizedBox(height: 8),
                  Text(
                    'Download: 30%',
                    style: TextStyle(
                      fontFamily: PipboyColorPalette.fontFamily,
                      fontSize: 11,
                      color: palette.textDim,
                    ),
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Indeterminate Progress',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _loading
                            ? const LinearProgressIndicator()
                            : Container(height: 6, color: palette.border),
                      ),
                      const SizedBox(width: 12),
                      PipboyButton(
                        variant: PipboyButtonVariant.ghost,
                        onPressed: () => setState(() => _loading = !_loading),
                        child: Text(_loading ? 'CANCEL' : 'LOAD'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'CircularProgressIndicator',
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  CircularProgressIndicator(value: 0.7),
                  const SizedBox(width: 16),
                  CircularProgressIndicator(value: 0.35),
                ],
              ),
            ),
            DemoSection(
              title: 'PipboySegmentedBar',
              child: Column(
                children: [
                  PipboySegmentedBar(value: 0.85, label: 'HP'),
                  const SizedBox(height: 8),
                  PipboySegmentedBar(value: 0.55, label: 'AP'),
                  const SizedBox(height: 8),
                  PipboySegmentedBar(
                    value: 0.2,
                    label: 'RAD',
                    color: palette.warning,
                  ),
                  const SizedBox(height: 8),
                  PipboySegmentedBar(value: 0.0, label: 'DMG'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
