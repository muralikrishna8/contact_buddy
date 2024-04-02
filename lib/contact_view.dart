import 'dart:math';

import 'package:contact_buddy/pages/contact_page.dart';
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
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactPage(fullContact)));
                // await FlutterPhoneDirectCaller.callNumber(
                //     _contacts![index].phones.first.number);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xAE313030),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset:
                            const Offset(-1, 0), // changes position of shadow
                      ),
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          fullContact.photoOrThumbnail == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length)],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  margin:
                                      const EdgeInsetsDirectional.only(top: 2),
                                  width: 120,
                                  height: 122,
                                  child: Center(
                                    child: Text(
                                      contact.displayName[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 80,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xAE313030),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  margin: const EdgeInsets.all(3),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.memory(
                                    fullContact.photoOrThumbnail!,
                                    scale: 0.5,
                                  ),
                                ),
                          const CallIconView()
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            fullContact.displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(fullContact.phones.first.number,
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.grey,
                                fontSize: 10,
                              )),
                        ],
                      )
                    ]),
              ),
            );
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
        bottom: 0,
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
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.call_outlined,
                size: 20, color: Theme.of(context).primaryColor),
          ),
        ));
  }
}
