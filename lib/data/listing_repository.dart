import '../models/listing.dart';

abstract class ListingRepository {
  Future<List<Listing>> getAll();
  Future<void> create(Listing input);
  Future<void> updateStatus(String id, ListingStatus status);
  Future<void> remove(String id);
  Future<void> clearAll();
}
