import 'package:action_slider/action_slider.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

class EditFoodDialog extends StatefulWidget {
  final ListDataCardModel food;
  final int indexFood;
  final Function(ListDataCardModel updatedFood, int index_) cb;

  const EditFoodDialog({
    super.key,
    required this.food,
    required this.indexFood,
    required this.cb,
  });

  @override
  State<EditFoodDialog> createState() => _EditFoodDialogState();

  static void show(
    BuildContext context,
    ListDataCardModel food,
    int index_,
    Function(ListDataCardModel updatedFood, int index_) cb_,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: MediaQuery.of(context).size.width * 0.5,
      dismissOnTouchOutside: false,
      customHeader: Image.asset(
        'assets/gif/medicin.gif',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
      body: EditFoodDialog(
        food: food,
        indexFood: index_,
        cb: cb_,
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
  TextEditingController tFoodQty = TextEditingController();
  TextEditingController tFoodUnit = TextEditingController();

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
  String selectedTimeSlot = '';
  List<String> selectedTakeTimes = [];
  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;

  @override
  void initState() {
    super.initState();
    tFoodName.text = widget.food.item_name ?? '';
    tFoodDose.text = widget.food.dose_qty?.toString() ?? '';
    tFoodCondition.text = widget.food.drug_description ?? '';
    tFoodNote.text = widget.food.note_to_team ?? '';
    tFoodQty.text = widget.food.item_qty?.toString() ?? '';
    tFoodUnit.text = widget.food.unit_name?.toString() ?? '';
    tFoodDoctor.text = widget.food.doctor_eid ?? '';
    tFoodProperties.text = widget.food.drug_description ?? '';
    selectedTypeDrug = widget.food.drug_type_name;
    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    // 👉 เวลา
    if (widget.food.take_time != null) {
      final cleaned = widget.food.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .toList();
      selectedTakeTimes = cleaned;
    }
    selectedTimeSlot = widget.food.time_slot ?? '';
    if (selectedTimeSlot.isNotEmpty) {
      final index = time.indexOf(selectedTimeSlot);
      if (index != -1) {
        selectedTimeIndex = index;
      }
    }
  }

  @override
  void dispose() {
    tFoodName.dispose();
    tFoodDose.dispose();
    tFoodProperties.dispose();
    tFoodCondition.dispose();
    tFoodNote.dispose();
    tFoodDoctor.dispose();
    tFoodQty.dispose();
    tFoodUnit.dispose();
    super.dispose();
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
          textField1('ชื่อยา', controller: tFoodName),
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
          textField1('สรรพคุณ', controller: tFoodCondition),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tFoodNote),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งยา', controller: tFoodDoctor),
          const SizedBox(height: 15),
          TimeSelection(
            time: time,
            timeList: timeList,
            initialTakeTimes: selectedTakeTimes,
            initialTimeSlot: selectedTimeSlot,
            onSelectionChanged: (selectedIndex, selectedList) {
              setState(() {
                selectedTimeIndex = selectedIndex;
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
            child: IgnorePointer(
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
                final updatedFood = ListDataCardModel(
                  item_name: tFoodName.text,
                  dose_qty: double.tryParse(tFoodDose.text) ?? 0,
                  item_qty: int.tryParse(tFoodQty.text) ?? 0,
                  unit_name: tFoodUnit.text,
                  drug_type_name: "อาหารสัตว์",
                  drug_description: tFoodCondition.text,
                  start_date_use: DateFormat('yyyy-MM-dd').format(DateTime.now()),

                  note_to_team: tFoodNote.text,
                  doctor_eid: tFoodDoctor.text,
                  take_time:
                      "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                  time_slot: selectedTimeSlot,
                );

                widget.cb(updatedFood, widget.indexFood);
                Navigator.of(context).pop();
              },
            ),
          ),
          )
        ],
      ),
    );
  }
}
