# Accessibility Audit & Compliance Report

StreetSwap has been hardened to comply with mobile accessibility guidelines (WCAG 2.1 AA alignment).

## Accessibility Standards Audit

### 1. Clear Labels & Control Identification
- Every tappable UI element (icon buttons, floating action buttons, cards, list tiles) is wrapped in a `Semantics` widget with `button: true` or provided with an explicit `tooltip`.
- **Screen Reader Support**:
  - Settings Button: `Semantics(label: 'Settings', button: true)`
  - Add Listing FAB: `Semantics(label: 'Add listing', button: true)`
  - Quick Save Bookmark: `Semantics(label: 'Save listing', button: true)`
  - Create Listing Submit: `Semantics(label: 'Create listing', button: true)`
  - Status Transition Buttons: `Semantics(label: 'Mark listing as ${status.name}', button: true)`

### 2. Comprehensive Card Semantics
`ListingCard` constructs a complete, natural language sentence for screen reader announcements:
```dart
final semanticLabel =
    '${listing.title}, category ${listing.category.name} in ${listing.area}. Status: ${listing.status.name}.';
```
When focused by VoiceOver or TalkBack, the screen reader reads the full listing title, category, neighborhood, and status in one coherent sentence.

### 3. Visible Form Error Messages
Form validation failures on `CreateScreen` produce visible bold red text messages directly below input fields using `InputDecoration.errorStyle`:
```dart
errorStyle: TextStyle(
  color: Colors.red.shade700,
  fontSize: 13,
  fontWeight: FontWeight.bold,
),
errorMaxLines: 2,
```
Validation errors are not indicated by border colors alone, satisfying color-blindness accessibility standards.

### 4. Touch Target Sizing (Min 48x48 Logical Pixels)
All interactive controls meet or exceed the minimum 48x48 logical pixel touch target size:
- `IconButton` instances specify `constraints: BoxConstraints(minWidth: 48, minHeight: 48)`.
- Action buttons specify `minimumSize: const Size(48, 48)` or height `52`.
- `ListingCard` touch target area spans the full card height (> 70 logical pixels).

### 5. Dynamic Text Scaling Overflow Protection
- `CreateScreen` and `DetailsScreen` wrap form content inside `SingleChildScrollView` containers.
- When users increase system font scaling up to 250%+ (e.g. `MediaQueryData.textScaler`), input fields, buttons, and helper labels expand gracefully and scroll without vertical clipping or overflow errors.
