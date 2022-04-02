//Now i'm going to make a custom button for the different action like the comment button, share ...
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

//the button wil take 3 parameter : the icon , the action title and the color of the icon
Widget actionButton(IconData icon, String actionTitle, Color iconColor) {
  return Expanded(
    child: FlatButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        color: iconColor,
      ),
      label: Text(
        actionTitle,
        // ignore: prefer_const_constructors
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}
