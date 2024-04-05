import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class AllContacts extends StatelessWidget {
  final List<Contact> contacts;

  const AllContacts(this.contacts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          var contact = contacts[index];
          return ListTile(
            title: Row(
              children: [
                contact.thumbnail == null
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        width: 45,
                        child: Center(
                          child: Text(
                            contact.displayName[0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        width: 45,
                        clipBehavior: Clip.antiAlias,
                        child: Image.memory(contact.thumbnail!),
                      ),
                const SizedBox(width: 10),
                Text(contacts[index].displayName),
              ],
            ),
          );
        });
  }
}
