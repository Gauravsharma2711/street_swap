import 'package:flutter/material.dart';

import '../data/shared_prefs_listing_repository.dart';
import '../models/listing.dart';
import '../theme.dart';
import '../widgets/listing_card.dart';
import 'create_screen.dart';
import 'details_screen.dart';
import 'settings_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final SharedPrefsListingRepository _repository =
      SharedPrefsListingRepository();
  late Future<List<Listing>> _listingsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _listingsFuture = _repository.getAll();
  }

  Future<void> _refreshListings() async {
    setState(() {
      _listingsFuture = _repository.getAll();
    });
  }

  Widget _buildHeaderCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: mongoBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mongoDarkGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horizontal_circle,
                color: mongoDarkGreen,
                size: 36,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'StreetSwap',
                    style: TextStyle(
                      color: mongoDarkSlate,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'A local-first, offline marketplace. Trade safely within your community without the cloud.',
                    style: TextStyle(
                      color: mongoMutedSlate,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Semantics(
        label: 'Search listings',
        child: TextField(
          style: const TextStyle(color: mongoDarkSlate),
          decoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Search listings by title...',
            prefixIcon: const Icon(Icons.search, color: mongoMutedSlate),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: mongoBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: mongoBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: mongoDarkGreen, width: 2),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreetSwap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              ).then((_) => _refreshListings());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Listing>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: mongoDarkGreen),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong loading listings.'),
            );
          }

          final allListings = snapshot.data ?? [];

          final filteredListings = _searchQuery.trim().isEmpty
              ? allListings
              : allListings
                  .where((l) => l.title
                      .toLowerCase()
                      .contains(_searchQuery.trim().toLowerCase()))
                  .toList();

          // Group by Category
          final Map<Category, List<Listing>> groupedingsings = {};
          for (final listing in filteredListings) {
            groupedingsings
                .putIfAbsent(listing.category, () => [])
                .add(listing);
          }

          final List<Widget> listChildren = [
            _buildHeaderCard(),
            _buildSearchBar(),
          ];

          if (allListings.isEmpty) {
            listChildren.add(
              Container(
                height: 250,
                alignment: Alignment.center,
                child: const Text('No listings yet — create the first one.'),
              ),
            );
          } else if (filteredListings.isEmpty) {
            listChildren.add(
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Text('No listings matching "$_searchQuery"'),
              ),
            );
          } else {
            for (final category in Category.values) {
              final categoryListings = groupedingsings[category];
              if (categoryListings != null && categoryListings.isNotEmpty) {
                listChildren.add(
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      category.name.toUpperCase(),
                      style: const TextStyle(
                        color: mongoDarkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );

                for (final listing in categoryListings) {
                  listChildren.add(
                    ListingCard(
                      listing: listing,
                      onSelect: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(listing: listing),
                          ),
                        ).then((_) => _refreshListings());
                      },
                      onDismissedCallback: () {
                        _refreshListings();
                      },
                    ),
                  );
                }
              }
            }
          }

          listChildren.add(const SizedBox(height: 80));

          return RefreshIndicator(
            color: mongoDarkGreen,
            onRefresh: _refreshListings,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: listChildren,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mongoDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateScreen(),
            ),
          ).then((_) => _refreshListings());
        },
        tooltip: 'Add listing',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
