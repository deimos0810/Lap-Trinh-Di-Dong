import 'package:flutter_test/flutter_test.dart';
import 'package:buoi8/main.dart';

void main() {
  testWidgets('MainDashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify title and exercises are displayed
    expect(find.text('Buổi 08: Notification & File'), findsOneWidget);
    expect(find.text('DANH SÁCH BÀI TẬP'), findsOneWidget);
    expect(find.text('BÀI TẬP 3 (TẠI LỚP)'), findsOneWidget);
    expect(find.text('BÀI TẬP 4 (TẠI LỚP)'), findsOneWidget);
    expect(find.text('BÀI TẬP VỀ NHÀ'), findsOneWidget);
  });
}
