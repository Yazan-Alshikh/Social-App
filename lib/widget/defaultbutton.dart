import 'package:flutter/material.dart';

Widget defaultbutton({@required Function onPressed, @required String text}) =>
    Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text.toUpperCase()),
      ),
    );
