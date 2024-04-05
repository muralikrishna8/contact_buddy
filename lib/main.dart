import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'Themes.dart';
import 'contact_view.dart';

void main() => runApp(const ContactsBuddy());

class ContactsBuddy extends StatefulWidget {
  const ContactsBuddy({Key? key}) : super(key: key);

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
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              title: const Center(
                  child: Text(
            'Contacts 📞',
          ))),
          body: _body()));

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.68,
      ),
      itemCount: _contacts!.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(5),
          child: ContactView(_contacts![index]),
        );
      },
    );
  }
}


