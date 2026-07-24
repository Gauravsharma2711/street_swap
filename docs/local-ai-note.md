# Local AI Helper Architecture

## Overview
StreetSwap includes an offline AI helper boundary (`LocalAiService`) designed to provide smart listing details and automatic category classification without making network or cloud API calls.

## Offline Fallback Service
The concrete implementation in `lib/services/rule_based_ai_service.dart` provides a deterministic, 100% offline fallback service:
- **Category Inference**: Analyzes keywords in the listing title and description to infer categories (`Category.tools`, `Category.books`, `Category.services`, `Category.free`).
- **Description Enhancement**: Automatically generates fallback descriptions for empty inputs (e.g., `'Ask about "$title" — details coming soon.'`) while leaving the output 100% editable by the user.
- **Zero Latency & Zero Network**: Executes synchronously on the client device thread without requiring external API keys, tokens, or active internet connectivity.

## How to Verify Offline Behavior
To verify that the AI feature functions completely offline without internet connection:
1. Enable **Airplane Mode** on your Android emulator or test mobile device (or run `adb shell svc wifi disable` and `adb shell svc data disable`).
2. Open StreetSwap and tap the **`+`** button to open the Create Listing form.
3. Enter a title (e.g., *"Calculus Study Guide"*) and tap the **`✨ Suggest details`** button.
4. Confirm that the description auto-populates and the category selects **`books`** instantly while offline.
