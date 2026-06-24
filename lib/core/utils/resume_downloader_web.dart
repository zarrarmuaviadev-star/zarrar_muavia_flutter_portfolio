// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';

/// Web-specific resume download using blob URL.
Future<void> downloadResume(String assetPath, String fileName) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}
