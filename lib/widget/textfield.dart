import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textField1(
  String labelText, {
  required TextEditingController controller,
  bool readOnly = false,
  String? initialValue,
  Function(dynamic val)? onChanged,
  List<TextInputFormatter>? inputFormatters,
}) {
  if (initialValue != null) {
    controller.text = initialValue;
  }

  return SizedBox(
    height: 35,
    child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 12, color: Colors.teal),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 1, 99, 87),
          fontSize: 12,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      inputFormatters: inputFormatters, 
    ),
  );
}


Widget textFieldNote(
  BuildContext context,
  String labelText, {
  required TextEditingController controller,
  bool readOnly = false,
  String? initialValue,
  Color? color,
  Function(dynamic val)? onChanged,
}) {
  if (initialValue != null) {
    controller.text = initialValue;
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      text(
        context,
        labelText,
        color: readOnly ? Colors.black : (color ?? Colors.teal),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 12,
            color: readOnly ? Colors.black : (color ?? Colors.teal),
          ),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            border: UnderlineInputBorder(),
          ),
        ),
      ),
    ],
  );
}
