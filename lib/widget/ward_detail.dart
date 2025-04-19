// create_drug_widgets.dart
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

List<String> time = [
  'ทุกๆ 1 ชม.',
  'ทุกๆ 2 ชม.',
  'ทุกๆ 3 ชม.',
  'ทุกๆ 4 ชม.',
  'กำหนดเอง',
];

List<String> typeDrug = [
  'ยาหยอด',
  'ยาฉีด (วัคซีน และ ยาฉีดอื่นๆ)',
  'ยาน้ำ',
  'ยาทา (ยาภายนอก)',
];

List<String> timeList = List.generate(24, (index) {
  String formattedHour = index.toString().padLeft(2, '0');
  return '$formattedHour:00';
});

List<bool> selected = [];
List<bool> selectedTimeList = [];
int? selectedTimeIndex;
String? selectedTypeDrug;

Widget buildInput(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      height: 35,
      child: TextField(
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 1, 99, 87), fontSize: 12),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    ),
  );
}

Widget buildDropdown(BuildContext context, List<String> typeDrug,
    String? selectedTypeDrug, Function(String?) onChanged) {
  return SizedBox(
    height: 30,
    child: DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'ประเภทยา',
        labelStyle:
            TextStyle(fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: selectedTypeDrug,
      items: typeDrug.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: text(context, value),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget buildTimeGrid(BuildContext context, List<bool> selectedTimeList,
    List<String> timeList, int? selectedTimeIndex) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.lightBlue[50],
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 220,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 5,
        ),
        itemCount: timeList.length,
        itemBuilder: (context, index) {
          return IntrinsicWidth(
            child: ElevatedButton(
              onPressed: () {
                int interval = 1;
                if (selectedTimeIndex == 1) interval = 2;
                if (selectedTimeIndex == 2) interval = 3;
                if (selectedTimeIndex == 3) interval = 4;

                // Update the selection state
                selectedTimeList = List.generate(timeList.length, (i) => false);

                if (selectedTimeIndex != null &&
                    selectedTimeIndex >= 1 &&
                    selectedTimeIndex <= 3) {
                  for (int i = index; i < timeList.length; i += interval) {
                    selectedTimeList[i] = true;
                  }
                } else {
                  selectedTimeList[index] = !selectedTimeList[index];
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedTimeList[index] ? Colors.grey : Colors.white,
                side: BorderSide(
                    color: selectedTimeList[index] ? Colors.grey : Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: FittedBox(
                child: text(context, timeList[index],
                    color: Color.fromARGB(255, 10, 85, 77)),
              ),
            ),
          );
        },
      ),
    ),
  );
}

TextFields(BuildContext context) {
  return [
    buildInput(context, 'ชื่อยา'),
    buildInput(context, 'วิธีให้'),
    buildDropdown(
      context,
      typeDrug,
      selectedTypeDrug,
      (p0) {},
    ),
    buildInput(context, 'สรรพคุณ'),
    buildInput(context, 'หมายเหตุอื่นๆ'),
    buildInput(context, 'ชื่อแพทย์ที่ทำการสั่งยา'),
  ];
}
