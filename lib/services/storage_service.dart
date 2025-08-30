import 'dart:async';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  static const String _boxName = 'app_storage';

  Box? _box; // ✅ เปลี่ยนจาก late เป็น nullable ป้องกัน LateInitializationError
  final Completer<void> _ready = Completer<void>();

  Future<StorageService> init() async {
    // ป้องกัน init ซ้ำ และ race condition
    if (!_ready.isCompleted) {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      _ready.complete();
    }
    return this;
  }

  /// เรียกจุดไหนก็ได้ถ้าต้องการ "แน่ใจ" ว่าเปิดกล่องเสร็จแล้ว
  Future<void> ready() => _ready.future;

  /// ---------- Utilities ----------
  Box get _requireBox {
    final b = _box;
    if (b == null || !b.isOpen) {
      throw StateError('StorageService not ready: box is not opened yet.');
    }
    return b;
  }

  String? getToken() {
    return _requireBox.get('token') as String?;
  }

  Future<void> setToken(String? token) async {
    if (token == null) {
      await _requireBox.delete('token');
    } else {
      await _requireBox.put('token', token);
    }
  }

  // Alias methods for compatibility
  Future<void> saveToken(String token) async {
    await setToken(token);
  }

  Future<void> deleteToken() async {
    await _requireBox.delete('token');
  }

  bool hasToken() {
    return _requireBox.containsKey('token');
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _requireBox.put('user', userData);
  }

  Map<String, dynamic>? getUser() {
    return _requireBox.get('user') as Map<String, dynamic>?;
  }

  Future<void> deleteUser() async {
    await _requireBox.delete('user');
  }
}