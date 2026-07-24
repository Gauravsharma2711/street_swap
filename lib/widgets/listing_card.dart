import 'package:flutter/material.dart';

import '../data/shared_prefs_listing_repository.dart';
import '../models/listing.dart';
import '../theme.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onSelect;
  final VoidCallback? onDismissedCallback;

  const ListingCard({
    super.key,
    required this.listing,
    this.onSelect,
    this.onDismissedCallback,
  });

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.tools:
        return Icons.build_outlined;
      case Category.books:
        return Icons.menu_book_outlined;
      case Category.services:
        return Icons.handyman_outlined;
      case Category.free:
        return Icons.card_giftcard_outlined;
    }
  }

  (Color bg, Color fg) _getStatusColors(ListingStatus status) {
    switch (status) {
      case ListingStatus.open:
        return (const Color(0xFFE6F4EA), mongoDarkGreen);
      case ListingStatus.saved:
        return (const Color(0xFFFEF7E0), Colors.amber.shade900);
      case ListingStatus.contacted:
        return (const Color(0xFFE8F0FE), Colors.blue.shade900);
      case ListingStatus.closed:
        return (const Color(0xFFF1F3F4), const Color(0xFF5C6E76));
    }
  }

  @override
  Widget build(BuildContext context) {
    final semanticLabel =
        '${listing.title}, ${listing.category.name} in ${listing.area}. Status: ${listing.status.name}.';

    final (statusBg, statusFg) = _getStatusColors(listing.status);

    return Dismissible(
      key: ValueKey(listing.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) async {
        final repo = SharedPrefsListingRepository();
        await repo.remove(listing.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Listing deleted'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        onDismissedCallback?.call();
      },
      child: Semantics(
        label: semanticLabel,
        child: GestureDetector(
          onTap: onSelect,
          child: Hero(
            tag: listing.id,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mongoBorder, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: mongoDarkGreen, width: 1.5),
                      ),
                      child: Icon(
                        _getCategoryIcon(listing.category),
                        color: mongoDarkGreen,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      listing.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mongoDarkSlate,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        listing.area,
                        style: const TextStyle(
                          color: mongoMutedSlate,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        listing.status.name,
                        style: TextStyle(
                          color: statusFg,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
