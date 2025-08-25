import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validate/components/drawer.dart';
import '../controllers/auth_controller.dart';
import '../controllers/transaction_controller.dart';
import '../services/storage_service.dart';
import '../routes/app_routes.dart';

class ShowAllTransactionPage extends StatefulWidget {
  const ShowAllTransactionPage({super.key});

  @override
  State<ShowAllTransactionPage> createState() => _ShowAllTransactionPageState();
}

class _ShowAllTransactionPageState extends State<ShowAllTransactionPage> {
  String _selectedFilter = 'all'; // all, income, expense
  String _sortBy = 'date'; // date, amount, name
  bool _isAscending = false;

  late TransactionController transactionController = Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    _initServicesAndLoadTransactions();
  }

  void _initServicesAndLoadTransactions() async {
    // StorageService ถูก init แล้วใน main.dart แล้ว
    
    // ตรวจสอบว่ามี TransactionController แล้วหรือไม่
    if (!Get.isRegistered<TransactionController>()) {
      transactionController = Get.put(TransactionController());
    } else {
      transactionController = Get.find<TransactionController>();
    }

    // โหลดข้อมูล transactions
    await _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    await transactionController.fetchTransactions();
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    List<Map<String, dynamic>> filtered = List.from(
      transactionController.items,
    );

    // Filter by type
    if (_selectedFilter == 'income') {
      filtered = filtered.where((t) => t['type'] == 1).toList();
    } else if (_selectedFilter == 'expense') {
      filtered = filtered.where((t) => t['type'] == -1).toList();
    }

    // Sort
    filtered.sort((a, b) {
      int result = 0;
      switch (_sortBy) {
        case 'date':
          result = DateTime.parse(
            a['date'],
          ).compareTo(DateTime.parse(b['date']));
          break;
        case 'amount':
          result = (a['amount'] as num).compareTo(b['amount'] as num);
          break;
        case 'name':
          result = a['name'].toString().compareTo(b['name'].toString());
          break;
      }
      return _isAscending ? result : -result;
    });

    return filtered;
  }

  double get _totalIncome {
    return transactionController.items
        .where((t) => t['type'] == 1)
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());
  }

  double get _totalExpense {
    return transactionController.items
        .where((t) => t['type'] == -1)
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());
  }

  double get _balance => _totalIncome - _totalExpense;

  String _formatCurrency(double amount) {
    return '฿${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'กรองและเรียงข้อมูล',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Filter Section
            Text(
              'กรองตามประเภท',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('ทั้งหมด', 'all'),
                _buildFilterChip('รายรับ', 'income'),
                _buildFilterChip('รายจ่าย', 'expense'),
              ],
            ),

            SizedBox(height: 20),

            // Sort Section
            Text('เรียงตาม', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildSortChip('วันที่', 'date'),
                _buildSortChip('จำนวนเงิน', 'amount'),
                _buildSortChip('ชื่อรายการ', 'name'),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Text('เรียงลำดับ: '),
                Switch(
                  value: _isAscending,
                  onChanged: (value) {
                    setState(() {
                      _isAscending = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                Text(_isAscending ? 'น้อยไปมาก' : 'มากไปน้อย'),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
      selectedColor: Colors.green.withOpacity(0.2),
      checkmarkColor: Colors.green,
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue[700]!, Colors.blue[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              'สรุปภาพรวม',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.green[300]),
                      Text('รายรับ', style: TextStyle(color: Colors.white70)),
                      Text(
                        _formatCurrency(_totalIncome),
                        style: TextStyle(
                          color: Colors.green[300],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.red[300]),
                      Text('รายจ่าย', style: TextStyle(color: Colors.white70)),
                      Text(
                        _formatCurrency(_totalExpense),
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                      Text('คงเหลือ', style: TextStyle(color: Colors.white70)),
                      Text(
                        _formatCurrency(_balance),
                        style: TextStyle(
                          color: _balance >= 0 ? Colors.white : Colors.red[300],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 1;
    final amount = (transaction['amount'] as num).toDouble();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isIncome ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            isIncome ? Icons.add_circle : Icons.remove_circle,
            color: isIncome ? Colors.green : Colors.red,
            size: 28,
          ),
        ),
        title: Text(
          transaction['name'] ?? 'ไม่มีชื่อ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((transaction['desc'] ?? '').isNotEmpty)
              Text(
                transaction['desc'] ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  _formatDate(transaction['date'] ?? DateTime.now().toString()),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${_formatCurrency(amount)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        onTap: () {
          _showTransactionDetail(transaction);
        },
      ),
    );
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('รายละเอียดรายการ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ชื่อรายการ:', transaction['name'] ?? '-'),
            _buildDetailRow(
              'รายละเอียด:',
              (transaction['desc'] ?? '').isEmpty ? '-' : transaction['desc'],
            ),
            _buildDetailRow(
              'ประเภท:',
              transaction['type'] == 1 ? 'รายรับ' : 'รายจ่าย',
            ),
            _buildDetailRow(
              'จำนวนเงิน:',
              _formatCurrency((transaction['amount'] as num).toDouble()),
            ),
            _buildDetailRow(
              'วันที่:',
              _formatDate(transaction['date'] ?? DateTime.now().toString()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.editTransaction, arguments: transaction);
            },
            child: Text('แก้ไข'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // แสดง confirmation dialog
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('ยืนยันการลบ'),
                  content: Text('คุณต้องการลบรายการนี้หรือไม่?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('ยกเลิก'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('ลบ', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                final transactionUuid = transaction['uuid'];
                
                if (transactionUuid != null) {
                  final success = await transactionController.deleteTransaction(
                    transactionUuid.toString(),
                  );
                  if (success) {
                    Get.snackbar(
                      'สำเร็จ',
                      'ลบรายการเรียบร้อย',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'ข้อผิดพลาด',
                      'ไม่สามารถลบรายการได้',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.snackbar(
                    'ข้อผิดพลาด',
                    'ไม่พบ UUID ของรายการ',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('รายการทั้งหมด'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadTransactions),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed('/create-transaction'),
          ),
        ],
      ),
      body: Obx(() {
        final filteredTransactions = _filteredTransactions;

        if (transactionController.isBusy.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _loadTransactions,
          child: Column(
            children: [
              // Summary Card
              _buildSummaryCard(),

              // Filter Info
              if (_selectedFilter != 'all' || _sortBy != 'date')
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info, size: 16, color: Colors.blue[700]),
                      SizedBox(width: 4),
                      Text(
                        'กรอง: ${_selectedFilter == 'all'
                            ? 'ทั้งหมด'
                            : _selectedFilter == 'income'
                            ? 'รายรับ'
                            : 'รายจ่าย'} | เรียง: ${_sortBy == 'date'
                            ? 'วันที่'
                            : _sortBy == 'amount'
                            ? 'จำนวนเงิน'
                            : 'ชื่อรายการ'}',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 8),

              // Transactions List
              Expanded(
                child: filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              transactionController.items.isEmpty
                                  ? 'ยังไม่มีรายการใดๆ'
                                  : 'ไม่มีรายการที่ตรงกับเงื่อนไข',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Get.toNamed('/create-transaction'),
                              icon: Icon(Icons.add),
                              label: Text('เพิ่มรายการใหม่'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          return _buildTransactionItem(
                            filteredTransactions[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed('/create-transaction');
          // รีเฟรชข้อมูลเมื่อกลับจากหน้าสร้างรายการใหม่
          _loadTransactions();
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
