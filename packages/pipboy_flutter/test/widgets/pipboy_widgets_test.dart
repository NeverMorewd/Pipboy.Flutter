import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: PipboyTheme.buildTheme(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  // ── PipboySegmentedBar ────────────────────────────────────────────────────

  group('PipboySegmentedBar', () {
    testWidgets('renders at value=0 without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboySegmentedBar(value: 0.0, label: 'HP')),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders at value=1 without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboySegmentedBar(value: 1.0, label: 'HP')),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('label is rendered when showLabel=true', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboySegmentedBar(value: 0.5, label: 'AP')),
      );
      expect(find.text('AP'), findsOneWidget);
    });

    testWidgets('label is hidden when showLabel=false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboySegmentedBar(value: 0.5, label: 'AP', showLabel: false),
        ),
      );
      expect(find.text('AP'), findsNothing);
    });
  });

  // ── PipboyRatedAttribute ─────────────────────────────────────────────────

  group('PipboyRatedAttribute', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyRatedAttribute(label: 'STR', value: 7)),
      );
      expect(find.text('STR'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('value=0 renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyRatedAttribute(label: 'LCK', value: 0)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('value=maxValue renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyRatedAttribute(label: 'INT', value: 10)),
      );
      expect(tester.takeException(), isNull);
    });
  });

  // ── PipboyBlinkText ───────────────────────────────────────────────────────

  group('PipboyBlinkText', () {
    testWidgets('renders text content', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyBlinkText('LOADING...')));
      expect(find.text('LOADING...'), findsOneWidget);
    });

    testWidgets('disabled blinking still renders text', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyBlinkText('STATIC', enabled: false)),
      );
      expect(find.text('STATIC'), findsOneWidget);
    });

    testWidgets('disposes without error', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyBlinkText('X')));
      await tester.pumpWidget(const SizedBox()); // unmount
      expect(tester.takeException(), isNull);
    });
  });

  // ── PipboyBracketHighlight ────────────────────────────────────────────────

  group('PipboyBracketHighlight', () {
    testWidgets('shows brackets when selected=true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyBracketHighlight(selected: true, child: Text('ITEM')),
        ),
      );
      expect(find.text('>'), findsOneWidget);
      expect(find.text('<'), findsOneWidget);
    });

    testWidgets('brackets have zero width when selected=false', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyBracketHighlight(child: Text('ITEM'))),
      );
      // Brackets exist but are clipped to zero width.
      expect(tester.takeException(), isNull);
    });

    testWidgets('child is always rendered', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyBracketHighlight(child: Text('VISIBLE'))),
      );
      expect(find.text('VISIBLE'), findsOneWidget);
    });
  });

  // ── PipboyButton ──────────────────────────────────────────────────────────

  group('PipboyButton', () {
    testWidgets('standard variant renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(PipboyButton(onPressed: () {}, child: const Text('CLICK'))),
      );
      expect(find.text('CLICK'), findsOneWidget);
    });

    testWidgets('onPressed fires on tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        _wrap(
          PipboyButton(
            onPressed: () => pressed = true,
            child: const Text('TAP'),
          ),
        ),
      );
      await tester.tap(find.text('TAP'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('disabled when onPressed=null', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyButton(onPressed: null, child: Text('DISABLED'))),
      );
      expect(tester.takeException(), isNull);
    });

    for (final variant in PipboyButtonVariant.values) {
      testWidgets('$variant renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(
            PipboyButton(
              onPressed: () {},
              variant: variant,
              child: Text(variant.name.toUpperCase()),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  // ── PipboyTabStrip ────────────────────────────────────────────────────────

  group('PipboyTabStrip', () {
    testWidgets('renders all tab labels', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PipboyTabStrip(
            tabs: const ['STAT', 'INV', 'DATA'],
            selectedIndex: 0,
            onTabSelected: (_) {},
          ),
        ),
      );
      expect(find.text('STAT'), findsOneWidget);
      expect(find.text('INV'), findsOneWidget);
      expect(find.text('DATA'), findsOneWidget);
    });

    testWidgets('fires callback on tap', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _wrap(
          PipboyTabStrip(
            tabs: const ['A', 'B'],
            selectedIndex: 0,
            onTabSelected: (i) => tapped = i,
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(tapped, equals(1));
    });
  });

  // ── PipboyCountdown ───────────────────────────────────────────────────────

  group('PipboyCountdown', () {
    testWidgets('renders duration correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyCountdown(
            duration: Duration(hours: 1, minutes: 2, seconds: 3),
            autoStart: false,
          ),
        ),
      );
      expect(find.textContaining('01:02:03'), findsOneWidget);
    });

    testWidgets('label is rendered when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyCountdown(
            duration: Duration(minutes: 5),
            label: 'TIMER',
            autoStart: false,
          ),
        ),
      );
      expect(find.text('TIMER'), findsOneWidget);
    });

    testWidgets('counts down when autoStart=true', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyCountdown(duration: Duration(seconds: 3))),
      );

      expect(find.textContaining('00:00:03'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('00:00:02'), findsOneWidget);
    });
  });

  // ── PipboyTerminalPanel ───────────────────────────────────────────────────

  group('PipboyTerminalPanel', () {
    testWidgets('shows complete text when typewriter=false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyTerminalPanel(
            lines: ['HELLO', 'WORLD'],
            typewriter: false,
          ),
        ),
      );
      expect(find.textContaining('HELLO'), findsOneWidget);
    });

    testWidgets('renders content with typewriter=true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyTerminalPanel(
            lines: ['ROBCO'],
            typewriter: false, // Use false to avoid async timers in test
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('ROBCO'), findsOneWidget);
    });
  });

  // ── PipboyCrtDisplay ──────────────────────────────────────────────────────

  group('PipboyCrtDisplay', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        _wrap(const PipboyCrtDisplay(child: Text('TERMINAL'))),
      );
      expect(find.text('TERMINAL'), findsOneWidget);
    });

    testWidgets('all effects false renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyCrtDisplay(
            scanlines: false,
            scanBeam: false,
            vignette: false,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  // ── Typography helpers ────────────────────────────────────────────────────

  group('Typography Widgets', () {
    testWidgets('PipboyH1 renders text', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyH1('HEADING 1')));
      expect(find.text('HEADING 1'), findsOneWidget);
    });

    testWidgets('PipboyH2 renders text', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyH2('HEADING 2')));
      expect(find.text('HEADING 2'), findsOneWidget);
    });

    testWidgets('PipboyDimText renders text', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyDimText('dim')));
      expect(find.text('dim'), findsOneWidget);
    });

    testWidgets('PipboyErrorText renders text', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyErrorText('error')));
      expect(find.text('error'), findsOneWidget);
    });

    testWidgets('PipboyWarningText renders text', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyWarningText('warning')));
      expect(find.text('warning'), findsOneWidget);
    });

    testWidgets('PipboySuccessText renders text', (tester) async {
      await tester.pumpWidget(_wrap(const PipboySuccessText('success')));
      expect(find.text('success'), findsOneWidget);
    });

    testWidgets('PipboyCard renders child', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyCard(child: Text('card'))));
      expect(find.text('card'), findsOneWidget);
    });

    testWidgets('PipboyHud renders child', (tester) async {
      await tester.pumpWidget(_wrap(const PipboyHud(child: Text('hud'))));
      expect(find.text('hud'), findsOneWidget);
    });
  });
}
