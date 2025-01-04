// ignore_for_file: prefer_const_constructors, unused_import, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Icon sufIcon;
  final isObs = false;
  final String Hint;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.sufIcon,
      required this.Hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObs,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: sufIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: Hint,
      ),
    );
  }
}
