import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  const ContactView(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Contact?>(
        future: FlutterContacts.getContact(contact.id),
        builder: (context, AsyncSnapshot<Contact?> snapshot) {
          if (snapshot.hasData) {
            Contact fullContact = snapshot.data!;
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (fullContact.thumbnail != null)
                    ClipOval(
                      child: SizedBox.fromSize(
                          size: const Size.fromRadius(45), // Image radius
                          child: Image.memory(
                            fullContact.thumbnail!,
                            fit: BoxFit.contain,
                          )),
                    )
                  else
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    ),
                  Text(fullContact.displayName)
                ]);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
