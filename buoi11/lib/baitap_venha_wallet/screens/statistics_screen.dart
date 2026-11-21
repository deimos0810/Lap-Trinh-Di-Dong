import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/wallet_service.dart';

class StatisticsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const StatisticsScreen({super.key, required this.onBack});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _walletService = WalletService();
  int _selectedFilterDays = 30; // 30 ngày (1 tháng), 90 ngày (1 quý), 365 ngày (1 năm)
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoading = true);
    final data = await _walletService.getTransactionsByRange(_selectedFilterDays);
    if (mounted) {
      setState(() {
        _transactions = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpense = 0;

    for (var t in _transactions) {
      final amt = (t['amount'] as num?)?.toDouble() ?? 0.0;
      if (amt > 0) {
        totalIncome += amt;
      } else {
        totalExpense += amt.abs();
      }
    }

    final currency = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Thống kê dòng tiền"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Segmented Filter: 1 tháng | 1 quý | 1 năm
            Row(
              children: [
                _buildFilterChip("1 Tháng", 30),
                const SizedBox(width: 8),
                _buildFilterChip("1 Quý (3 tháng)", 90),
                const SizedBox(width: 8),
                _buildFilterChip("1 Năm", 365),
              ],
            ),
            const SizedBox(height: 20),

            // Summary cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tổng Thu (Income)", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(currency.format(totalIncome), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tổng Chi (Expense)", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(currency.format(totalExpense), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Danh sách các giao dịch trong kỳ
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Chi tiết giao dịch (${_transactions.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _transactions.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text("Không có giao dịch nào trong khoảng thời gian này.", style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final t = _transactions[idx];
                          final amt = (t['amount'] as num?)?.toDouble() ?? 0.0;
                          final isPos = amt > 0;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPos ? Colors.green.shade100 : Colors.red.shade100,
                              child: Icon(isPos ? Icons.arrow_downward : Icons.arrow_upward, color: isPos ? Colors.green : Colors.red),
                            ),
                            title: Text(t['title'] ?? 'Giao dịch'),
                            subtitle: Text(t['targetEmail'] != null && (t['targetEmail'] as String).isNotEmpty
                                ? "Đối tác: ${t['targetEmail']}"
                                : t['type'] ?? ''),
                            trailing: Text(
                              "${isPos ? '+' : ''}${currency.format(amt)}",
                              style: TextStyle(fontWeight: FontWeight.bold, color: isPos ? Colors.green : Colors.red),
                            ),
                          );
                        },
                      )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int days) {
    final isSelected = _selectedFilterDays == days;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedFilterDays = days);
          _fetchStats();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4C35DE) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? const Color(0xFF4C35DE) : Colors.grey.shade300),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
