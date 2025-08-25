import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class TransactionController extends GetxController {
  final TransactionService _transactionService = TransactionService();

  // Observable lists สำหรับเก็บรายการ
  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // สร้างรายการใหม่
  Future<bool> createTransaction(Map<String, dynamic> transaction) async {
    try {
      isLoading.value = true;

      final result = await _transactionService.createTransaction(transaction);

      if (result['success']) {
        // เพิ่มรายการใหม่เข้าไปใน list
        transactions.add(result['data']);
        return true;
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          result['message'] ?? 'ไม่สามารถบันทึกรายการได้',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error creating transaction: $e');
      Get.snackbar(
        'ข้อผิดพลาด',
        'เกิดข้อผิดพลาดในการเชื่อมต่อ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ดึงรายการทั้งหมด
  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final result = await _transactionService.getTransactions();

      if (result['success']) {
        transactions.assignAll(result['data']);
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ลบรายการ
  Future<bool> deleteTransaction(String id) async {
    try {
      isLoading.value = true;
      final result = await _transactionService.deleteTransaction(id);

      if (result['success']) {
        transactions.removeWhere((transaction) => transaction['id'] == id);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
