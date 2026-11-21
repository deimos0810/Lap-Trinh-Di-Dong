import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/wallet_service.dart';
import 'send_money_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _walletService = WalletService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _walletService.initUserDataIfNew();
  }

  void _showTopUpDialog() {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nạp tiền vào ví (Top Up)"),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Số tiền (\$)", prefixText: "\$ "),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
              if (amt > 0) {
                await _walletService.topUp(amt);
                if (ctx.mounted) Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã nạp +\$$amt vào ví!")));
              }
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog() {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rút tiền (Withdraw)"),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Số tiền muốn rút (\$)", prefixText: "\$ "),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
              if (amt > 0) {
                try {
                  await _walletService.withdraw(amt);
                  if (ctx.mounted) Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã rút -\$$amt thành công!")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                }
              }
            },
            child: const Text("Rút tiền"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 2) {
      return StatisticsScreen(onBack: () => setState(() => _selectedIndex = 0));
    }
    if (_selectedIndex == 3) {
      return ProfileScreen(onBack: () => setState(() => _selectedIndex = 0));
    }

    final currencyFmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _walletService.streamUserProfile(),
          builder: (context, snapshot) {
            final userData = snapshot.data?.data() as Map<String, dynamic>?;
            final balance = ((userData?['balance'] ?? 2108.22) as num).toDouble();
            final points = userData?['points'] ?? 6350;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("zhippay", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF23262F))),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                            child: const Row(
                              children: [
                                Icon(Icons.stars, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text("rewards", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {},
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Total Balance Card (màu xanh đậm như mockup)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C35DE),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total balance", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFmt.format(balance),
                              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.stars, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text("$points points", style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        // 4 Quick Actions: Top Up, Transfer, Withdraw, History
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildQuickAction(Icons.add_circle_outline, "Top Up", _showTopUpDialog),
                            _buildQuickAction(Icons.send_outlined, "Transfer", () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => SendMoneyScreen(balance: balance)));
                            }),
                            _buildQuickAction(Icons.account_balance_wallet_outlined, "Withdraw", _showWithdrawDialog),
                            _buildQuickAction(Icons.history, "History", () => setState(() => _selectedIndex = 2)),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  // Upgrade Account Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.amber.shade50, shape: BoxShape.circle),
                          child: const Icon(Icons.upgrade, color: Colors.amber, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Upgrade Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text("Upgrade account for more features", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Transfer Again (Avatars list)
                  const Text("Transfer again", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTransferContact("Add new", null, isAdd: true),
                        _buildTransferContact("Skyler", "https://i.pravatar.cc/150?img=1"),
                        _buildTransferContact("Andrew", "https://i.pravatar.cc/150?img=2"),
                        _buildTransferContact("Lavender", "https://i.pravatar.cc/150?img=3"),
                        _buildTransferContact("Grace", "https://i.pravatar.cc/150?img=4"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Latest Transaction
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Latest transaction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => setState(() => _selectedIndex = 2),
                        child: const Text("see all", style: TextStyle(color: Color(0xFF4C35DE))),
                      ),
                    ],
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: _walletService.streamRecentTransactions(limit: 10),
                    builder: (context, transSnap) {
                      if (transSnap.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text("Lỗi tải giao dịch: ${transSnap.error}")),
                        );
                      }
                      final rawDocs = transSnap.data?.docs ?? [];
                      if (rawDocs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text("Chưa có giao dịch nào")),
                        );
                      }

                      // Sắp xếp giảm dần theo thời gian trong bộ nhớ
                      final docs = List<QueryDocumentSnapshot>.from(rawDocs);
                      docs.sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;
                        final tA = (dataA['timestamp'] as Timestamp?)?.toDate() ?? DateTime(2020);
                        final tB = (dataB['timestamp'] as Timestamp?)?.toDate() ?? DateTime(2020);
                        return tB.compareTo(tA);
                      });

                      final displayDocs = docs.take(5).toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayDocs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final t = displayDocs[i].data() as Map<String, dynamic>;
                          final amt = (t['amount'] as num?)?.toDouble() ?? 0.0;
                          final isPositive = amt > 0;
                          final date = (t['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                              child: Icon(
                                isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isPositive ? Colors.green : Colors.red,
                                size: 18,
                              ),
                            ),
                            title: Text(t['title'] ?? 'Giao dịch', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Text(DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            trailing: Text(
                              "${isPositive ? '+' : ''}${currencyFmt.format(amt)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isPositive ? Colors.green : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: const Color(0xFF4C35DE),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: "Statistic"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Account"),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTransferContact(String name, String? avatarUrl, {bool isAdd = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isAdd ? Colors.grey.shade200 : const Color(0xFF4C35DE).withOpacity(0.1),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: isAdd ? const Icon(Icons.add, color: Colors.black) : (avatarUrl == null ? const Icon(Icons.person) : null),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
