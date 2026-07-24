import 'package:flutter/material.dart';

import 'screens/feed_screen.dart';

void main() {
  runApp(const StreetSwapApp());
}

class StreetSwapApp extends StatelessWidget {
  const StreetSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreetSwap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const FeedScreen(),
    );
  }
}
