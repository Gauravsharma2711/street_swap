// ignore: unused_import
import 'listing.dart';

List<String> validateNewListing({
  required String title,
  required String description,
  required String area,
}) {
  final errors = <String>[];

  if (title.trim().isEmpty) {
    errors.add('Title cannot be empty');
  } else if (title.trim().length > 60) {
    errors.add('Title must be under 60 characters');
  }

  if (description.length > 500) {
    errors.add('Description must be under 500 characters');
  }

  if (area.trim().isEmpty) {
    errors.add('Area cannot be empty');
  } else if (RegExp(r'\d').hasMatch(area)) {
    errors.add('Please use a general area, not a street number');
  }

  return errors;
}
