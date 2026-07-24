import '../models/listing.dart';

class AiSuggestion {
  final String improvedDescription;
  final Category suggestedCategory;

  const AiSuggestion({
    required this.improvedDescription,
    required this.suggestedCategory,
  });
}

abstract class LocalAiService {
  Future<AiSuggestion> suggestListingDetails(
    String title,
    String rawDescription,
  );
}
