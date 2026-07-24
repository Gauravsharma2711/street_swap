import '../models/listing.dart';

List<Listing> getSeedListings() {
  final now = DateTime.now();

  return [
    Listing(
      id: 'seed-1',
      title: 'DeWalt Cordless Drill with Battery',
      category: Category.tools,
      description:
          'Works great! 20V MAX cordless drill with extra battery and charger. Lightly used for home DIY.',
      area: 'Downtown',
      contactPreference: ContactPreference.either,
      status: ListingStatus.open,
      createdAt: now.subtract(const Duration(hours: 4)),
    ),
    Listing(
      id: 'seed-2',
      title: 'Calculus & Physics Textbooks (11th Ed)',
      category: Category.books,
      description:
          'Hardcover Stewart Calculus and University Physics. Minimal highlighting, great condition for students.',
      area: 'University Heights',
      contactPreference: ContactPreference.chatOnly,
      status: ListingStatus.open,
      createdAt: now.subtract(const Duration(hours: 12)),
    ),
    Listing(
      id: 'seed-3',
      title: 'High School Math & Physics Tutoring',
      category: Category.services,
      description:
          'Experienced tutor offering 1-on-1 sessions for AP Physics and Calculus. Available on weekends.',
      area: 'Westside',
      contactPreference: ContactPreference.call,
      status: ListingStatus.open,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Listing(
      id: 'seed-4',
      title: 'Standing LED Desk Lamp',
      category: Category.free,
      description:
          'Adjustable arm desk lamp with warm white LED bulb included. Moving out so giving away for free!',
      area: 'North Park',
      contactPreference: ContactPreference.chatOnly,
      status: ListingStatus.saved,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Listing(
      id: 'seed-5',
      title: 'Gas Powered Lawn Mower',
      category: Category.tools,
      description:
          'Self-propelled gas lawn mower. Starts on the first pull, recently serviced blade.',
      area: 'East Suburbs',
      contactPreference: ContactPreference.either,
      status: ListingStatus.contacted,
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    Listing(
      id: 'seed-6',
      title: 'Sci-Fi Hardcover Book Collection',
      category: Category.books,
      description:
          'Set of 5 classic sci-fi novels including Dune and Foundation. Good reading condition.',
      area: 'Old Town',
      contactPreference: ContactPreference.chatOnly,
      status: ListingStatus.closed,
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    Listing(
      id: 'seed-7',
      title: 'Bicycle Repair & Tune-Up Service',
      category: Category.services,
      description:
          'Local bike mechanic providing basic brake adjustments, chain lube, and gear tuning.',
      area: 'Riverfront',
      contactPreference: ContactPreference.call,
      status: ListingStatus.open,
      createdAt: now.subtract(const Duration(days: 6)),
    ),
  ];
}
