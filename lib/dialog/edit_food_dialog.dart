import 'package:action_slider/action_slider.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EditFoodDialog extends StatefulWidget {
  final String foodName;
  final String foodDose;
  final String foodproperties;
  final String foodnote;
  final String fooddoctor;

  const EditFoodDialog({
    super.key,
    required this.foodName,
    required this.foodDose,
    required this.foodproperties,
    required this.foodnote,
    required this.fooddoctor,
  });

  @override
  State<EditFoodDialog> createState() => _EditFoodDialogState();

  static void show(
    BuildContext context,
    String foodName,
    String foodDose,
    String foodproperties,
    String foodnote,
    String fooddoctor,
    // {List<String> foodTimes = const []}
  ) {
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
      body: EditFoodDialog(
        foodName: foodName,
        foodDose: foodDose,
        foodproperties: foodproperties,
        foodnote: foodnote,
        fooddoctor: fooddoctor,
      ),
    ).show();
  }
}

class _EditFoodDialogState extends State<EditFoodDialog> {
  TextEditingController tFoodName = TextEditingController();
  TextEditingController tFoodDose = TextEditingController();
  TextEditingController tFoodCondition = TextEditingController();
  TextEditingController tFoodTime = TextEditingController();
  TextEditingController tFoodProperties = TextEditingController();
  TextEditingController tFoodNote = TextEditingController();
  TextEditingController tFoodDoctor = TextEditingController();
  TextEditingController tFoodTimeHour = TextEditingController();

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
    tFoodName.text = widget.foodName;
    tFoodDose.text = widget.foodDose;
    tFoodNote.text = widget.foodnote;
    tFoodDoctor.text = widget.fooddoctor;
    tFoodProperties.text = widget.foodproperties;
  }

  @override
  void dispose() {
    tFoodName.dispose();
    tFoodDose.dispose();
    tFoodProperties.dispose();
    tFoodCondition.dispose();
    tFoodNote.dispose();
    tFoodDoctor.dispose();
    super.dispose();
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
          textField1('ชื่อยา', controller: tFoodName),
          const SizedBox(height: 10),
          textField1('วิธีให้', controller: tFoodDose),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tFoodCondition),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tFoodNote),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งยา', controller: tFoodDoctor),
          const SizedBox(height: 15),
          TimeSelection(
            time: time,
            timeList: timeList,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: actionSlider(
              context,
              'ยืนยันการให้อาหารเพิ่มเติม',
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
