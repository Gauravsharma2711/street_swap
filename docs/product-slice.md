# StreetSwap - Product Slice & User Flow

StreetSwap is a local-first mobile marketplace designed to empower neighbors to share, trade, and request items and services within their local community.

## Core Product Loop

```
  ┌─────────────────┐       ┌──────────────────┐
  │   View Feed     │ ───>  │ Create Listing   │
  └─────────────────┘       └──────────────────┘
           │                         │
           │ Quick Save              │ Submit Form
           ▼                         ▼
  ┌─────────────────┐       ┌──────────────────┐
  │ Status: Saved   │ <───  │ View Details     │
  └─────────────────┘       └──────────────────┘
           │                         │
           │ Transition              │ Change Status
           ▼                         ▼
  ┌─────────────────┐       ┌──────────────────┐
  │Contacted / Closed│ <─── │ Mark as Closed   │
  └─────────────────┘       └──────────────────┘
```

### 1. View Listings Feed
- Users browse local listings grouped into four distinct categories:
  - 🛠️ **TOOLS** (Hardware, lawn mowers, drills)
  - 📚 **BOOKS** (Textbooks, novels, study guides)
  - 🧹 **SERVICES** (Repairs, dog sitting, cleaning)
  - 🎁 **FREE** (Giveaways, furniture, spare items)
- Search bar filters listings by title dynamically in real time.
- Pull-to-refresh updates feed data instantly from local storage.

### 2. Create Listing
Users tap the Floating Action Button (`+`) to open the creation screen:
- **Title**: Brief title (under 60 characters).
- **Category**: Selectable dropdown (`tools`, `books`, `services`, `free`).
- **Description**: Detailed description with optional AI assistance ("✨ Suggest details").
- **Area**: Neighborhood or general area (street numbers strictly blocked for privacy).
- **Contact Preference**: Choice of `chatOnly`, `call`, or `either`.

### 3. Quick Save from Feed
- Each listing card on the feed features a trailing **Quick Save** bookmark button (`Icons.bookmark_border`).
- Tapping the bookmark instantly updates the listing status to `saved` in local storage and refreshes the feed UI without navigating away.
- When saved, the button transitions to a filled bookmark (`Icons.bookmark`) and is disabled.

### 4. View Details & Status Lifecycle
Tapping any listing card opens the full detail view:
- Displays category, area, creation timestamp, contact preference, and full description.
- Action buttons allow users to transition listing status according to strict business logic rules:
  - `MARK AS SAVED`: Moves listing to saved state.
  - `MARK AS CONTACTED`: Marks that the poster has been contacted.
  - `MARK AS CLOSED`: Closes the listing when trade/transaction is complete.
