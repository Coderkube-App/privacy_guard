import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_guard_example/main.dart';

void main() {
  testWidgets('Example app renders', (tester) async {
    await tester.pumpWidget(const PrivacyGuardExampleApp());
    expect(find.text('Privacy Guard'), findsOneWidget);
    expect(find.text('Banking Dashboard'), findsOneWidget);
  });
}
