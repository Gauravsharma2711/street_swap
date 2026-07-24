import 'package:flutter/material.dart';

import 'screens/feed_screen.dart';
import 'theme.dart';

void main() {
  runApp(const StreetSwapApp());
}

class StreetSwapApp extends StatelessWidget {
  const StreetSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreetSwap',
      theme: appTheme,
      home: const FeedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
