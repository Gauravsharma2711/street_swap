# StreetSwap 🛠️📚🧹🎁

StreetSwap is a local-first, privacy-focused mobile marketplace built with **Flutter** and **Dart**. It empowers neighbors to view, create, trade, and track local listings (tools, books, services, free items) safely within their community — **100% offline without relying on cloud services, external backend APIs, or user accounts.**

---

## 🌟 How It Works

StreetSwap operates around a seamless 4-step local product loop:

```
  ┌─────────────────┐       ┌──────────────────┐
  │   Browse Feed   │ ───>  │  Create Listing  │
  └─────────────────┘       └──────────────────┘
           │                         │
           │ Quick Save              │ Submit Form
           ▼                         ▼
  ┌─────────────────┐       ┌──────────────────┐
  │ Status: Saved   │ <───  │   View Details   │
  └─────────────────┘       └──────────────────┘
           │                         │
           │ Transition              │ Change Status
           ▼                         ▼
  ┌─────────────────┐       ┌──────────────────┐
  │Contacted / Closed│ <─── │ Mark as Closed   │
  └─────────────────┘       └──────────────────┘
```

### 1. Browse & Search Listings Feed
- **Category-Grouped Feed**: Listings are categorized into four local exchange types:
  - 🛠️ **TOOLS** (Drills, lawn mowers, hardware)
  - 📚 **BOOKS** (Textbooks, novels, study guides)
  - 🧹 **SERVICES** (Repairs, dog sitting, lawn care)
  - 🎁 **FREE** (Giveaways, furniture, spare items)
- **Real-Time Title Search**: Filter listings instantly as you type.
- **Pull-to-Refresh**: Seamlessly reload listings from local device storage.

### 2. Quick Save from Feed
- **One-Tap Bookmarking**: Tap the trailing bookmark icon (`Icons.bookmark_border`) directly on any feed listing card.
- **Instant Local Storage Sync**: Updates the listing status to `saved` in `shared_preferences` and reloads the UI without navigating away.
- **Visual Feedback**: Once saved, the icon transitions to a filled bookmark (`Icons.bookmark`) in disabled state.

### 3. Create Listing with On-Device AI Helper
- Tap the **`+`** Floating Action Button to post a new listing.
- Fill in: **Title**, **Category**, **Description**, **Neighborhood Area**, and **Contact Preference** (`chatOnly`, `call`, or `either`).
- **✨ Suggest Details (Offline AI Helper)**: Tap to auto-predict the category from keywords and generate helpful description fallbacks **completely offline** with zero network calls.

### 4. Item Details & Status Lifecycle
- Tap any card to open the full detail view.
- Track trade status using isolated business rules:
  - **`MARK AS SAVED`**: Bookmark item for future reference.
  - **`MARK AS CONTACTED`**: Record that you have reached out to the poster.
  - **`MARK AS CLOSED`**: Close the transaction when trade is complete.

---

## 🔒 Security & Privacy Baseline

- **Neighborhood Privacy Protection**: The Area field strictly enforces neighborhood-level privacy by blocking house/street numbers via regex validation (`RegExp(r'\d')`), returning *"Please use a general area, not a street number"*.
- **Zero Secrets / Zero Tracking**: No API keys, credentials, or remote endpoints exist anywhere in the application code.
- **Protected Data Reset**: Local data clear operations in Settings are guarded by an explicit `AlertDialog` confirmation modal (`Cancel` / `Clear`).

---

## ♿ Accessibility Compliance

- **Screen Reader Announcements**: `ListingCard` builds natural language semantics sentences (`"Power Drill, category tools in Mission. Status: open."`).
- **Control Labels**: All buttons, icons, and cards have explicit `Semantics` wrappers with `button: true`.
- **Visible Red Error Text**: Form validation failures render bold, visible red text error messages below fields.
- **Usable Touch Targets**: All interactive elements satisfy minimum **48x48 logical pixel** touch target dimensions.
- **Dynamic Text Scaling**: All screens wrap form content inside `SingleChildScrollView` to prevent layout clipping when system font scaling is increased up to 250%+.

---

## 🛠️ Tech Stack & Architecture Highlights

- **Framework**: Flutter (Material 3, Light MongoDB-inspired theme)
- **Storage**: Local persistence via `shared_preferences` under key `"streetswap_listings_v1"`, isolated behind abstract `ListingRepository`.
- **Business Logic**: Status transitions isolated in pure Dart module `lib/logic/status_rules.dart`.
- **AI Boundary**: Abstract `LocalAiService` interface with deterministic `RuleBasedAiService` implementation.
- **Dependencies**: Built purely with Flutter SDK built-ins — **Zero third-party packages**.

---

## 🚀 Setup & Running Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.3.0 or higher)
- An Android Emulator, iOS Simulator, connected mobile device, or Chrome browser.

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run All Automated Tests
```bash
flutter test
```

### 3. Run the App
```bash
flutter run
```
*Specify target device if multiple are attached (e.g., `flutter run -d chrome`).*

### 4. Build Android APK
```bash
flutter build apk --debug
```

---

## 📚 Project Documentation

For detailed design records and architectural guidelines, see the `docs/` directory:
- 📄 [Architecture Decision Record (ADR 0001)](docs/adr/0001-local-first-marketplace-slice.md)
- 📄 [Product Loop & Features](docs/product-slice.md)
- 📄 [Success Metrics Checklist](docs/success-metrics.md)
- 📄 [Accessibility Audit Report](docs/accessibility-check.md)
- 📄 [Security & Privacy Baseline](docs/security-baseline.md)
- 📄 [Local AI Offline Note](docs/local-ai-note.md)
