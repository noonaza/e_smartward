import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textField1(
  String labelText, {
  required TextEditingController controller,
  bool readOnly = false,
  String? initialValue,
  Function(dynamic val)? onChanged,
  List<TextInputFormatter>? inputFormatters,  TextInputType? keyboardType,
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

Widget textFieldCalendar(
  String labelText, {
  required TextEditingController controller,
  bool readOnly = false,
  String? initialValue,
  ValueChanged<String>? onChanged,
  List<TextInputFormatter>? inputFormatters,

  // เพิ่มเติมเพื่อการตกแต่ง/พฤติกรรม
  String? hintText,
  Widget? prefixIcon,
  Widget? trailingIcon,         // เช่น Icon(Icons.calendar_month)
  VoidCallback? onTrailingTap,  // กดไอคอนท้าย
  bool showClear = false,       // แสดงปุ่มล้างค่าอัตโนมัติ
  VoidCallback? onClear,        // callback ตอนล้างค่า
  VoidCallback? onTap,          // แตะที่ช่อง
}) {
  // ตั้งค่าแรกเข้าเฉพาะตอนที่ยังไม่มีค่าใน controller
  if (initialValue != null && controller.text.isEmpty) {
    controller.text = initialValue;
  }

  final baseBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: const Color(0xFFB5D8F1), width: 1.2),
  );

  // ทำให้ suffix เปลี่ยนตามข้อความ โดยไม่ต้องเป็น StatefulWidget
  return SizedBox(
    height: 42, // สูงขึ้นนิดให้ดูโปรกว่า
    child: ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        // สร้าง suffix รวม: [Clear] + [Trailing]
        final List<Widget> suffixChildren = [];

        if (showClear && hasText) {
          suffixChildren.add(
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.clear, size: 18, color: Colors.redAccent),
              tooltip: 'ล้างค่า',
              onPressed: () {
                controller.clear();
                onClear?.call();
                onChanged?.call(''); // สื่อสารว่าเปลี่ยนเป็นค่าว่าง
              },
            ),
          );
        }

        if (trailingIcon != null) {
          suffixChildren.add(
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: trailingIcon,
              onPressed: onTrailingTap,
              tooltip: 'ดำเนินการ',
            ),
          );
        }

        return TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(fontSize: 13, color: Colors.teal),
          decoration: InputDecoration(
            isDense: true,
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 1, 99, 87),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4),
                    child: prefixIcon,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 36, minHeight: 36),

            // รวมปุ่มด้านขวาใน Row (suffixIcon ต้องเป็น 1 widget)
            suffixIcon: suffixChildren.isEmpty
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: suffixChildren,
                  ),

            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

            // ขอบสวย ๆ โทนเดียวกับระบบ
            border: baseBorder,
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: const BorderSide(color: Color(0xFF22A699), width: 2),
            ),
          ),
          onChanged: onChanged,
          keyboardType: TextInputType.text,
          inputFormatters: inputFormatters,
        );
      },
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
