# StreetSwap - Project Brain & Context

## Project Overview
- **Name:** StreetSwap
- **Type:** Local-first marketplace (mobile app)
- **Origin:** Migrated from a React/TypeScript web app to Flutter/Dart.
- **Users:** Allows neighbors to view, create, and track local listings (tools, books, services, free items).

---

## STRICT Architecture Rules (DO NOT BREAK)
1. **No Backend:** There is NO API, NO database, and NO authentication.
2. **Local Storage Only:** All data is saved as a JSON string in `shared_preferences` under the key `"streetswap_listings_v1"`.
3. **No External Packages:** DO NOT add `go_router`, `provider`, `riverpod`, `bloc`, `dio`, or `http`.
4. **Navigation:** Use Flutter's built-in `Navigator.push` and `Navigator.pop`.
5. **State Management:** Use `setState()` inside `StatefulWidgets` only.
6. **Accessibility:** Every interactive UI element must have a `Semantics` label or an `InputDecoration` label.

---

## Domain Model

### Enums
- **Category:** `tools`, `books`, `services`, `free`
- **ListingStatus:** `open`, `saved`, `contacted`, `closed`
- **ContactPreference:** `chatOnly`, `call`, `either`

### Classes
- **Listing:**
  - `id`
  - `title`
  - `category`
  - `description`
  - `area`
  - `contactPreference`
  - `status`
  - `createdAt`

---

## Folder Structure (Layer Boundaries)

```
lib/
├── models/       # Pure data shapes (Listing, Enums) and validation. Zero imports from other layers.
├── data/         # Repository pattern. Abstract class + shared_preferences implementation.
├── services/     # AI boundary (Rule-based, offline fallback).
├── logic/        # Business rules (e.g., status transitions).
├── screens/      # Full page widgets.
└── widgets/      # Small reusable UI components.
```