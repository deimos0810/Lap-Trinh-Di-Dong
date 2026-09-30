import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'bai5_add_contact_screen.dart';

class Bai5ContactsScreen extends StatefulWidget {
  const Bai5ContactsScreen({super.key});

  @override
  State<Bai5ContactsScreen> createState() => _Bai5ContactsScreenState();
}

class _Bai5ContactsScreenState extends State<Bai5ContactsScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    if (await FlutterContacts.requestPermission(readonly: false)) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Bai5AddContactScreen()),
              );
              _loadContacts();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
              ? const Center(child: Text('Không có danh bạ nào.'))
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = _contacts[index];
                    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : 'Không có số';
                    final email = contact.emails.isNotEmpty ? contact.emails.first.address : 'Không có email';

                    return ListTile(
                      leading: contact.photo != null
                          ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(contact.displayName),
                      subtitle: Text('$phone\n$email'),
                    );
                  },
                ),
    );
  }
}