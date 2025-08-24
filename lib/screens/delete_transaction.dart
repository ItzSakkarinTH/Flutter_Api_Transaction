import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/navigation_helper.dart';

class DeleteTransactionScreen extends StatefulWidget {
  const DeleteTransactionScreen({super.key});

  @override
  State<DeleteTransactionScreen> createState() => _DeleteTransactionScreenState();
}

class _DeleteTransactionScreenState extends State<DeleteTransactionScreen> {
  final _transactionIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }

  Future<void> _deleteTransaction() async {
    if (_transactionIdController.text.trim().isEmpty) {
      NavigationHelper.showErrorSnackBar('กรุณาใส่ ID ของธุรกรรม');
      return;
    }

    // แสดง Dialog ยืนยันการลบ
    final confirmed = await NavigationHelper.showConfirmDialog(
      title: 'ยืนยันการลบ',
      message: 'คุณต้องการลบธุรกรรม ID: ${_transactionIdController.text} หรือไม่?\n\nการลบนี้ไม่สามารถยกเลิกได้',
      confirmText: 'ตกลง',
      cancelText: 'ยกเลิก',
      confirmColor: Colors.red,
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: เรียก API ลบธุรกรรม
      await Future.delayed(const Duration(seconds: 2)); // จำลองการเรียก API
      
      NavigationHelper.showSuccessSnackBar('ลบธุรกรรมสำเร็จ');
      _transactionIdController.clear();
    } catch (e) {
      NavigationHelper.showErrorSnackBar('เกิดข้อผิดพลาดในการลบธุรกรรม');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลบธุรกรรม'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.delete_forever,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'ลบธุรกรรม',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'กรุณาใส่ ID ของธุรกรรมที่ต้องการลบ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _transactionIdController,
              decoration: const InputDecoration(
                labelText: 'Transaction ID',
                hintText: 'ใส่ ID ของธุรกรรม',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'คำเตือน: การลบธุรกรรมไม่สามารถยกเลิกได้',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _deleteTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'ลบธุรกรรม',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}