import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class SendMoneyScreen extends StatefulWidget {
  final double balance;
  const SendMoneyScreen({super.key, required this.balance});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _emailReceiverCtrl = TextEditingController();
  final _walletService = WalletService();
  String _amountStr = "1740.00";
  bool _isLoading = false;

  void _onKeypadTap(String val) {
    setState(() {
      if (val == "DEL") {
        if (_amountStr.isNotEmpty) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
          if (_amountStr.isEmpty) _amountStr = "0";
        }
      } else if (val == ".") {
        if (!_amountStr.contains(".")) {
          _amountStr += ".";
        }
      } else {
        if (_amountStr == "0" || _amountStr == "1740.00") {
          _amountStr = val;
        } else {
          _amountStr += val;
        }
      }
    });
  }

  Future<void> _handleSendMoney() async {
    final amt = double.tryParse(_amountStr) ?? 0.0;
    final receiverEmail = _emailReceiverCtrl.text.trim();

    if (receiverEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập Email người nhận!")),
      );
      return;
    }

    if (amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Số tiền chuyển phải lớn hơn 0!")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _walletService.transferMoney(
        receiverEmail: receiverEmail,
        amount: amt,
        note: "Amazon New macbook air m2",
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Chuyển thành công \$$amt đến $receiverEmail")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Send Money", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Card Wallet Balance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Wallet balance", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(
                            "Safe to spend \$${widget.balance.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.swap_horiz, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Card Target/Merchant (Amazon or Email)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.orange.shade100, shape: BoxShape.circle),
                      child: const Text("a", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _emailReceiverCtrl,
                        decoration: const InputDecoration(
                          hintText: "Email nhận tiền (VD: andrew@gmail.com)",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.orange),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Hiển thị số tiền to bản ($1740,00)
            Text(
              "\$$_amountStr",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            const Text("The transfer will be complete by Friday, August 21", style: TextStyle(color: Colors.grey, fontSize: 12)),

            const Spacer(),

            // Bàn phím số Numpad custom (1-9, ., 0, DEL)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _buildNumRow(["1", "2", "3"]),
                  const SizedBox(height: 16),
                  _buildNumRow(["4", "5", "6"]),
                  const SizedBox(height: 16),
                  _buildNumRow(["7", "8", "9"]),
                  const SizedBox(height: 16),
                  _buildNumRow([".", "0", "DEL"]),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C35DE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _handleSendMoney,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Send money", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNumRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys.map((k) {
        return InkWell(
          onTap: () => _onKeypadTap(k),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: k == "DEL"
                ? const Icon(Icons.backspace_outlined, size: 22, color: Colors.black87)
                : Text(k, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }
}
