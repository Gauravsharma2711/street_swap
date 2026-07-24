enum Category { tools, books, services, free }

enum ListingStatus { open, saved, contacted, closed }

enum ContactPreference { chatOnly, call, either }

class Listing {
  final String id;
  final String title;
  final Category category;
  final String description;
  final String area;
  final ContactPreference contactPreference;
  final ListingStatus status;
  final DateTime createdAt;

  const Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.area,
    required this.contactPreference,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'description': description,
      'area': area,
      'contactPreference': contactPreference.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      title: json['title'] as String,
      category: Category.values.byName(json['category'] as String),
      description: json['description'] as String,
      area: json['area'] as String,
      contactPreference:
          ContactPreference.values.byName(json['contactPreference'] as String),
      status: ListingStatus.values.byName(json['status'] as String),
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
    );
  }
}
