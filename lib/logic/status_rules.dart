import '../models/listing.dart';

List<ListingStatus> nextValidStatuses(ListingStatus current) {
  switch (current) {
    case ListingStatus.open:
      return [
        ListingStatus.saved,
        ListingStatus.contacted,
        ListingStatus.closed,
      ];
    case ListingStatus.saved:
    case ListingStatus.contacted:
      return [
        ListingStatus.closed,
      ];
    case ListingStatus.closed:
      return [];
  }
}
