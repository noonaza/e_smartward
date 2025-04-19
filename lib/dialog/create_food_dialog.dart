import 'package:action_slider/action_slider.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CreateFoodDialog extends StatefulWidget {
  const CreateFoodDialog({super.key});

  @override
  State<CreateFoodDialog> createState() => _CreateFoodDialogState();

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
            'assets/gif/eat.gif',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      body: const CreateFoodDialog(),
    ).show();
  }
}

class _CreateFoodDialogState extends State<CreateFoodDialog> {
  TextEditingController tFoodName = TextEditingController();
  TextEditingController tFoodDose = TextEditingController();
  TextEditingController tFoodCondition = TextEditingController();
  TextEditingController tFoodTime = TextEditingController();
  TextEditingController tFoodproperties = TextEditingController();
  TextEditingController tFoodnote = TextEditingController();
  TextEditingController tFooddoctor = TextEditingController();
  TextEditingController tFoodtimeHour = TextEditingController();
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
          textField1('ชื่ออาหาร', controller: tFoodName),
          const SizedBox(height: 10),
          textField1('วิธีให้', controller: tFoodDose),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tFoodproperties),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tFoodnote),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งอาหาร', controller: tFooddoctor),
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
