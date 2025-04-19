import 'package:action_slider/action_slider.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CreateDrugDialog extends StatefulWidget {
  const CreateDrugDialog({super.key});

  @override
  State<CreateDrugDialog> createState() => _CreateDrugDialogState();

  static void show(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: MediaQuery.of(context).size.width * 0.5,
      dismissOnTouchOutside: false,
      customHeader: Stack(
        children: [
          Image.asset(
            'assets/gif/medicin.gif',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      body: const CreateDrugDialog(),
    ).show();
  }
}

class _CreateDrugDialogState extends State<CreateDrugDialog> {
  TextEditingController tDrudName = TextEditingController();
  TextEditingController tDrugDose = TextEditingController();
  TextEditingController tDrugCondition = TextEditingController();
  TextEditingController tDrugTime = TextEditingController();
  List<String> typeDrug = [
    'ยาหยอด',
    'ยาฉีด (วัคซีน และ ยาฉีดอื่นๆ)',
    'ยาน้ำ',
    'ยาทา (ยาภายนอก)',
  ];
  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'กำหนดเอง',
  ];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });

  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;

  @override
  void initState() {
    super.initState();
    selected = List.generate(time.length, (index) => false);
    selectedTimeList = List.generate(timeList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 5),
          textField1('ชื่อยา', controller: tDrudName),
          const SizedBox(height: 10),
          textField1('วิธีให้', controller: tDrugDose),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: DropdownButtonFormField<String>(
              value: selectedTypeDrug,
              decoration: InputDecoration(
                labelText: 'ประเภทยา',
                labelStyle: TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
              ),
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  selectedTypeDrug = newValue;
                });
              },
              items: typeDrug.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: text(context, type),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tDrudName),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tDrudName),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งยา', controller: tDrudName),
          const SizedBox(height: 15),
          TimeSelection(
            time: time,
            timeList: timeList,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: actionSlider(
              context,
              'ยืนยันการให้ยาเพิ่มเติม',
              width: MediaQuery.of(context).size.width * 0.4,
              height: 30.0,
              backgroundColor: const Color.fromARGB(255, 203, 230, 252),
              togglecolor: const Color.fromARGB(255, 76, 172, 175),
              icons: Icons.check,
              iconColor: Colors.white,
              asController: ActionSliderController(),
              action: (controller) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
