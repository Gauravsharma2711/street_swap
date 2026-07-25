import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_swap/models/validation.dart';
import 'package:street_swap/screens/create_screen.dart';
import 'package:street_swap/screens/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Security and Privacy Baseline Tests', () {
    test('validateNewListing enforces strict validation rules including area digit check', () {
      // Valid listing
      final validErrors = validateNewListing(
        title: 'Bicycle',
        description: 'Red mountain bike',
        area: 'Downtown',
      );
      expect(validErrors, isEmpty);

      // Empty title
      final emptyTitleErrors = validateNewListing(
        title: '   ',
        description: 'Valid description',
        area: 'Downtown',
      );
      expect(emptyTitleErrors, contains('Title cannot be empty'));

      // Title over 60 chars
      final longTitleErrors = validateNewListing(
        title: 'A' * 61,
        description: 'Valid description',
        area: 'Downtown',
      );
      expect(longTitleErrors, contains('Title must be under 60 characters'));

      // Description over 500 chars
      final longDescErrors = validateNewListing(
        title: 'Title',
        description: 'D' * 501,
        area: 'Downtown',
      );
      expect(longDescErrors, contains('Description must be under 500 characters'));

      // Empty area
      final emptyAreaErrors = validateNewListing(
        title: 'Title',
        description: 'Valid description',
        area: '   ',
      );
      expect(emptyAreaErrors, contains('Area cannot be empty'));

      // Area with street numbers/digits
      final digitAreaErrors = validateNewListing(
        title: 'Title',
        description: 'Valid description',
        area: '123 Main St',
      );
      expect(
        digitAreaErrors,
        contains('Please use a general area, not a street number'),
      );
    });

    testWidgets('CreateScreen renders area label, helperText, and rejects street numbers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateScreen(),
        ),
      );

      // Verify labelText and helperText
      expect(find.text('Neighborhood or area'), findsOneWidget);
      expect(find.text('Do not enter your exact home address'), findsOneWidget);

      // Enter digits into Area field
      final areaField = find.widgetWithText(TextFormField, 'Neighborhood or area');
      await tester.enterText(areaField, '456 Oak Street');

      // Submit form to trigger validation
      final createButton = find.text('CREATE LISTING');
      await tester.ensureVisible(createButton);
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Please use a general area, not a street number'),
        findsOneWidget,
      );
    });

    testWidgets('SettingsScreen clear data button is protected by AlertDialog confirmation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsScreen(),
        ),
      );

      // Tap clear data button
      final clearButton = find.text('CLEAR ALL LOCAL DATA');
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Verify AlertDialog confirmation appears
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Clear All Local Data'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });
  });
}
