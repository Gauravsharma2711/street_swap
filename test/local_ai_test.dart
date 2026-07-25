import 'package:flutter_test/flutter_test.dart';
import 'package:street_swap/models/listing.dart';
import 'package:street_swap/services/rule_based_ai_service.dart';

void main() {
  group('Local AI Service Tests', () {
    final aiService = RuleBasedAiService();

    test('Suggests books category for study/book keywords', () async {
      final suggestion = await aiService.suggestListingDetails(
        'Calculus Study Guide',
        '',
      );

      expect(suggestion.suggestedCategory, equals(Category.books));
      expect(
        suggestion.improvedDescription,
        equals('Ask about "Calculus Study Guide" — details coming soon.'),
      );
    });

    test('Suggests services category for repair/fix keywords', () async {
      final suggestion = await aiService.suggestListingDetails(
        'Bicycle Repair',
        'Will fix flat tires',
      );

      expect(suggestion.suggestedCategory, equals(Category.services));
      expect(suggestion.improvedDescription, equals('Will fix flat tires'));
    });

    test('Suggests free category for giveaway keywords', () async {
      final suggestion = await aiService.suggestListingDetails(
        'Free Couch',
        'Pickup only',
      );

      expect(suggestion.suggestedCategory, equals(Category.free));
      expect(suggestion.improvedDescription, equals('Pickup only'));
    });

    test('Defaults to tools category for other items', () async {
      final suggestion = await aiService.suggestListingDetails(
        'Hammer and Screwdriver',
        'Basic tool set',
      );

      expect(suggestion.suggestedCategory, equals(Category.tools));
      expect(suggestion.improvedDescription, equals('Basic tool set'));
    });
  });
}
