import 'package:flutter/material.dart';

class ProgressNoteDialog extends StatelessWidget {
  final List<dynamic> lProgressNote; 
  final VoidCallback onClose;

  const ProgressNoteDialog({
    Key? key,
    required this.lProgressNote,
    required this.onClose,
  }) : super(key: key);

  TextSpan textSpan(
    String text, {
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 14,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  // ✅ ฟังก์ชัน text สำหรับใช้ทั่วไป
  Widget text(
    BuildContext context,
    String data, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
  }) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 16, right: 4, top: 12, bottom: 4),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/pgnote.png'),
              ),
              const SizedBox(width: 8),
              text(
                context,
                'Progress Note',
                color: Colors.teal,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.teal, size: 30),
            onPressed: onClose,
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: lProgressNote.isEmpty
            ? const Text('ไม่มีข้อมูล Progress Note')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: lProgressNote.length,
                itemBuilder: (context, index) {
                  final note = lProgressNote[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          context,
                          'โดย : ${note.doctor_create_name ?? '-'} (${note.create_datetime ?? '-'})',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              textSpan('S : ', color: Colors.red, fontWeight: FontWeight.bold),
                              textSpan(note.s ?? '-', color: Colors.black),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              textSpan('O : ', color: Colors.red, fontWeight: FontWeight.bold),
                              textSpan(note.o ?? '-', color: Colors.black),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              textSpan('A : ', color: Colors.red, fontWeight: FontWeight.bold),
                              textSpan(note.a ?? '-', color: Colors.black),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              textSpan('P : ', color: Colors.red, fontWeight: FontWeight.bold),
                              textSpan(note.p ?? '-', color: Colors.black),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
