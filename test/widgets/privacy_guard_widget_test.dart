import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_guard/privacy_guard.dart';

void main() {
  group('PrivacyGuard widget', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PrivacyGuard(child: Text('Protected Content'))),
      );

      expect(find.text('Protected Content'), findsOneWidget);
      expect(find.text('Content Hidden'), findsNothing);
    });

    testWidgets('shows overlay when app is backgrounded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PrivacyGuard(child: Text('Protected Content'))),
      );

      final state = tester.state<State<PrivacyGuard>>(
        find.byType(PrivacyGuard),
      );
      (state as dynamic).didChangeAppLifecycleState(AppLifecycleState.paused);
      await tester.pump();

      expect(find.text('Content Hidden'), findsOneWidget);
    });

    testWidgets('hides overlay when app returns to foreground', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PrivacyGuard(child: Text('Protected Content'))),
      );

      final state = tester.state<State<PrivacyGuard>>(
        find.byType(PrivacyGuard),
      );
      (state as dynamic).didChangeAppLifecycleState(AppLifecycleState.paused);
      await tester.pump();
      expect(find.text('Content Hidden'), findsOneWidget);

      (state as dynamic).didChangeAppLifecycleState(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.text('Content Hidden'), findsNothing);
    });
  });
}
