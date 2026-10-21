import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';
import '../models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseController _controller = ExpenseController();
  final TextEditingController _searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  List<Expense> _expenses = [];
  double _totalAmount = 0.0;
  bool _isLoading = true;
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = [
    'Tất cả',
    'Ăn uống',
    'Đi lại',
    'Nhà ở',
    'Học tập',
    'Mua sắm',
    'Giải trí',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => _isLoading = true);
    final list = _selectedCategory == 'Tất cả'
        ? await _controller.fetchAllExpenses()
        : await _controller.filterByCategory(_selectedCategory);
    final total = await _controller.getTotalAmount();
    if (!mounted) return;
    setState(() {
      _expenses = list;
      _totalAmount = total;
      _isLoading = false;
    });
  }

  Future<void> _onSearch(String keyword) async {
    if (keyword.trim().isEmpty) {
      _loadExpenses();
      return;
    }
    final results = await _controller.searchExpenses(keyword.trim());
    if (!mounted) return;
    setState(() {
      _expenses = results;
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Đi lại':
        return Icons.directions_car;
      case 'Nhà ở':
        return Icons.home;
      case 'Học tập':
        return Icons.school;
      case 'Mua sắm':
        return Icons.shopping_bag;
      case 'Giải trí':
        return Icons.local_cafe;
      default:
        return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return Colors.orange;
      case 'Đi lại':
        return Colors.blue;
      case 'Nhà ở':
        return Colors.purple;
      case 'Học tập':
        return Colors.teal;
      case 'Mua sắm':
        return Colors.pink;
      case 'Giải trí':
        return Colors.amber.shade800;
      default:
        return Colors.indigo;
    }
  }

  // Dialog Thêm khoản chi tiêu mới
  void _showAddExpenseDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCat = 'Ăn uống';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: const Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Thêm Khoản Chi Tiêu',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nội dung chi tiêu (*)',
                          hintText: 'Ví dụ: Ăn trưa, Đổ xăng, Mua sách...',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Vui lòng nhập nội dung!' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Số tiền (VNĐ) (*)',
                          hintText: 'Ví dụ: 50000',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Vui lòng nhập số tiền!';
                          final numVal = double.tryParse(v.trim());
                          if (numVal == null || numVal <= 0) return 'Số tiền phải lớn hơn 0!';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCat,
                        decoration: const InputDecoration(
                          labelText: 'Danh mục',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: _categories
                            .where((c) => c != 'Tất cả')
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedCat = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú',
                          hintText: 'Thông tin bổ sung...',
                          prefixIcon: Icon(Icons.note_alt_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final dateStr =
                          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                      final newExp = Expense(
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text.trim()),
                        note: noteController.text.trim(),
                        date: dateStr,
                        category: selectedCat,
                      );
                      await _controller.insertExpense(newExp);
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                      if (!mounted) return;
                      _loadExpenses();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã thêm mục chi tiêu vào SQLite!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog Sửa khoản chi tiêu
  void _showEditExpenseDialog(Expense exp) {
    final titleController = TextEditingController(text: exp.title);
    final amountController =
        TextEditingController(text: exp.amount.toStringAsFixed(0));
    final noteController = TextEditingController(text: exp.note);
    String selectedCat = exp.category;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Sửa Chi Tiêu #${exp.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nội dung chi tiêu (*)',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Vui lòng nhập nội dung!' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Số tiền (VNĐ) (*)',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Vui lòng nhập số tiền!';
                          final numVal = double.tryParse(v.trim());
                          if (numVal == null || numVal <= 0) return 'Số tiền phải lớn hơn 0!';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _categories.contains(selectedCat) && selectedCat != 'Tất cả'
                            ? selectedCat
                            : 'Khác',
                        decoration: const InputDecoration(
                          labelText: 'Danh mục',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: _categories
                            .where((c) => c != 'Tất cả')
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedCat = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú',
                          prefixIcon: Icon(Icons.note_alt_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final updated = Expense(
                        id: exp.id,
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text.trim()),
                        note: noteController.text.trim(),
                        date: exp.date,
                        category: selectedCat,
                      );
                      await _controller.updateExpense(updated);
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                      if (!mounted) return;
                      _loadExpenses();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã cập nhật mục chi tiêu!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  },
                  child: const Text('Cập nhật'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Xác nhận xóa
  void _confirmDelete(Expense exp) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa khoản chi "${exp.title}" (${currencyFormat.format(exp.amount)})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (exp.id != null) {
                await _controller.deleteExpense(exp.id!);
                if (dialogCtx.mounted) {
                  Navigator.pop(dialogCtx);
                }
                if (!mounted) return;
                _loadExpenses();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa mục chi tiêu khỏi SQLite!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          'Quản Lý Chi Tiêu Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _loadExpenses,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Thẻ tổng quan ngân sách / chi tiêu
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(70),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TỔNG CHI TIÊU ĐÃ GHI NHẬN',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(_totalAmount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tổng số mục chi: ${_expenses.length} giao dịch',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // 2. Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Tìm nội dung chi tiêu, ghi chú...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 3. Thanh lọc theo danh mục (Filter Chips)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      _loadExpenses();
                    },
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade800,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue.shade900 : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // 4. Danh sách các khoản chi tiêu
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _expenses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Chưa có khoản chi tiêu nào',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: _expenses.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final exp = _expenses[index];
                          final catColor = _getCategoryColor(exp.category);
                          return Card(
                            elevation: 0.8,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Icon danh mục
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: catColor.withAlpha(35),
                                    child: Icon(_getCategoryIcon(exp.category), color: catColor, size: 22),
                                  ),
                                  const SizedBox(width: 14),

                                  // Thông tin chi tiêu: Tiêu đề, danh mục, ngày, ghi chú
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exp.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: catColor.withAlpha(25),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                exp.category,
                                                style: TextStyle(
                                                  color: catColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              exp.date,
                                              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        if (exp.note.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            exp.note,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Số tiền và nút thao tác
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '-${currencyFormat.format(exp.amount)}',
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () => _showEditExpenseDialog(exp),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () => _confirmDelete(exp),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseDialog,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Thêm Chi Tiêu'),
      ),
    );
  }
}
