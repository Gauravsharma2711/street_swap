# Local AI Helper Architecture & Offline Verification

## Overview
StreetSwap incorporates an offline AI helper boundary (`LocalAiService`) designed to provide smart listing details and automatic category classification without making network or cloud API calls.

## Architecture & Boundary
- **Interface**: `LocalAiService` in `lib/services/local_ai_service.dart` defines `suggestListingDetails(String title, String rawDescription)`.
- **Implementation**: `RuleBasedAiService` in `lib/services/rule_based_ai_service.dart` provides a 100% on-device deterministic fallback:
  - **Category Classification**: Analyzes keywords in title and description to infer categories (`Category.tools`, `Category.books`, `Category.services`, `Category.free`).
  - **Description Enhancement**: Generates fallback descriptions for empty inputs (e.g. `'Ask about "$title" — details coming soon.'`).
  - **Zero Latency & Network**: Runs synchronously on-device with zero network calls, zero API keys, and zero cloud services.

## How to Verify Offline AI Behavior

To verify that the AI feature functions completely offline without internet connectivity:

### Verification Steps (Android Emulator / Real Device)
1. Launch the StreetSwap app on your Android emulator or physical device.
2. Enable **Airplane Mode** on the device/emulator (or execute `adb shell svc wifi disable` and `adb shell svc data disable` via terminal).
3. Tap the **`+`** button on the feed to open the Create Listing form.
4. Enter a title with keywords (e.g., *"Calculus Study Guide"* or *"Bicycle Repair"*).
5. Tap the **`✨ Suggest details`** button.
6. Verify that:
   - The category automatically selects **`books`** or **`services`** instantly.
   - The description populates with enhanced text.
   - No network error dialogs or timeouts occur.
