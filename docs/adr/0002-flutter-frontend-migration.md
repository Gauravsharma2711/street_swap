# ADR 0002: Flutter Frontend Migration

## Status
Accepted

## Context
The team wanted a real installable mobile app and chose Flutter for its beginner-friendly, single-language toolchain to target cross-platform mobile devices natively.

## Decision
- **Storage**: Moved from browser `localStorage` to `shared_preferences` under storage key `"streetswap_listings_v1"`.
- **Domain Layer**: Migrated domain model and validation logic from TypeScript to Dart (`lib/models/`).
- **AI Boundary**: Re-implemented the AI helper in Dart with a deterministic, 100% offline rule-based fallback (`lib/services/rule_based_ai_service.dart`).
- **Navigation**: Moved from web routing to Flutter's built-in `Navigator.push` and `Navigator.pop`.

## Consequences
- **Gained**: Real installable Android APK (`flutter build apk --debug`), hot reload capabilities, native performance, and consistent cross-platform rendering.
- **Gave Up**: Web-only single distribution target (though Flutter web remains supported via `flutter run -d chrome`).

## What Did Not Change
- **No Backend**: Still zero API endpoints, server calls, or network requirements.
- **No Authentication**: User sessions remain unnecessary.
- **No Database**: Pure JSON string serialization in local device storage.
- **Product Loop**: Identical neighborhood trade listing browsing, creation, status transitions, and deletion lifecycle.
