import 'package:flutter/material.dart';

import '../models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;

  const ListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    final semanticLabel =
        '${listing.title}, ${listing.category.name} in ${listing.area}. Status: ${listing.status.name}.';

    return Semantics(
      label: semanticLabel,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          title: Text(
            listing.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${listing.category.name} • ${listing.area}'),
          trailing: Chip(
            label: Text(
              listing.status.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
