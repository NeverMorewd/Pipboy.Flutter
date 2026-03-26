import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

void main() {
  group('PipboyMapController — markers', () {
    late PipboyMapController controller;

    setUp(() {
      controller = PipboyMapController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('addMarker appends a marker', () {
      const marker = PipboyMapMarker(id: 'm1', position: Offset(0.5, 0.5));
      controller.addMarker(marker);
      expect(controller.markers.length, 1);
      expect(controller.markers.first.id, 'm1');
    });

    test('removeMarker deletes by id', () {
      controller.addMarker(
        const PipboyMapMarker(id: 'a', position: Offset(0.1, 0.1)),
      );
      controller.addMarker(
        const PipboyMapMarker(id: 'b', position: Offset(0.9, 0.9)),
      );
      controller.removeMarker('a');
      expect(controller.markers.length, 1);
      expect(controller.markers.first.id, 'b');
    });

    test('clearMarkers empties the list', () {
      controller.addMarker(
        const PipboyMapMarker(id: 'x', position: Offset(0.5, 0.5)),
      );
      controller.clearMarkers();
      expect(controller.markers, isEmpty);
    });

    test('notifyListeners fires after addMarker', () {
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.addMarker(
        const PipboyMapMarker(id: 'n', position: Offset(0.5, 0.5)),
      );
      expect(callCount, 1);
    });

    test('notifyListeners fires after removeMarker', () {
      controller.addMarker(
        const PipboyMapMarker(id: 'r', position: Offset(0.5, 0.5)),
      );
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.removeMarker('r');
      expect(callCount, 1);
    });

    test('notifyListeners fires after clearMarkers', () {
      controller.addMarker(
        const PipboyMapMarker(id: 'c', position: Offset(0.5, 0.5)),
      );
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.clearMarkers();
      expect(callCount, 1);
    });

    test('markers list is unmodifiable', () {
      controller.addMarker(
        const PipboyMapMarker(id: 'u', position: Offset(0.5, 0.5)),
      );
      expect(
        () => controller.markers.add(
          const PipboyMapMarker(id: 'extra', position: Offset(0.0, 0.0)),
        ),
        throwsUnsupportedError,
      );
    });
  });

  group('PipboyMapController — lines', () {
    late PipboyMapController controller;

    setUp(() {
      controller = PipboyMapController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('addLine appends a line', () {
      const line = PipboyMapLine(
        id: 'l1',
        start: Offset(0.0, 0.0),
        end: Offset(1.0, 1.0),
      );
      controller.addLine(line);
      expect(controller.lines.length, 1);
      expect(controller.lines.first.id, 'l1');
    });

    test('removeLine deletes by id', () {
      controller.addLine(
        const PipboyMapLine(
          id: 'la',
          start: Offset(0.0, 0.0),
          end: Offset(0.5, 0.5),
        ),
      );
      controller.addLine(
        const PipboyMapLine(
          id: 'lb',
          start: Offset(0.5, 0.5),
          end: Offset(1.0, 1.0),
        ),
      );
      controller.removeLine('la');
      expect(controller.lines.length, 1);
      expect(controller.lines.first.id, 'lb');
    });

    test('clearLines empties the list', () {
      controller.addLine(
        const PipboyMapLine(
          id: 'lx',
          start: Offset(0.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      );
      controller.clearLines();
      expect(controller.lines, isEmpty);
    });

    test('clearAll empties markers and lines', () {
      controller.addMarker(
        const PipboyMapMarker(id: 'm', position: Offset(0.5, 0.5)),
      );
      controller.addLine(
        const PipboyMapLine(
          id: 'l',
          start: Offset(0.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      );
      controller.clearAll();
      expect(controller.markers, isEmpty);
      expect(controller.lines, isEmpty);
    });

    test('notifyListeners fires after addLine', () {
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.addLine(
        const PipboyMapLine(
          id: 'ln',
          start: Offset(0.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      );
      expect(callCount, 1);
    });

    test('notifyListeners fires after removeLine', () {
      controller.addLine(
        const PipboyMapLine(
          id: 'lr',
          start: Offset(0.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      );
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.removeLine('lr');
      expect(callCount, 1);
    });

    test('notifyListeners fires after clearLines', () {
      controller.addLine(
        const PipboyMapLine(
          id: 'lc',
          start: Offset(0.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      );
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.clearLines();
      expect(callCount, 1);
    });

    test('notifyListeners fires after clearAll', () {
      int callCount = 0;
      controller.addListener(() => callCount++);
      controller.clearAll();
      expect(callCount, 1);
    });

    test('lines list is unmodifiable', () {
      controller.addLine(
        const PipboyMapLine(
          id: 'lu',
          start: Offset(0.0, 0.0),
          end: Offset(1.0, 1.0),
        ),
      );
      expect(
        () => controller.lines.add(
          const PipboyMapLine(
            id: 'extra',
            start: Offset(0.0, 0.0),
            end: Offset(1.0, 1.0),
          ),
        ),
        throwsUnsupportedError,
      );
    });
  });

  group('PipboyMapMarker.copyWith', () {
    const original = PipboyMapMarker(
      id: 'orig',
      position: Offset(0.3, 0.7),
      kind: PipboyMapMarkerKind.pin,
      label: 'ORIGINAL',
      isVisible: true,
      isBlinking: false,
    );

    test('copyWith with no arguments returns equivalent marker', () {
      final copy = original.copyWith();
      expect(copy.id, original.id);
      expect(copy.position, original.position);
      expect(copy.kind, original.kind);
      expect(copy.label, original.label);
      expect(copy.isVisible, original.isVisible);
      expect(copy.isBlinking, original.isBlinking);
    });

    test('copyWith replaces id', () {
      final copy = original.copyWith(id: 'new_id');
      expect(copy.id, 'new_id');
      expect(copy.position, original.position);
    });

    test('copyWith replaces position', () {
      final copy = original.copyWith(position: const Offset(0.9, 0.1));
      expect(copy.position, const Offset(0.9, 0.1));
      expect(copy.id, original.id);
    });

    test('copyWith replaces kind', () {
      final copy = original.copyWith(kind: PipboyMapMarkerKind.star);
      expect(copy.kind, PipboyMapMarkerKind.star);
      expect(copy.id, original.id);
    });

    test('copyWith replaces label', () {
      final copy = original.copyWith(label: 'UPDATED');
      expect(copy.label, 'UPDATED');
    });

    test('copyWith replaces isBlinking', () {
      final copy = original.copyWith(isBlinking: true);
      expect(copy.isBlinking, isTrue);
      expect(copy.id, original.id);
    });
  });
}
