import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

Widget CustomCloseButton(BuildContext context) {
  return Align(
    alignment: Alignment.topRight,
    child: TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(
        backgroundColor: Colors.red[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: text(context,
          'ปิดหน้าต่าง'), 
    ),
  );
}
