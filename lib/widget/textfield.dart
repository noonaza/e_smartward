import 'package:flutter/material.dart';

Widget textField1(String labelText,
    {required TextEditingController controller}) {
  return SizedBox(
    height: 35,
    child: TextFormField(
      controller: controller, // Controller is passed to the TextFormField
      style: const TextStyle(fontSize: 12, color: Colors.teal),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 1, 99, 87), fontSize: 12),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );
}
