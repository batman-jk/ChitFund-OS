// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_service.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Call this in main.dart before runApp()
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://kwkwgrybmkxuljfybmzz.supabase.co', // Updated from .env
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3a3dncnlibWt4dWxqZnlibXp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQwNzgzMTMsImV4cCI6MjA4OTY1NDMxM30.9L5bGwDsSNDauYURbcafdgXEXc8rrnSDHyarcxv-eAk',
    );
  }

  // Send OTP via our Express Backend (Twilio)
  static Future<void> sendOTP(String phone) async {
    try {
      await ApiService.sendOTP(phone);
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP via our Express Backend
  static Future<bool> verifyOTP(String phone, String otp) async {
    try {
      final res = await ApiService.verifyOTP(phone, otp);
      if (res['success'] == true) {
        // Here you would typically handle the Supabase session if needed
        // For now, we return success if the backend verified it
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static User? get currentUser => _supabase.auth.currentUser;
  static bool get isLoggedIn => currentUser != null;

  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
