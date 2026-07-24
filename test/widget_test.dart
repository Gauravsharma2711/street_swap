import 'package:flutter_test/flutter_test.dart';

import 'package:street_swap/main.dart';

void main() {
  testWidgets('StreetSwap app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StreetSwapApp());

    // Verify that StreetSwap title is found.
    expect(find.text('StreetSwap'), findsOneWidget);
  });
}
