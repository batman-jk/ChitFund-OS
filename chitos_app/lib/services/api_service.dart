// lib/services/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  static final _dio = Dio(BaseOptions(
    // For Android Emulator, use 10.0.2.2. For iOS/Web, use localhost.
    baseUrl: 'http://10.0.2.2:5000', 
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  // ── AUTH / OTP ──────────────────────────────────────────
  static Future<Map<String, dynamic>> sendOTP(String phone) async {
    final res = await _dio.post('/api/v1/auth/send-otp', data: {'phone': phone});
    return res.data;
  }

  static Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    final res = await _dio.post('/api/v1/auth/verify-otp', data: {
      'phone': phone, 'otp': otp,
    });
    return res.data;
  }

  // ── GROUP INFO (for join page) ──────────────────────────
  static Future<Map<String, dynamic>> getGroupInfo(String groupId) async {
    final res = await _dio.get('/api/v1/groups/$groupId'); // Updated to match current backend
    return res.data;
  }

  // ── MEMBER JOIN ─────────────────────────────────────────
  static Future<Map<String, dynamic>> joinGroup({
    required String name,
    required String phone,
    required String groupId,
    required String authUserId,
  }) async {
    final res = await _dio.post('/api/member/join', data: {
      'name': name, 'phone': phone,
      'group_id': groupId, 'auth_user_id': authUserId,
    });
    return res.data;
  }

  // ── RECORD PAYMENT ──────────────────────────────────────
  static Future<Map<String, dynamic>> recordPayment({
    required String memberId,
    required String groupId,
    required int amount,
    required String method,
    required String foremanId,
  }) async {
    final res = await _dio.post('/api/payment/record', data: {
      'member_id': memberId, 'group_id': groupId,
      'amount': amount, 'method': method, 'foreman_id': foremanId,
    });
    return res.data;
  }

  // ── SEND REMINDER ───────────────────────────────────────
  static Future<void> sendReminder(String memberId, String groupId) async {
    await _dio.post('/api/reminder/payment', data: {
      'member_id': memberId, 'group_id': groupId,
    });
  }

  // ── SEND GROUP REMINDER ─────────────────────────────────
  static Future<Map<String, dynamic>> sendGroupReminder(
    String groupId, String foremanId) async {
    final res = await _dio.post('/api/reminder/group', data: {
      'group_id': groupId, 'foreman_id': foremanId,
    });
    return res.data;
  }

  // ── CALCULATE AUCTION ───────────────────────────────────
  static Future<Map<String, dynamic>> calculateAuction(
    String groupId, int bidAmount) async {
    final res = await _dio.post('/api/auction/calculate', data: {
      'group_id': groupId, 'bid_amount': bidAmount,
    });
    return res.data;
  }

  // ── RECORD AUCTION ──────────────────────────────────────
  static Future<Map<String, dynamic>> recordAuction({
    required String groupId,
    required String winnerMemberId,
    required int bidAmount,
    required String foremanId,
  }) async {
    final res = await _dio.post('/api/auction/record', data: {
      'group_id': groupId, 'winner_member_id': winnerMemberId,
      'bid_amount': bidAmount, 'foreman_id': foremanId,
    });
    return res.data;
  }

  // ── MEMBER PORTAL ───────────────────────────────────────
  static Future<Map<String, dynamic>> getMemberPortal(String phone) async {
    final res = await _dio.get('/api/portal/$phone');
    return res.data;
  }
}
