import 'package:flutter/material.dart';

import '../data/shared_prefs_listing_repository.dart';
import '../logic/status_rules.dart';
import '../models/listing.dart';
import '../theme.dart';

class DetailsScreen extends StatefulWidget {
  final Listing listing;

  const DetailsScreen({
    super.key,
    required this.listing,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final SharedPrefsListingRepository _repository =
      SharedPrefsListingRepository();
  late Listing _listing;

  @override
  void initState() {
    super.initState();
    _listing = widget.listing;
  }

  Future<void> _updateStatus(ListingStatus newStatus) async {
    try {
      await _repository.updateStatus(_listing.id, newStatus);
      setState(() {
        _listing = Listing(
          id: _listing.id,
          title: _listing.title,
          category: _listing.category,
          description: _listing.description,
          area: _listing.area,
          contactPreference: _listing.contactPreference,
          status: newStatus,
          createdAt: _listing.createdAt,
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final validStatuses = nextValidStatuses(_listing.status);

    return Scaffold(
      backgroundColor: mongoBg,
      appBar: AppBar(
        title: Text(_listing.title),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Hero(
        tag: _listing.id,
        child: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listing.title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: mongoDarkSlate,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.category_outlined,
                      size: 18,
                      color: mongoMutedSlate,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _listing.category.name,
                      style: const TextStyle(
                        color: mongoMutedSlate,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: mongoMutedSlate,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _listing.area,
                      style: const TextStyle(
                        color: mongoMutedSlate,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: mongoDarkGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Status: ${_listing.status.name.toUpperCase()}',
                    style: const TextStyle(
                      color: mongoDarkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: mongoBorder),
                const SizedBox(height: 16),
                _buildInfoTile(
                  'CONTACT PREFERENCE',
                  _listing.contactPreference.name,
                ),
                const SizedBox(height: 16),
                _buildInfoTile(
                  'CREATED AT',
                  _listing.createdAt.toLocal().toString().split('.')[0],
                ),
                const SizedBox(height: 24),
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: mongoMutedSlate,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _listing.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: mongoDarkSlate,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                if (validStatuses.isNotEmpty) ...[
                  const Text(
                    'ACTIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: mongoMutedSlate,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...validStatuses.map((status) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mongoDarkGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _updateStatus(status),
                          child: Text(
                            'MARK AS ${status.name.toUpperCase()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: mongoMutedSlate,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: mongoDarkSlate,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
