import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: PipboyTheme.buildTheme(),
      home: Scaffold(body: child),
    );

void main() {
  group('PipboyPanel', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyPanel(
            title: 'TEST PANEL',
            child: Text('content'),
          ),
        ),
      );
      expect(find.text('TEST PANEL'), findsOneWidget);
    });

    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyPanel(
            title: 'T',
            child: Text('hello world'),
          ),
        ),
      );
      expect(find.text('hello world'), findsOneWidget);
    });

    testWidgets('close button is absent when onClose is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyPanel(
            title: 'T',
            child: SizedBox(),
          ),
        ),
      );
      expect(find.text('[X]'), findsNothing);
    });

    testWidgets('close button fires callback', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        _wrap(
          PipboyPanel(
            title: 'T',
            onClose: () => closed = true,
            child: const SizedBox(),
          ),
        ),
      );
      await tester.tap(find.text('[X]'));
      await tester.pump();
      expect(closed, isTrue);
    });

    testWidgets('footer is rendered when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyPanel(
            title: 'T',
            footer: Text('footer content'),
            child: SizedBox(),
          ),
        ),
      );
      expect(find.text('footer content'), findsOneWidget);
    });

    testWidgets('accent variant renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyPanel(
            title: 'T',
            variant: PipboyPanelVariant.accent,
            child: SizedBox(),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('warning variant renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyPanel(
            title: 'T',
            variant: PipboyPanelVariant.warning,
            child: SizedBox(),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
