import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

void main() => runApp(FlutterContactsExample());

class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
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
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withThumbnail: true, sorted: true);
      setState(() => _contacts = contacts.where((c) => c.isStarred).toList());
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('flutter_contacts_example')),
          body: _body()));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());

    return GridView.count(
      crossAxisCount: 2,
      primary: true,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      shrinkWrap: false,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_contacts![index].thumbnail != null)
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: Image.memory(_contacts![index].thumbnail!),
                            ),
                          )
                        else
                          Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                          ),
                        Text(_contacts![index].displayName)
                      ]),
                ),
              )),
    );

    // return ListView.builder(
    //     itemCount: _contacts!.length,
    //     itemBuilder: (context, i) => ListTile(
    //         title: Text(_contacts![i].displayName),
    //         onTap: () async {
    //           final fullContact =
    //               await FlutterContacts.getContact(_contacts![i].id);
    //           await Navigator.of(context).push(
    //               MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
    //         }));
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