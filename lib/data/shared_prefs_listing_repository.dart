import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/listing.dart';
import 'listing_repository.dart';
import 'seed_data.dart';

class SharedPrefsListingRepository implements ListingRepository {
  static const String _storageKey = 'streetswap_listings_v1';
  final SharedPreferences? _prefs;

  SharedPrefsListingRepository([this._prefs]);

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<List<Listing>> getAll() async {
    final prefs = await _instance;
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      final seedListings = getSeedListings();
      await _saveListings(prefs, seedListings);
      return seedListings;
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => Listing.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <Listing>[];
    }
  }

  @override
  Future<void> create(Listing input) async {
    final listings = await getAll();
    listings.add(input);
    final prefs = await _instance;
    await _saveListings(prefs, listings);
  }

  @override
  Future<void> updateStatus(String id, ListingStatus status) async {
    final listings = await getAll();
    final index = listings.indexWhere((l) => l.id == id);
    if (index != -1) {
      final existing = listings[index];
      listings[index] = Listing(
        id: existing.id,
        title: existing.title,
        category: existing.category,
        description: existing.description,
        area: existing.area,
        contactPreference: existing.contactPreference,
        status: status,
        createdAt: existing.createdAt,
      );
      final prefs = await _instance;
      await _saveListings(prefs, listings);
    }
  }

  @override
  Future<void> remove(String id) async {
    final listings = await getAll();
    listings.removeWhere((l) => l.id == id);
    final prefs = await _instance;
    await _saveListings(prefs, listings);
  }

  @override
  Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.remove(_storageKey);
  }

  Future<void> _saveListings(
      SharedPreferences prefs, List<Listing> listings) async {
    final jsonString =
        jsonEncode(listings.map((l) => l.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
