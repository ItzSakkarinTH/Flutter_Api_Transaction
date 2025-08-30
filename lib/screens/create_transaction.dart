import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validate/components/drawer.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../routes/app_routes.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  // เพิ่มตัวแปรสำหรับ controller
  final TransactionController transactionController = Get.put(
    TransactionController(),
  );

  int? _selectedType; // null = ยังไม่ได้เลือก, -1 = รายจ่าย, 1 = รายรับ
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTransaction() async {
    // เพิ่ม async
    if (_formKey.currentState!.validate()) {
      // ตรวจสอบว่าเลือกประเภทแล้วหรือยัง
      if (_selectedType == null) {
        Get.snackbar(
          'ข้อผิดพลาด',
          'กรุณาเลือกประเภทรายการ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // สร้าง transaction object
      final transaction = {
        "name": _nameController.text.trim(),
        "desc": _descController.text.trim(),
        "amount": double.parse(_amountController.text),
        "type": _selectedType,
        "date": _selectedDate.toString().split(' ')[0], // format: YYYY-MM-DD
      };

      // แสดง transaction ที่สร้าง (สำหรับ debug)
      print('Created Transaction: $transaction');

      // ส่งข้อมูลไป API
      final success = await transactionController.createTransaction(
        name: _nameController.text.trim(),
        desc: _descController.text.trim(),
        amount: double.parse(_amountController.text),
        type: _selectedType!,
        date: _selectedDate,
      );

      if (success) {
        // แสดง success message

        Get.snackbar(
          '✅ สำเร็จ',
          'บันทึกรายการเรียบร้อยแล้ว ขอบคุณที่ใช้งาน!',
          backgroundColor: Colors.white,
          colorText: Colors.blue[800],
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          borderRadius: 15,
          margin: const EdgeInsets.all(20),
        );

        // รีเซ็ตฟอร์ม
        _formKey.currentState!.reset();
        _nameController.clear();
        _descController.clear();
        _amountController.clear();
        setState(() {
          _selectedType = null;
          _selectedDate = DateTime.now();
        });

        // รอให้ snackbar แสดงก่อน แล้วค่อยกลับ
        Future.delayed(Duration(seconds: 2), () {
          Get.back();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการ'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Obx(
          () => SingleChildScrollView(
            // เพิ่ม Obx เพื่อ observe loading state
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card สำหรับเลือกประเภท
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ประเภทรายการ *',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedType = -1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedType == -1
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.grey[200],
                                      border: Border.all(
                                        color: _selectedType == -1
                                            ? Colors.red
                                            : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.remove_circle,
                                          color: _selectedType == -1
                                              ? Colors.red
                                              : Colors.grey[600],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'รายจ่าย',
                                          style: TextStyle(
                                            color: _selectedType == -1
                                                ? Colors.red
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedType = 1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _selectedType == 1
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.grey[200],
                                      border: Border.all(
                                        color: _selectedType == 1
                                            ? Colors.green
                                            : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle,
                                          color: _selectedType == 1
                                              ? Colors.green
                                              : Colors.grey[600],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'รายรับ',
                                          style: TextStyle(
                                            color: _selectedType == 1
                                                ? Colors.green
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Card สำหรับข้อมูลรายการ
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // ชื่อรายการ
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'ชื่อรายการ *',
                              hintText: 'เช่น ซื้อของ, เงินเดือน',
                              prefixIcon: Icon(Icons.receipt_long),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'กรุณากรอกชื่อรายการ';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          // รายละเอียด
                          TextFormField(
                            controller: _descController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'รายละเอียด',
                              hintText: 'อธิบายรายละเอียดเพิ่มเติม...',
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),

                          SizedBox(height: 16),

                          // จำนวนเงิน
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'จำนวนเงิน *',
                              hintText: '0.00',
                              prefixIcon: Icon(Icons.attach_money),
                              suffixText: 'บาท',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'กรุณากรอกจำนวนเงิน';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'กรุณากรอกจำนวนเงินที่ถูกต้อง';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          // วันที่
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[50],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'วันที่: ${_selectedDate.toString().split(' ')[0]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // ปุ่มบันทึก
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: transactionController.isBusy.value
                          ? null
                          : _submitTransaction, // ปิดปุ่มเมื่อ loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: transactionController.isBusy.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'บันทึกรายการ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // ปุ่มยกเลิก
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'ยกเลิก',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
