// lib/screens/auth/auth_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../core/translations.dart';
import '../dashboard/dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;

  Future<void> _sendOTP() async {
    setState(() => _loading = true);
    try {
      await AuthService.sendOTP(_phoneController.text);
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(T.get('otp_sent'))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Try again.')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyOTP() async {
    setState(() => _loading = true);
    final success = await AuthService.verifyOTP(
      _phoneController.text,
      _otpController.text,
    );
    setState(() => _loading = false);

    if (success) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(T.get('nav_home'))),
      body: Padding(
        padding: const EdgeInsets: 24.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏦', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            Text(
              'ChitOS Mobile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),
            if (!_otpSent) ...[
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: T.get('whatsapp_number'),
                  prefixText: '+91 ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendOTP,
                  child: _loading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send OTP'),
                ),
              ),
            ] else ...[
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter 4-digit OTP',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verifyOTP,
                  child: _loading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify & Login'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _otpSent = false),
                child: const Text('Change Number'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
