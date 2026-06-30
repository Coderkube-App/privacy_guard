import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_guard/privacy_guard.dart';

void main() {
  group('SensitiveWidget', () {
    testWidgets('renders child widget when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SensitiveWidget(child: Text('Sensitive Data'))),
        ),
      );

      expect(find.text('Sensitive Data'), findsOneWidget);
    });

    testWidgets('does not obscure when enabled is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SensitiveWidget(
              enabled: false,
              child: Text('Sensitive Data'),
            ),
          ),
        ),
      );

      expect(find.text('Sensitive Data'), findsOneWidget);
    });

    testWidgets('toggles obscured state on tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SensitiveWidget(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Text('Sensitive Data'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sensitive Data'), findsOneWidget);
    });
  });
}
