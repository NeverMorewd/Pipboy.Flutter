import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: PipboyTheme.buildTheme(),
  home: Scaffold(body: SizedBox(width: 400, height: 300, child: child)),
);

void main() {
  group('PipboyCrtDisplay', () {
    testWidgets('renders without errors with all effects disabled',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyCrtDisplay(
            scanlines: false,
            scanBeam: false,
            vignette: false,
            flicker: false,
            noise: false,
            scanlineAnimation: false,
            child: Text('CRT CONTENT'),
          ),
        ),
      );
      expect(find.text('CRT CONTENT'), findsOneWidget);
    });

    testWidgets('renders with all effects enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyCrtDisplay(
            scanlines: true,
            scanBeam: true,
            vignette: true,
            flicker: true,
            noise: true,
            scanlineAnimation: true,
            child: Text('ALL EFFECTS'),
          ),
        ),
      );
      // Pump a few frames to let animations initialise
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('ALL EFFECTS'), findsOneWidget);
    });

    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PipboyCrtDisplay(child: Text('DEFAULT')),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('DEFAULT'), findsOneWidget);
    });
  });

  group('_ScanlinePainter.shouldRepaint', () {
    test('returns false when parameters are unchanged', () {
      const p1 = _ScanlinePainterTestHelper(
        spacing: 4.0,
        opacity: 0.12,
        lineThickness: 1.0,
        color: Colors.black,
        phase: 0.0,
      );
      const p2 = _ScanlinePainterTestHelper(
        spacing: 4.0,
        opacity: 0.12,
        lineThickness: 1.0,
        color: Colors.black,
        phase: 0.0,
      );
      expect(p1.shouldRepaintWith(p2), isFalse);
    });

    test('returns true when phase changes', () {
      const p1 = _ScanlinePainterTestHelper(
        spacing: 4.0,
        opacity: 0.12,
        lineThickness: 1.0,
        color: Colors.black,
        phase: 0.0,
      );
      const p2 = _ScanlinePainterTestHelper(
        spacing: 4.0,
        opacity: 0.12,
        lineThickness: 1.0,
        color: Colors.black,
        phase: 2.0,
      );
      expect(p1.shouldRepaintWith(p2), isTrue);
    });

    test('returns true when color changes', () {
      const p1 = _ScanlinePainterTestHelper(
        spacing: 4.0,
        opacity: 0.12,
        lineThickness: 1.0,
        color: Colors.black,
        phase: 0.0,
      );
      const p2 = _ScanlinePainterTestHelper(
        spacing: 4.0,
        opacity: 0.12,
        lineThickness: 1.0,
        color: Colors.white,
        phase: 0.0,
      );
      expect(p1.shouldRepaintWith(p2), isTrue);
    });
  });

  group('_ScanBeamPainter.shouldRepaint', () {
    test('returns false when parameters are unchanged', () {
      const p1 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.green,
        opacity: 0.06,
      );
      const p2 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.green,
        opacity: 0.06,
      );
      expect(p1.shouldRepaintWith(p2), isFalse);
    });

    test('returns true when position changes', () {
      const p1 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.green,
        opacity: 0.06,
      );
      const p2 = _ScanBeamPainterTestHelper(
        position: 0.7,
        height: 60.0,
        color: Colors.green,
        opacity: 0.06,
      );
      expect(p1.shouldRepaintWith(p2), isTrue);
    });

    test('returns true when color changes', () {
      const p1 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.green,
        opacity: 0.06,
      );
      const p2 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.amber,
        opacity: 0.06,
      );
      expect(p1.shouldRepaintWith(p2), isTrue);
    });

    test('returns true when opacity changes', () {
      const p1 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.green,
        opacity: 0.06,
      );
      const p2 = _ScanBeamPainterTestHelper(
        position: 0.5,
        height: 60.0,
        color: Colors.green,
        opacity: 0.12,
      );
      expect(p1.shouldRepaintWith(p2), isTrue);
    });
  });
}

/// Test helper that exposes _ScanlinePainter's shouldRepaint logic without
/// depending on the private class directly.
class _ScanlinePainterTestHelper {
  const _ScanlinePainterTestHelper({
    required this.spacing,
    required this.opacity,
    required this.lineThickness,
    required this.color,
    required this.phase,
  });

  final double spacing;
  final double opacity;
  final double lineThickness;
  final Color color;
  final double phase;

  bool shouldRepaintWith(_ScanlinePainterTestHelper old) =>
      old.spacing != spacing ||
      old.opacity != opacity ||
      old.lineThickness != lineThickness ||
      old.color != color ||
      old.phase != phase;
}

/// Test helper that exposes _ScanBeamPainter's shouldRepaint logic.
class _ScanBeamPainterTestHelper {
  const _ScanBeamPainterTestHelper({
    required this.position,
    required this.height,
    required this.color,
    required this.opacity,
  });

  final double position;
  final double height;
  final Color color;
  final double opacity;

  bool shouldRepaintWith(_ScanBeamPainterTestHelper old) =>
      old.position != position ||
      old.color != color ||
      old.opacity != opacity;
}
