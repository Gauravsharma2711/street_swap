import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_swap/models/listing.dart';
import 'package:street_swap/screens/create_screen.dart';
import 'package:street_swap/widgets/listing_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Accessibility Compliance Tests', () {
    testWidgets('ListingCard has readable semantics sentence',
        (WidgetTester tester) async {
      final listing = Listing(
        id: 'acc-1',
        title: 'Power Drill',
        category: Category.tools,
        description: 'Cordless power drill',
        area: 'Mission',
        contactPreference: ContactPreference.call,
        status: ListingStatus.open,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListingCard(listing: listing),
          ),
        ),
      );

      final expectedLabel =
          RegExp(r'Power Drill, category tools in Mission\. Status: open\.');
      expect(find.bySemanticsLabel(expectedLabel), findsWidgets);
    });

    testWidgets('CreateScreen validation shows visible red error text messages',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateScreen(),
        ),
      );

      // Attempt to submit empty form
      final submitButton = find.text('CREATE LISTING');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Check visible red error messages
      expect(find.text('Title cannot be empty'), findsOneWidget);
      expect(find.text('Area cannot be empty'), findsOneWidget);
      expect(find.text('Please select a category'), findsOneWidget);
      expect(find.text('Please select a contact preference'), findsOneWidget);
    });

    testWidgets('CreateScreen is wrapped in SingleChildScrollView for font scale support',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.5)),
            child: CreateScreen(),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Suggest Details button has minimum tap target of at least 48x48',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateScreen(),
        ),
      );

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Suggest details'),
      );
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.width, greaterThanOrEqualTo(48.0));
      expect(minSize?.height, greaterThanOrEqualTo(48.0));
    });
  });
}
