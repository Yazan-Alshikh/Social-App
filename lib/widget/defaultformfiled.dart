import 'package:flutter/material.dart';

Widget defaultFormfiled(
        {@required TextInputType type,
        @required Function validator,
        bool ispassword = false,
        Function onsubmit,
        @required TextEditingController controller,
        String label,
        String hinttext,
        @required IconData prefix,
        IconData suffix,
        Function onsuffixpreesed}) =>
    TextFormField(
      keyboardType: type,
      validator: validator,
      obscureText: ispassword,
      onFieldSubmitted: onsubmit,
      decoration: InputDecoration(
        hintText: hinttext,
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          icon: Icon(
            suffix,
            color: Colors.grey,
          ),
          onPressed: onsuffixpreesed,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      controller: controller,
    );
