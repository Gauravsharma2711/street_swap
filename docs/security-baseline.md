# Security & Privacy Baseline Documentation

StreetSwap enforces strict security and privacy standards to protect user data, prevent location tracking, and ensure local storage safety.

## Security & Privacy Rules

### 1. Zero Hardcoded Secrets & Cloud Isolation
- **Repo Secret Scan**: The entire project codebase (`lib/`, `docs/`, configuration) contains zero hardcoded API keys, tokens, credentials, or private URLs.
- **No Cloud Endpoints**: The app communicates with zero remote servers or telemetry tracking tools.

### 2. Location Privacy (Exact Address Protection)
To prevent users from accidentally exposing private residential addresses in public community listings:
- **Input Guidance**: The Area field in `CreateScreen` displays `labelText: 'Neighborhood or area'` and explicit `helperText: 'Do not enter your exact home address'`.
- **Digit Validation Check**: Both `validateNewListing` in `lib/models/validation.dart` and `CreateScreen` enforce a regex check rejecting strings containing numbers (`RegExp(r'\d')`).
- **Validation Message**: Entering house or street numbers (e.g. *"123 Main St"*) triggers the error: `"Please use a general area, not a street number"`.

### 3. Strict Input Validation
`validateNewListing` in `lib/models/validation.dart` enforces input constraints across all creation paths:
- **Title**: Required non-empty string, maximum 60 characters.
- **Description**: Optional text, maximum 500 characters.
- **Area**: Required non-empty string, no digits/numbers allowed.
- **Category & Contact Preference**: Must select valid enum options (`Category`, `ContactPreference`).

### 4. Protected Local Data Reset / Deletion
- Users can wipe local storage from `SettingsScreen` ("CLEAR ALL LOCAL DATA").
- To prevent accidental deletion, the operation is protected by a modal `AlertDialog` confirmation requiring explicit `Clear` action while offering a `Cancel` fallback.
