import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';

class EditTransactionPage extends StatefulWidget {
  const EditTransactionPage({super.key});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final TransactionController transactionController = Get.find<TransactionController>();

  Map<String, dynamic>? transaction;
  int? _selectedType;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    transaction = Get.arguments as Map<String, dynamic>?;
    if (transaction != null) {
      _nameController.text = transaction!['name'] ?? '';
      _descController.text = transaction!['desc'] ?? '';
      _amountController.text = transaction!['amount'].toString();
      _selectedType = transaction!['type'];
      _selectedDate = DateTime.parse(transaction!['date']);
    }
  }

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
    if (_formKey.currentState!.validate()) {
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

      if (transaction != null && transaction!['uuid'] != null) {
        final success = await transactionController.updateTransaction(
          uuid: transaction!['uuid'],
          name: _nameController.text.trim(),
          desc: _descController.text.trim(),
          amount: double.parse(_amountController.text),
          type: _selectedType!,
          date: _selectedDate,
        );

        if (success) {
          Get.snackbar(
            'สำเร็จ',
            'แก้ไขรายการเรียบร้อย',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
        } else {
          Get.snackbar(
            'ข้อผิดพลาด',
            'ไม่สามารถแก้ไขรายการได้',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'ไม่พบข้อมูลรายการที่จะแก้ไข',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขรายการ'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Type Selection
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ประเภทรายการ *', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedType = -1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedType == -1 ? Colors.red.withOpacity(0.1) : Colors.grey[200],
                                  border: Border.all(
                                    color: _selectedType == -1 ? Colors.red : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.remove_circle, color: _selectedType == -1 ? Colors.red : Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text('รายจ่าย', style: TextStyle(
                                      color: _selectedType == -1 ? Colors.red : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedType = 1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedType == 1 ? Colors.green.withOpacity(0.1) : Colors.grey[200],
                                  border: Border.all(
                                    color: _selectedType == 1 ? Colors.green : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle, color: _selectedType == 1 ? Colors.green : Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text('รายรับ', style: TextStyle(
                                      color: _selectedType == 1 ? Colors.green : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    )),
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

              // Form Fields
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'ชื่อรายการ *',
                          prefixIcon: Icon(Icons.receipt_long),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอกชื่อรายการ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'รายละเอียด',
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'จำนวนเงิน *',
                          prefixIcon: Icon(Icons.attach_money),
                          suffixText: 'บาท',
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
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey[600]),
                              SizedBox(width: 12),
                              Text('วันที่: ${_selectedDate.toString().split(' ')[0]}'),
                              Spacer(),
                              Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Buttons
              Obx(() => Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: transactionController.isBusy.value ? null : () => Get.back(),
                      child: Text('ยกเลิก'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: transactionController.isBusy.value ? null : _submitTransaction,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: transactionController.isBusy.value
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text('บันทึก', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}