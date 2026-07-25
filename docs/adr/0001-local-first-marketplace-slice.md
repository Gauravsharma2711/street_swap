# ADR 0001: Local-First Marketplace Architecture

- **Status:** Accepted
- **Date:** 2026-07-25
- **Deciders:** StreetSwap Engineering Team

## Context and Problem Statement
Local marketplace mobile applications often suffer from latency, complex account setups, connectivity requirements, and cloud privacy concerns. Neighbors trading tools, books, services, or free items locally require an intuitive app that operates seamlessly offline, guarantees data privacy, and retains fast local storage without cloud backend dependencies.

## Decision Drivers
- **Offline First & Privacy:** Zero cloud network dependencies, zero tracking, zero external databases.
- **Maintainability & Simplicity:** Decoupled layer architecture without heavy third-party framework overhead.
- **Extensibility:** Clear interface boundaries for storage, business logic, and local AI capabilities.

## Considered Options
1. **Cloud-first Architecture (Firebase/REST API):** Requires internet connectivity, authentication, and remote database infrastructure.
2. **Local-First Layered Architecture (Chosen Option):** Abstract interface repositories, local persistence (`shared_preferences`), isolated domain models, pure business logic, and local AI boundary.

## Decision Outcome
Chosen Option: **Local-First Layered Architecture**.

### 1. Local-First Choice
The application stores all data locally on the user device without any remote server, backend API, or cloud infrastructure dependency. The app initializes with curated seed listings if no local data exists and functions 100% offline.

### 2. Storage Boundary
Local persistence uses `shared_preferences` under the key `"streetswap_listings_v1"`, hidden behind the abstract `ListingRepository` interface in `lib/data/listing_repository.dart`.
- The implementation `SharedPrefsListingRepository` handles JSON serialization (`toJson`/`fromJson`) and deserialization.
- UI widgets and screens interact exclusively with the `ListingRepository` abstraction, keeping storage mechanisms decoupled from user interface code.

### 3. Isolated Product Logic
Business rules for listing status transitions are completely isolated in `lib/logic/status_rules.dart`:
- `ListingStatus.open` -> `ListingStatus.saved`, `ListingStatus.contacted`, `ListingStatus.closed`
- `ListingStatus.saved` / `ListingStatus.contacted` -> `ListingStatus.closed`
- `ListingStatus.closed` -> `[]` (Terminal state)
No status transition logic is hardcoded inside UI widgets.

### 4. AI Boundary Isolation
Smart listing suggestions are encapsulated behind the abstract `LocalAiService` interface in `lib/services/local_ai_service.dart`.
- The concrete `RuleBasedAiService` implementation in `lib/services/rule_based_ai_service.dart` provides deterministic keyword-based category classification and fallback description generation.
- Executes synchronously on-device with zero network requests or API keys.

## Future Change Points & Swap Instructions

### Swapping Local Storage for a Real Database
To transition from `shared_preferences` to SQLite, Hive, or a sync engine (e.g. ElectricSQL / PowerSync):
1. Create a new class implementing `ListingRepository` (e.g., `SqliteListingRepository implements ListingRepository`).
2. Implement `getAll()`, `create()`, `updateStatus()`, `remove()`, and `clearAll()`.
3. Swap the instantiation in screens or introduce dependency injection. Zero UI widget code needs modification.

### Swapping Local AI for a Real LLM
To transition from `RuleBasedAiService` to an on-device LLM (e.g. MediaPipe LLM Inference / Gemma Nano) or remote API:
1. Create a class implementing `LocalAiService` (e.g. `OnDeviceLlmAiService implements LocalAiService`).
2. Implement `suggestListingDetails(String title, String rawDescription)`.
3. Replace `_aiService` in `CreateScreen`. The UI form contract (`AiSuggestion`) remains identical.
