import 'dart:convert';
import 'package:get/get.dart';
import '../services/api_client.dart';

class TransactionService {
  final ApiClient _api = Get.find<ApiClient>();

  // สร้างรายการใหม่
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> transaction) async {
    try {
      final response = await _api.post('/api/transactions', body: transaction);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'บันทึกรายการสำเร็จ'
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'เกิดข้อผิดพลาดในการบันทึก'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้'
      };
    }
  }

  // ดึงรายการทั้งหมด
  Future<Map<String, dynamic>> getTransactions() async {
    try {
      final response = await _api.get('/api/transactions');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data is List ? data : [data]
        };
      } else {
        return {
          'success': false,
          'message': 'ไม่สามารถดึงข้อมูลได้'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ'
      };
    }
  }

  // ลบรายการ
  Future<Map<String, dynamic>> deleteTransaction(String id) async {
    try {
      final response = await _api.delete('/api/transactions/$id');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'ลบรายการสำเร็จ'
        };
      } else {
        return {
          'success': false,
          'message': 'ไม่สามารถลบรายการได้'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'เกิดข้อผิดพลาดในการลบ'
      };
    }
  }

  // อัพเดทรายการ
  Future<Map<String, dynamic>> updateTransaction(String id, Map<String, dynamic> transaction) async {
    try {
      final response = await _api.put('/api/transactions/$id', body: transaction);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'อัพเดทรายการสำเร็จ'
        };
      } else {
        return {
          'success': false,
          'message': 'ไม่สามารถอัพเดทรายการได้'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'เกิดข้อผิดพลาดในการอัพเดท'
      };
    }
  }
}
