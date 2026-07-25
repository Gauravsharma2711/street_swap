import 'package:flutter/material.dart';

import '../data/shared_prefs_listing_repository.dart';
import '../models/listing.dart';
import '../services/rule_based_ai_service.dart';
import '../theme.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _areaController = TextEditingController();

  Category? _selectedCategory;
  ContactPreference? _selectedContactPreference;
  bool _isSuggesting = false;

  // OFFLINE VERIFICATION: RuleBasedAiService works 100% locally on-device without network/cloud dependencies.
  // To test offline AI behavior: enable Airplane Mode (or disable Wi-Fi/cellular data on Android emulator/device),
  // enter a title (e.g. "Calculus Study Guide") and tap "Suggest details" to verify category suggestion and description generation.
  final RuleBasedAiService _aiService = RuleBasedAiService();
  final SharedPrefsListingRepository _repository =
      SharedPrefsListingRepository();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _handleSuggestDetails() async {
    setState(() {
      _isSuggesting = true;
    });

    final suggestion = await _aiService.suggestListingDetails(
      _titleController.text,
      _descriptionController.text,
    );

    if (mounted) {
      setState(() {
        _descriptionController.text = suggestion.improvedDescription;
        _selectedCategory = suggestion.suggestedCategory;
        _isSuggesting = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newListing = Listing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        area: _areaController.text.trim(),
        contactPreference: _selectedContactPreference!,
        status: ListingStatus.open,
        createdAt: DateTime.now(),
      );

      await _repository.create(newListing);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText, {String? helperText}) {
    return InputDecoration(
      labelText: labelText,
      helperText: helperText,
      helperStyle: const TextStyle(color: mongoMutedSlate),
      labelStyle: const TextStyle(color: mongoMutedSlate),
      errorStyle: TextStyle(
        color: Colors.red.shade700,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      errorMaxLines: 2,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: mongoBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: mongoBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: mongoDarkGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mongoBg,
      appBar: AppBar(
        title: const Text('New Listing'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration('Title'),
                style: const TextStyle(color: mongoDarkSlate),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  if (value.trim().length > 60) {
                    return 'Title must be under 60 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _buildInputDecoration('Description'),
                style: const TextStyle(color: mongoDarkSlate),
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'Description must be under 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Semantics(
                  label: 'Suggest details with AI',
                  button: true,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: mongoDarkGreen,
                      minimumSize: const Size(48, 48),
                      side: const BorderSide(color: mongoDarkGreen, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isSuggesting ? null : _handleSuggestDetails,
                    icon: _isSuggesting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: mongoDarkGreen,
                            ),
                          )
                        : const Text('✨'),
                    label: Text(
                      _isSuggesting ? 'Generating...' : 'Suggest details',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: _buildInputDecoration(
                  'Neighborhood or area',
                  helperText: 'Do not enter your exact home address',
                ),
                style: const TextStyle(color: mongoDarkSlate),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Area cannot be empty';
                  }
                  if (RegExp(r'\d').hasMatch(value)) {
                    return 'Please use a general area, not a street number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                key: ValueKey(_selectedCategory),
                initialValue: _selectedCategory,
                decoration: _buildInputDecoration('Category'),
                dropdownColor: Colors.white,
                style: const TextStyle(color: mongoDarkSlate),
                items: Category.values.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ContactPreference>(
                initialValue: _selectedContactPreference,
                decoration: _buildInputDecoration('Contact Preference'),
                dropdownColor: Colors.white,
                style: const TextStyle(color: mongoDarkSlate),
                items: ContactPreference.values.map((pref) {
                  return DropdownMenuItem<ContactPreference>(
                    value: pref,
                    child: Text(pref.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedContactPreference = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a contact preference';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Semantics(
                  label: 'Create listing',
                  button: true,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mongoDarkGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'CREATE LISTING',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
