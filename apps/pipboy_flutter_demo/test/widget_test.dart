import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';
import 'package:pipboy_flutter_demo/app.dart';

void main() {
  testWidgets('Demo app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(PipboyThemeManager(child: const PipboyDemoApp()));
    await tester.pump();
    // The overview page should be visible.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
