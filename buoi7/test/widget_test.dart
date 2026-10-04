import 'package:flutter_test/flutter_test.dart';
import 'package:buoi7/main.dart';

void main() {
  testWidgets('Buoi7App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Buoi7App());
    expect(find.byType(Buoi7App), findsOneWidget);
  });
}
