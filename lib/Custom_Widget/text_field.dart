import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
TextInput (
    {Key? key,
      required this.controller,
      required this. label,
      this. line = 1,
      this. keyboardType,
      this.onTap})
    : super(key: key);

  TextEditingController controller;
  TextInputType? keyboardType;
  String label;
  int line;
  Function ()? onTap;

  @override
  Widget build (BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: line,
        onTap: onTap,
        decoration: InputDecoration(
        label: Text (label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
      ), // Input Decoration
    ); // TextFormField
  }
}