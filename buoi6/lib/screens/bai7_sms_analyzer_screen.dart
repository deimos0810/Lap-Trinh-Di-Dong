import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class Bai7SmsAnalyzerScreen extends StatefulWidget {
  const Bai7SmsAnalyzerScreen({super.key});

  @override
  State<Bai7SmsAnalyzerScreen> createState() => _Bai7SmsAnalyzerScreenState();
}

class _Bai7SmsAnalyzerScreenState extends State<Bai7SmsAnalyzerScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _allMessages = [];
  List<SmsMessage> _filteredMessages = [];
  bool _isLoading = false;
  int _filterType = 0; // 0: Tất cả, 1: Quảng cáo [QC], 2: OTP
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSms();
  }

  Future<void> _fetchSms() async {
    setState(() => _isLoading = true);
    if (await Permission.sms.request().isGranted) {
      final messages = await _query.getAllSms;
      setState(() {
        _allMessages = messages;
        _applyFilters();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    List<SmsMessage> list = List.from(_allMessages);
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      list = list.where((m) => (m.address ?? '').contains(phone)).toList();
    }

    if (_filterType == 1) {
      list = list.where((m) => (m.body ?? '').toUpperCase().startsWith('[QC]')).toList();
    } else if (_filterType == 2) {
      list = list.where((m) {
        final body = m.body ?? '';
        return body.toUpperCase().contains('OTP') || RegExp(r'\b\d{6}\b').hasMatch(body);
      }).toList();
    }

    setState(() => _filteredMessages = list);
  }

  String _extractOtp(String body) {
    final match = RegExp(r'\b\d{6}\b').firstMatch(body);
    return match != null ? match.group(0)! : 'Không tìm thấy mã OTP';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Analyzer'), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchSms)]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Lọc theo SĐT', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search)),
                    onChanged: (_) => _applyFilters(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(label: const Text('Tất cả'), selected: _filterType == 0, onSelected: (_) { setState(() => _filterType = 0); _applyFilters(); }),
                    FilterChip(label: const Text('[QC]'), selected: _filterType == 1, onSelected: (_) { setState(() => _filterType = 1); _applyFilters(); }),
                    FilterChip(label: const Text('Mã OTP'), selected: _filterType == 2, onSelected: (_) { setState(() => _filterType = 2); _applyFilters(); }),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredMessages.length,
                    itemBuilder: (context, index) {
                      final msg = _filteredMessages[index];
                      final isOtp = (msg.body ?? '').toUpperCase().contains('OTP') || RegExp(r'\b\d{6}\b').hasMatch(msg.body ?? '');
                      return ListTile(
                        leading: Icon(isOtp ? Icons.lock : Icons.sms, color: isOtp ? Colors.cyan : Colors.white),
                        title: Text(msg.address ?? 'Không rõ'),
                        subtitle: Text(msg.body ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: isOtp
                            ? () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Mã OTP'),
                                    content: Text('Mã OTP 6 số: ${_extractOtp(msg.body ?? '')}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan)),
                                  ),
                                )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}