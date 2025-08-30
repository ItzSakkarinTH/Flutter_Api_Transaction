import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/storage_service.dart';
import '../services/transaction_service.dart';

class DebugInfoScreen extends StatefulWidget {
  const DebugInfoScreen({super.key});

  @override
  State<DebugInfoScreen> createState() => _DebugInfoScreenState();
}

class _DebugInfoScreenState extends State<DebugInfoScreen> {
  final AuthController authController = Get.find<AuthController>();
  final StorageService storageService = Get.find<StorageService>();
  
  String? token;
  Map<String, dynamic>? userInfo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  void _loadDebugInfo() {
    setState(() {
      token = storageService.getToken();
      userInfo = authController.currentUser?.toJson();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('คัดลอกแล้ว', 'ข้อมูลถูกคัดลอกไปยังคลิปบอร์ด');
  }

  Future<void> _testApiConnection() async {
    setState(() {
      isLoading = true;
    });

    try {
      final transactionService = TransactionService();
      final result = await transactionService.getTransactions();
      Get.snackbar(
        'ผลการทดสอบ API',
        result['success'] ? 'เชื่อมต่อสำเร็จ' : 'เชื่อมต่อไม่สำเร็จ: ${result['message']}',
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถทดสอบ API ได้: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Information'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Token Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Token Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Token Status: ${token != null ? "มี Token" : "ไม่มี Token"}',
                      style: TextStyle(
                        color: token != null ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (token != null) ...[
                      const SizedBox(height: 8),
                      const Text('Token:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              token!.length > 50 
                                ? '${token!.substring(0, 50)}...' 
                                : token!,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _copyToClipboard(token!),
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('คัดลอก Token'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text(
                          'User Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (userInfo != null) ...[
                      ...userInfo!.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('${entry.key}: ${entry.value}'),
                      )),
                    ] else
                      const Text('ไม่มีข้อมูลผู้ใช้', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // API Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.api, color: Colors.purple),
                        const SizedBox(width: 8),
                        const Text(
                          'API Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Base URL: https://transactions-cs.vercel.app'),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _testApiConnection,
                      icon: isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.wifi_tethering, size: 16),
                      label: Text(isLoading ? 'กำลังทดสอบ...' : 'ทดสอบการเชื่อมต่อ API'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.build, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text(
                          'Debug Actions',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _loadDebugInfo();
                              Get.snackbar('รีเฟรช', 'ข้อมูลถูกรีเฟรชแล้ว');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('รีเฟรช'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              authController.logout();
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('ออกจากระบบ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}