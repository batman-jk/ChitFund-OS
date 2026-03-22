// lib/main.dart
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/translations.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/language_select/language_select_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Supabase
  await AuthService.initialize();

  // Init local storage
  await StorageService.initialize();

  // Load saved language preference
  final savedLang = await StorageService.getLanguage();
  if (savedLang != null) T.setLanguage(savedLang);

  runApp(const ChitOSApp());
}

class ChitOSApp extends StatelessWidget {
  const ChitOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChitOS',
      debugShowCheckedModeBanner: false,
      theme: ChitOSTheme.light,
      // If logged in → go to dashboard
      // If not → go to language select → auth
      home: AuthService.isLoggedIn
          ? const DashboardScreen()
          : const LanguageSelectScreen(),
    );
  }
}
