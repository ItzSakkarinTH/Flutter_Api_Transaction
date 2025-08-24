import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class TransactionService {
  static const String baseUrl = 'https://transactions-cs.vercel.app';
  final StorageService storage = StorageService();

  // Headers พื้นฐาน
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (storage.getToken() != null) 
      'Authorization': 'Bearer ${storage.getToken()}',
  };

  // สร้างรายการใหม่
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/transactions'),
        headers: headers,
        body: jsonEncode(transaction),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

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
      print('Service Error: $e');
      return {
        'success': false,
        'message': 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้'
      };
    }
  }

  // ดึงรายการทั้งหมด
  Future<Map<String, dynamic>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions'),
        headers: headers,
      );

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
      print('Error fetching transactions: $e');
      return {
        'success': false,
        'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ'
      };
    }
  }

  // ลบรายการ
  Future<Map<String, dynamic>> deleteTransaction(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/transactions/$id'),
        headers: headers,
      );

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
      print('Error deleting transaction: $e');
      return {
        'success': false,
        'message': 'เกิดข้อผิดพลาดในการลบ'
      };
    }
  }

  // อัพเดทรายการ
  Future<Map<String, dynamic>> updateTransaction(String id, Map<String, dynamic> transaction) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/transactions/$id'),
        headers: headers,
        body: jsonEncode(transaction),
      );

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
      print('Error updating transaction: $e');
      return {
        'success': false,
        'message': 'เกิดข้อผิดพลาดในการอัพเดท'
      };
    }
  }
}
