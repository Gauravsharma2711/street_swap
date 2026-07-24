import 'package:flutter/material.dart';

import '../data/shared_prefs_listing_repository.dart';
import '../models/listing.dart';
import '../widgets/listing_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final SharedPrefsListingRepository _repository =
      SharedPrefsListingRepository();
  late Future<List<Listing>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = _repository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreetSwap'),
      ),
      body: FutureBuilder<List<Listing>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong loading listings.'),
            );
          }

          final listings = snapshot.data;
          if (listings == null || listings.isEmpty) {
            return const Center(
              child: Text('No listings yet — create the first one.'),
            );
          }

          return ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              return ListingCard(listing: listings[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add listing',
        child: const Icon(Icons.add),
      ),
    );
  }
}
