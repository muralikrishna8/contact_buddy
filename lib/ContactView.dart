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
                  Container(
                    height: 100,
                    child: Stack(
                      children: [
                        if (fullContact.thumbnail != null)
                          ClipOval(
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child: Image.memory(
                                  fullContact.thumbnail!,
                                  fit: BoxFit.contain,
                                )),
                          )
                        else
                          CircleAvatar(
                            backgroundColor: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            radius: 50,
                            child: Text(
                              contact.displayName[0].toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        const CallIconView()
                      ],
                    ),
                  ),
                  Text(fullContact.displayName)
                ]);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class CallIconView extends StatelessWidget {
  const CallIconView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 10,
        right: 0,
        child: Container(
          decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ]),
          child: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.call_outlined, size: 20),
          ),
        ));
  }
}
