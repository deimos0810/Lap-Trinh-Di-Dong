import 'package:flutter_test/flutter_test.dart';
import 'package:buoi10/main.dart';

void main() {
  testWidgets('App starts with WelcomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const PhoneShopApp());
    expect(find.text('Cửa hàng điện thoại'), findsOneWidget);
    expect(find.text('140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh'), findsOneWidget);
  });
}
