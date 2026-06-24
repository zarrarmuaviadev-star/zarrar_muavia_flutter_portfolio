import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    try {
      await GoogleFonts.pendingFonts([
        GoogleFonts.inter(),
        GoogleFonts.jetBrainsMono(),
        GoogleFonts.lora(),
        GoogleFonts.playfairDisplay(),
      ]);
    } catch (_) {
      GoogleFonts.config.allowRuntimeFetching = false;
    }
  }

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammad Zarrar Muavia | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
