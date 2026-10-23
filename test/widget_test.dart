


import 'package:flutter_test/flutter_test.dart';
import 'package:moviemind/main.dart';

void main() {
  testWidgets('MovieMind app starts successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MovieMindApp());

    expect(find.byType(MovieMindApp), findsOneWidget);
  });
}
