import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class ContactPage extends StatelessWidget {
  final Contact contact;

  const ContactPage(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(contact.events);
    return Scaffold(
        appBar: AppBar(title: Center(child: Text(contact.displayName))),
        body: Column(children: [
          Image.memory(contact.photoOrThumbnail!),
          const SizedBox(
            height: 20,
          ),
          Text(
            contact.displayName,
            style: const TextStyle(fontSize: 40),
          ),
          Text(contact.phones.isNotEmpty
              ? contact.phones.first.number
              : '(none)'),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xAE313030),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: const Offset(-1, 0), // changes position of shadow
                  ),
                ]),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.cake_rounded,
                    size: 20, color: Theme.of(context).primaryColor),
                Text(contact.events.first.label.name),
                Text(' ${contact.events.first.day}/'),
                Text('${contact.events.first.month}/'),
                Text('${contact.events.first.year}'),
              ],
            ),
          ),
          Text(
              'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
        ]));
  }
}
