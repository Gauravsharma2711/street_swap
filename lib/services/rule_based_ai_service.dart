import '../models/listing.dart';
import 'local_ai_service.dart';

class RuleBasedAiService implements LocalAiService {
  Category _guessCategory(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('book') || lower.contains('study')) {
      return Category.books;
    }
    if (lower.contains('fix') ||
        lower.contains('repair') ||
        lower.contains('clean')) {
      return Category.services;
    }
    if (lower.contains('free') || lower.contains('giveaway')) {
      return Category.free;
    }
    return Category.tools;
  }

  @override
  Future<AiSuggestion> suggestListingDetails(
    String title,
    String rawDescription,
  ) async {
    try {
      final trimmedTitle = title.trim();
      final trimmedDesc = rawDescription.trim();

      final finalDescription = trimmedDesc.isEmpty
          ? 'Ask about "$trimmedTitle" — details coming soon.'
          : trimmedDesc;

      final combinedText = '$trimmedTitle $finalDescription';
      final category = _guessCategory(combinedText);

      return AiSuggestion(
        improvedDescription: finalDescription,
        suggestedCategory: category,
      );
    } catch (_) {
      return AiSuggestion(
        improvedDescription: rawDescription.trim().isEmpty
            ? 'Ask about "$title" — details coming soon.'
            : rawDescription.trim(),
        suggestedCategory: Category.tools,
      );
    }
  }
}
