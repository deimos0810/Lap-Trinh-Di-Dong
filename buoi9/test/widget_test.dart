import 'package:flutter_test/flutter_test.dart';
import 'package:lab9_flutter_sqlite/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Buoi9App());
    expect(find.byType(Buoi9App), findsOneWidget);
  });
}
