import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_swap/main.dart';
import 'package:street_swap/models/listing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Product Loop E2E Test', () {
    testWidgets(
        'Verify Product Loop: View Feed -> Create Listing -> View Details -> Mark Status',
        (WidgetTester tester) async {
      await tester.pumpWidget(const StreetSwapApp());
      await tester.pumpAndSettle();

      // 1. View Feed
      expect(find.text('StreetSwap'), findsWidgets);

      // 2. Create Listing (Tap FAB)
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('New Listing'), findsOneWidget);

      // Enter Title
      final titleField = find.widgetWithText(TextFormField, 'Title');
      await tester.enterText(titleField, 'Gardening Shears');

      // Enter Description
      final descField = find.widgetWithText(TextFormField, 'Description');
      await tester.enterText(descField, 'Heavy duty pruning shears for garden');

      // Enter Area
      final areaField =
          find.widgetWithText(TextFormField, 'Neighborhood or area');
      await tester.enterText(areaField, 'Sunset District');

      // Select Category
      final categoryDropdown = find.byType(DropdownButtonFormField<Category>);
      await tester.tap(categoryDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('tools').last);
      await tester.pumpAndSettle();

      // Select Contact Preference
      final contactDropdown =
          find.byType(DropdownButtonFormField<ContactPreference>);
      await tester.tap(contactDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('chatOnly').last);
      await tester.pumpAndSettle();

      // Tap Create Listing
      final createButton = find.text('CREATE LISTING');
      await tester.ensureVisible(createButton);
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      // Verified back on Feed Screen with new listing
      expect(find.text('Gardening Shears'), findsOneWidget);

      // 3. View Details
      await tester.tap(find.text('Gardening Shears'));
      await tester.pumpAndSettle();

      expect(find.text('Sunset District'), findsWidgets);
      expect(find.text('MARK AS SAVED'), findsOneWidget);
      expect(find.text('MARK AS CONTACTED'), findsOneWidget);
      expect(find.text('MARK AS CLOSED'), findsOneWidget);

      // 4. Mark as Saved
      await tester.tap(find.text('MARK AS SAVED'));
      await tester.pumpAndSettle();

      expect(find.text('Status: SAVED'), findsOneWidget);

      // Pop back to feed
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Gardening Shears'), findsOneWidget);
    });
  });
}
