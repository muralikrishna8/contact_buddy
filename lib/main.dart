import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'ContactView.dart';

void main() => runApp(ContactsBuddy());

class ContactsBuddy extends StatefulWidget {
  @override
  _ContactsBuddyState createState() => _ContactsBuddyState();
}

class _ContactsBuddyState extends State<ContactsBuddy> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts =
          await FlutterContacts.getContacts(withProperties: true, sorted: true);
      setState(() => _contacts = contacts.where((c) => c.isStarred).toList());
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(appBar: AppBar(title: Text('Contacts 📞')), body: _body()));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());

    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(5),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 0.80,
      children: List.generate(
          _contacts!.length,
          (index) => InkWell(
                onTap: () async {
                  print(_contacts![index]);
                  final fullContact =
                      await FlutterContacts.getContact(_contacts![index].id);
                  print("===========\n");
                  print(fullContact?.thumbnail != null ? 'present' : 'no');
                  print(fullContact?.thumbnail);
                  await FlutterPhoneDirectCaller.callNumber(
                      fullContact!.phones.first.number);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ContactView(_contacts![index]),
                ),
              )),
    );
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;

  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('Starred: ${contact.isStarred}'),
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}