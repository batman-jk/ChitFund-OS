// lib/services/storage_service.dart
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _boxName = 'settings';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<void> saveLanguage(String lang) async {
    final box = Hive.box(_boxName);
    await box.put('language', lang);
  }

  static Future<String?> getLanguage() async {
    final box = Hive.box(_boxName);
    return box.get('language');
  }
}
