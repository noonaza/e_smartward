// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CreateFoodDialog extends StatefulWidget {
  Map<String, String> headers;
  final Function(ListDataCardModel) onAddFood;

  CreateFoodDialog({
    Key? key,
    required this.headers,
    required this.onAddFood,
  }) : super(key: key);

  @override
  State<CreateFoodDialog> createState() => _CreateFoodDialogState();

  static void show(
    BuildContext context, {
    required Map<String, String> headers,
    required Function(ListDataCardModel) onAddFood,
    required double width,
  }) {
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
      body: CreateFoodDialog(
        headers: headers,
        onAddFood: onAddFood,
      ),
    ).show();
  }
}

class _CreateFoodDialogState extends State<CreateFoodDialog> {
  TextEditingController tFoodName = TextEditingController();
  TextEditingController tFoodDose = TextEditingController();
  TextEditingController tFoodCondition = TextEditingController();
  TextEditingController tFoodTime = TextEditingController();
  TextEditingController tFoodDescription = TextEditingController();
  TextEditingController tFoodRemark = TextEditingController();
  TextEditingController tFooddoctor = TextEditingController();
  TextEditingController tFoodtimeHour = TextEditingController();
  TextEditingController tFoodUnit = TextEditingController();
  TextEditingController tFoodQty = TextEditingController();
  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'กำหนดเอง',
  ];
  String selectedTimeSlot = '';
  List<String> selectedTakeTimes = [];

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
    final bool isEnabled = selectedTakeTimes.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 5),
          textField1('ชื่ออาหาร', controller: tFoodName),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: textField1('จำนวน', controller: tFoodQty),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1('วิธีให้', controller: tFoodDose),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1('หน่วย', controller: tFoodUnit),
              ),
            ],
          ),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tFoodDescription),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tFoodRemark),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งอาหาร', controller: tFooddoctor),
          const SizedBox(height: 15),
          TimeSelection(
            time: time,
            timeList: timeList,
            onSelectionChanged: (selectedIndex, selectedList) {
              setState(() {
                selectedTimeSlot = time[selectedIndex ?? 0];
                selectedTakeTimes = [];

                for (int i = 0; i < selectedList.length; i++) {
                  if (selectedList[i]) {
                    selectedTakeTimes.add(timeList[i]);
                  }
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child:  IgnorePointer(
              ignoring: !isEnabled,
              child: actionSlider(
              context,
              'ยืนยันการให้อาหารเพิ่มเติม',
              width: MediaQuery.of(context).size.width * 0.4,
              height: 30.0,
              backgroundColor: isEnabled
                    ? const Color.fromARGB(255, 203, 230, 252)
                    : Colors.grey[300]!,
                togglecolor: isEnabled
                    ? const Color.fromARGB(255, 76, 172, 175)
                    : Colors.grey,
              icons: Icons.check,
              iconColor: Colors.white,
              asController: ActionSliderController(),
              action: (controller) {
                final newFood = ListDataCardModel(
                  item_name: tFoodName.text,
                  dose_qty: double.parse(
                      tFoodDose.text.isEmpty ? '0' : tFoodDose.text),
                  unit_name: tFoodUnit.text,
                  drug_type_name: "อาหารสัตว์",
                  item_qty:
                      int.parse(tFoodQty.text.isEmpty ? '0' : tFoodQty.text),
                  start_date_use: DateFormat('yyyy-MM-dd').format(DateTime.now()),

                  drug_description: tFoodDescription.text,
                  remark: tFoodRemark.text,
                  doctor_eid: tFooddoctor.text,
                  take_time:
                      "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                  time_slot: selectedTimeSlot,
                );
                widget.onAddFood(newFood);
                Navigator.pop(context);
              },
            ),
          ),
          )
        ],
      ),
    );
  }
}
