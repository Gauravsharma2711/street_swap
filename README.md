# StreetSwap

## About StreetSwap
StreetSwap is a local-first, offline marketplace app built with **Flutter** and **shared_preferences**. It allows neighbors to view, create, and track local listings (tools, books, services, free items) safely within their community without relying on cloud services or backend servers.

---

## Setup & Running Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.3.0 or higher)
- An Android Emulator, connected mobile device, or Web browser (Chrome)

### 1. Install Dependencies
Run the following command in the project root to fetch all required Flutter dependencies:
```bash
flutter pub get
```

### 2. Run the App
To start the application in debug mode on a connected device, emulator, or Chrome web browser:
```bash
flutter run
```
*Note: Specify target device if multiple devices are attached (e.g. `flutter run -d chrome`).*

### 3. Build Android APK
To build a debug Android APK:
```bash
flutter build apk --debug
```
The output APK file will be generated at `build/app/outputs/flutter-apk/app-debug.apk`.

---

## Architecture Highlights
- **Zero Backend Dependencies**: Operates completely offline using `shared_preferences` key `"streetswap_listings_v1"`.
- **Local AI Helper**: 100% offline rule-based service (`RuleBasedAiService`) for smart category detection and description generation.
- **MongoDB Light Theme**: Clean MongoDB-inspired design system (`#00684A` dark green, `#00ED64` neon green, `#001E2B` dark slate).
