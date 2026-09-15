import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int cardIndex = 0;

  final List<Map<String, String>> cards = [
    {
      'balance': '\$5250.25',
      'number': '12345678',
      'date': '10/24',
    },
    {
      'balance': '\$1840.70',
      'number': '98765432',
      'date': '08/25',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final card = cards[cardIndex];

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        backgroundColor: const Color(0xfff4f4f4),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'My Cards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => showMessage('Thêm thẻ mới'),
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 175,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff8b5fc7),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Balance', style: TextStyle(color: Colors.white70)),
                Text(
                  card['balance']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(card['number']!, style: const TextStyle(color: Colors.white70)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    card['date']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cards.length, (index) {
              final selected = index == cardIndex;
              return GestureDetector(
                onTap: () => setState(() => cardIndex = index),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: selected ? 28 : 10,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              actionButton(Icons.send, 'Send'),
              actionButton(Icons.credit_card, 'Pay'),
              actionButton(Icons.receipt_long, 'Bills'),
            ],
          ),
          const SizedBox(height: 28),
          informationRow(
            icon: Icons.bar_chart,
            title: 'Statistics',
            subtitle: 'Payment and Income',
          ),
          const SizedBox(height: 12),
          informationRow(
            icon: Icons.payments,
            title: 'Transactions',
            subtitle: 'Transaction History',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffd51b55),
        onPressed: () => showMessage('Mở chức năng thanh toán'),
        child: const Icon(Icons.attach_money, color: Colors.white),
      ),
    );
  }

  Widget actionButton(IconData icon, String title) {
    return GestureDetector(
      onTap: () => showMessage(title),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget informationRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: Icon(icon, size: 38, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showMessage(title),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}