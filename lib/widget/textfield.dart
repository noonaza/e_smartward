import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textField1(
  String labelText, {
  required TextEditingController controller,
  bool readOnly = false,
  String? initialValue,
  ValueChanged<String>? onChanged,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  FocusNode? focusNode, 
  int? maxLength,

}) {

  if (initialValue != null && controller.text.isEmpty) {
    controller.text = initialValue;
  }

  return SizedBox(
    height: 48,
    child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      focusNode: focusNode, 
      maxLines: 1,
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
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        counterText: '',
      ),
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ...?inputFormatters,
      ],
    ),
  );
}


Widget textFieldCalendar(
  String labelText, {
  required TextEditingController controller,
  bool readOnly = true,
  String? initialValue,
  ValueChanged<String>? onChanged,
  List<TextInputFormatter>? inputFormatters,
  String? hintText,
  Widget? prefixIcon,
  Widget? trailingIcon,
  VoidCallback? onTrailingTap,
  bool showClear = false,
  VoidCallback? onClear,
  VoidCallback? onTap,
}) {
  // ✅ กันการ set ทับทุก rebuild
  if (initialValue != null && controller.text.isEmpty) {
    controller.text = initialValue;
  }

  final baseBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    borderSide: const BorderSide(color: Color(0xFFB5D8F1), width: 1.2),
  );

  return ValueListenableBuilder<TextEditingValue>(
    valueListenable: controller,
    builder: (context, value, _) {
      final hasText = value.text.isNotEmpty;

      final suffixChildren = <Widget>[];

      if (showClear && hasText) {
        suffixChildren.add(
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.clear, size: 18, color: Colors.redAccent),
            onPressed: () {
              controller.clear();
              onClear?.call();
              onChanged?.call('');
            },
          ),
        );
      }

      if (trailingIcon != null) {
        suffixChildren.add(
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: trailingIcon,
            onPressed: onTrailingTap ?? onTap,
          ),
        );
      }

      return TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center, // ✅ สำคัญมาก กันตัวอักษรถูกตัด
        style: const TextStyle(fontSize: 13, color: Colors.teal),
        decoration: InputDecoration(
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

          // ✅ ใส่ constraint ให้ suffix ไม่บีบ text
          suffixIcon: suffixChildren.isEmpty
              ? null
              : ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40, maxWidth: 120),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: suffixChildren,
                  ),
                ),

          filled: true,
          fillColor: Colors.white,

          // ✅ อย่าล็อคสูง 42 แบบเดิม ให้ padding พอดีตอน label ลอย
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

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
