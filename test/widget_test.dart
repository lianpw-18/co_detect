import 'package:flutter_test/flutter_test.dart';
import 'package:co_detect/main.dart';

void main() {
  testWidgets('CoDetectApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CoDetectApp());
    expect(find.text('Hi, Mrs Adah'), findsOneWidget);
  });
}
