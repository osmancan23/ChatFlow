import 'package:chat_flow/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  setUpAll(() async {
    await TestHelper.setupFirebaseForTesting();
  });

  testWidgets('App başlangıç testi', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Giriş Yap'), findsOneWidget);
  });
}
