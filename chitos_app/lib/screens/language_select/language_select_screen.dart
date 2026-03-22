import 'package:flutter/material.dart';
import '../../core/translations.dart';
import '../../services/storage_service.dart';
import '../auth/auth_screen.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  void _selectLanguage(BuildContext context, String lang) async {
    T.setLanguage(lang);
    await StorageService.saveLanguage(lang);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏦', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text(
              'ChitOS',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select Language / భాష ఎంచుకోండి',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            _buildLangOption(context, 'te', 'తెలుగు', 'అన్నీ తెలుగు లో'),
            const SizedBox(height: 16),
            _buildLangOption(context, 'te-en', 'తెలుగు + English', 'Telugu words + English numbers'),
            const SizedBox(height: 16),
            _buildLangOption(context, 'en', 'English', 'Simple English'),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, String code, String name, String desc) {
    return InkWell(
      onTap: () => _selectLanguage(context, code),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
