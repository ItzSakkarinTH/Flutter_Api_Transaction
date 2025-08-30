import 'dart:convert';
import 'package:get/get.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class TransactionController extends GetxController {
  final ApiClient _api = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  final isBusy = false.obs;
  final items = <Map<String, dynamic>>[].obs;

  // Alias getters for compatibility
  RxBool get isLoading => isBusy;
  RxList<Map<String, dynamic>> get transactions => items;

  @override
  Future<void> onReady() async {
    super.onReady();
    // ✅ บังคับให้รอ Storage พร้อมก่อนเสมอ
    await _storage.ready();
    // จากนั้นค่อยยิง API
    await fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isBusy.value = true;
    try {
      final res = await _api.get('/api/transaction');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        
        if (data is List) {
          items.assignAll(List<Map<String, dynamic>>.from(data));
        } else if (data is Map && data['data'] is List) {
          items.assignAll(List<Map<String, dynamic>>.from(data['data']));
        }
      }
    } on UnauthorizedException {
      // Handle unauthorized
    } catch (_) {
      // Handle other errors
    } finally {
      isBusy.value = false;
    }
  }

  Future<bool> createTransaction({
    required String name,
    required String desc,
    required double amount,
    required int type, // -1 expense, 1 income
    required DateTime date,
  }) async {
    isBusy.value = true;
    try {
      await _storage.ready(); // ✅ กันเคสกดปุ่มเร็วกว่า service พร้อม
      final payload = {
        'name': name,
        'desc': desc,
        'amount': amount,
        'type': type,
        'date': _dateStr(date),
      };

      final res = await _api.post('/api/transaction', body: payload);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // อัปเดตหน้ารายการ
        await fetchTransactions();
        return true;
      } else {
        // print('createTransaction error: ${res.statusCode} ${res.body}');
        return false;
      }
    } on UnauthorizedException {
      // Get.offAllNamed(Routes.LOGIN);
      return false;
    } catch (_) {
      return false;
    } finally {
      isBusy.value = false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    isBusy.value = true;
    try {
      await _storage.ready();
      final res = await _api.delete('/api/transaction/$id');

      if (res.statusCode == 200 || res.statusCode == 204) {
        await fetchTransactions();
        return true;
      } else {
        return false;
      }
    } on UnauthorizedException {
      return false;
    } catch (_) {
      return false;
    } finally {
      isBusy.value = false;
    }
  }

  Future<bool> updateTransaction({
    required String uuid,
    required String name,
    required String desc,
    required double amount,
    required int type,
    required DateTime date,
  }) async {
    isBusy.value = true;
    try {
      await _storage.ready();
      final payload = {
        'name': name,
        'desc': desc,
        'amount': amount,
        'type': type,
        'date': _dateStr(date),
      };

      final res = await _api.put('/api/transaction/$uuid', body: payload);

      if (res.statusCode == 200) {
        await fetchTransactions();
        return true;
      } else {
        return false;
      }
    } on UnauthorizedException {
      return false;
    } catch (_) {
      return false;
    } finally {
      isBusy.value = false;
    }
  }

  String _dateStr(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}