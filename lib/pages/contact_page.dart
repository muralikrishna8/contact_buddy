import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactPage extends StatelessWidget {
  final Contact contact;

  const ContactPage(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(contact.phones);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _photo(context),
            _nameAndPhone(context),
            Container(
              decoration: const BoxDecoration(
                color: Color(0x881F1F1F),
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var event in contact.events) _events(context, event),
                  _email(context),
                  const Divider(
                      color: Colors.black12, thickness: 2, height: 30),
                  _address(context),
                ],
              ),
            ),
          ]),
        ));
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          FlutterPhoneDirectCaller.callNumber(contact.phones.first.number);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.call_outlined));
  }

  Row _email(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.email_sharp,
            size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(
          width: 10,
        ),
        Text(contact.emails.isNotEmpty
            ? contact.emails.first.address
            : '(none)'),
      ],
    );
  }

  Row _address(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_sharp,
            size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(
          width: 10,
        ),
        Text(contact.addresses.isNotEmpty
            ? contact.addresses.first.address
            : '(none)'),
      ],
    );
  }

  Column _events(BuildContext context, Event event) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.calendar_month_outlined,
                size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${event.day}/${event.month}/${event.year}'),
                Text(
                  event.label.name.capitalize(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(
          color: Colors.black12,
          thickness: 2,
          height: 30,
        ),
      ],
    );
  }

  _photo(BuildContext context) {
    return contact.photoOrThumbnail == null
        ? Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color(0x88343435),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: const EdgeInsetsDirectional.only(top: 2),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Center(
                  child: Text(
                    contact.displayName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 150,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              _bottomDecoratedShape(context)
            ],
          )
        : Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              clipBehavior: Clip.antiAlias,
              child: Image.memory(
                contact.photoOrThumbnail!,
                scale: 0.1,
              ),
            ),
            _bottomDecoratedShape(context)
          ]);
  }

  Positioned _bottomDecoratedShape(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: ClipPath(
        clipper: TriangleClipper(),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: 70,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Container _nameAndPhone(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            contact.displayName,
            style: const TextStyle(fontSize: 40),
          ),
          for (var phone in contact.phones) _number(phone),
        ]));
  }

  Container _number(Phone phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(children: [
        const Icon(
          Icons.call_outlined,
          size: 15,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Text(phone.number, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 5),
        phone.isPrimary
            ? Container(
                padding:
                    const EdgeInsets.only(top: 1, left: 6, right: 6, bottom: 1),
                decoration: BoxDecoration(
                    color: const Color(0x88343435),
                    borderRadius: BorderRadius.circular(2)),
                child: const Text(
                  'Default',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              )
            : const Text(''),
      ]),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.width);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
