import 'package:flutter/material.dart';

import '../data/shared_prefs_listing_repository.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showClearDataDialog(BuildContext context) async {
    final repository = SharedPrefsListingRepository();

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Clear All Local Data',
            style:
                TextStyle(color: mongoDarkSlate, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to clear all stored listings? This action cannot be undone.',
            style: TextStyle(color: mongoMutedSlate),
          ),
          actions: [
            Semantics(
              label: 'Cancel dialog',
              button: true,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: mongoMutedSlate),
                ),
              ),
            ),
            Semantics(
              label: 'Clear all data',
              button: true,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(48, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  try {
                    await repository.clearAll();
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to clear data: $e')),
                      );
                    }
                  }
                },
                child: const Text('Clear'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mongoBg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Semantics(
                label: 'Clear all local data',
                button: true,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade700,
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(color: Colors.red.shade700, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showClearDataDialog(context),
                  child: const Text(
                    'CLEAR ALL LOCAL DATA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
