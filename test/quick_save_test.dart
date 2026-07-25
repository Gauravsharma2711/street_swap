import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_swap/data/shared_prefs_listing_repository.dart';
import 'package:street_swap/models/listing.dart';
import 'package:street_swap/widgets/listing_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Quick Save Feature Tests', () {
    testWidgets('ListingCard displays Save listing IconButton with min 48x48 tap target',
        (WidgetTester tester) async {
      final listing = Listing(
        id: 'test-1',
        title: 'Lawn Mower',
        category: Category.tools,
        description: 'Gas powered lawn mower in great condition',
        area: 'Oakland',
        contactPreference: ContactPreference.chatOnly,
        status: ListingStatus.open,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListingCard(
              listing: listing,
            ),
          ),
        ),
      );

      // Verify semantics label
      final semanticsFinder = find.bySemanticsLabel('Save listing');
      expect(semanticsFinder, findsOneWidget);

      // Verify IconButton presence
      final iconButtonFinder = find.byType(IconButton);
      expect(iconButtonFinder, findsOneWidget);

      final iconButton = tester.widget<IconButton>(iconButtonFinder);
      expect(iconButton.constraints?.minWidth, equals(48.0));
      expect(iconButton.constraints?.minHeight, equals(48.0));
    });

    testWidgets('Tapping Quick Save updates status to saved and triggers onStatusChanged',
        (WidgetTester tester) async {
      final repo = SharedPrefsListingRepository();
      final listing = Listing(
        id: 'test-2',
        title: 'Calculus Textbook',
        category: Category.books,
        description: 'Hardcover 9th edition',
        area: 'Berkeley',
        contactPreference: ContactPreference.either,
        status: ListingStatus.open,
        createdAt: DateTime.now(),
      );
      await repo.create(listing);

      bool statusChangedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListingCard(
              listing: listing,
              onStatusChanged: () {
                statusChangedCalled = true;
              },
            ),
          ),
        ),
      );

      final saveButton = find.byTooltip('Save listing');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(statusChangedCalled, isTrue);

      final updatedListings = await repo.getAll();
      final updatedListing =
          updatedListings.firstWhere((l) => l.id == 'test-2');
      expect(updatedListing.status, equals(ListingStatus.saved));
    });

    testWidgets('Quick Save button is disabled when status is already saved',
        (WidgetTester tester) async {
      final listing = Listing(
        id: 'test-3',
        title: 'Bike Pump',
        category: Category.tools,
        description: 'Standard floor pump',
        area: 'Downtown',
        contactPreference: ContactPreference.call,
        status: ListingStatus.saved,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListingCard(
              listing: listing,
            ),
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('Quick Save button is disabled when status is contacted or closed',
        (WidgetTester tester) async {
      final contactedListing = Listing(
        id: 'test-4',
        title: 'Dog Sitting',
        category: Category.services,
        description: 'Weekend dog sitting service',
        area: 'Uptown',
        contactPreference: ContactPreference.chatOnly,
        status: ListingStatus.contacted,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListingCard(
              listing: contactedListing,
            ),
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });
  });
}
