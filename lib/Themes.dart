import 'package:flutter/material.dart';

class ContactBuddyColors {
  static const orange = Colors.orange;
  static const orangeAccent = Colors.orangeAccent;
}

class Themes {
  static final lightTheme = ThemeData(
    primaryColor: ContactBuddyColors.orangeAccent,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: ContactBuddyColors.orange,
    brightness: Brightness.dark,
  );
}
