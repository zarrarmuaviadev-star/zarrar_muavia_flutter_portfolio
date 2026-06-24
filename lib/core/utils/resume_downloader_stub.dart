import 'package:flutter/services.dart';

/// Non-web fallback: opens resume asset via platform channel behavior.
Future<void> downloadResume(String assetPath, String fileName) async {
  await rootBundle.load(assetPath);
}
