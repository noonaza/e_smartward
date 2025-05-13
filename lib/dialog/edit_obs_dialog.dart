// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';

import '../Model/list_data_obs_model.dart';
import '../widget/text.dart';

class EditObsDialog extends StatefulWidget {
  final ListDataObsDetailModel Obs;
  final int indexObs;
  final Function(ListDataObsDetailModel updatedObs, int index_) cb;

  const EditObsDialog({
    Key? key,
    required this.Obs,
    required this.indexObs,
    required this.cb,
  }) : super(key: key);

  @override
  State<EditObsDialog> createState() => _EditDetailDialogState();

  static void show(
    BuildContext context,
    ListDataObsDetailModel Obs,
    int index_,
    Function(ListDataObsDetailModel updatedObs, int index_) cb_,
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
      body: EditObsDialog(
        Obs: Obs,
        indexObs: index_,
        cb: cb_,
      ),
    ).show();
  }
}

class _EditDetailDialogState extends State<EditObsDialog> {
  TextEditingController tObsName = TextEditingController();
  TextEditingController tObsNote = TextEditingController();
  TextEditingController ttimeHour = TextEditingController();

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
  List<String> setValue = [
    'obs',
    'col',
  ];
  Map<String, bool> selectedValues = {
    'obs': false,
    'col': false,
  };
  String selectedValue = '';
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

    tObsName.text = widget.Obs.set_name ?? '';
    tObsNote.text = widget.Obs.remark ?? '';

    // ดึงข้อมูล set_value มาถอด JSON
    if (widget.Obs.set_value != null) {
      final decoded = jsonDecode(widget.Obs.set_value!);
      if (decoded['obs'] == 1) {
        selectedValues.updateAll((key, value) => false);
        selectedValues['obs'] = true;
        selectedValue = 'obs';
      } else if (decoded['col'] == 1) {
        selectedValues.updateAll((key, value) => false);
        selectedValues['col'] = true;
        selectedValue = 'col';
      }
      selectedTimeSlot = decoded['time_slot'] ?? '';
    }

    // ถ้ามี take_time ให้แยกเวลาเป็น list
    if (widget.Obs.take_time != null) {
      final cleaned = widget.Obs.take_time!
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll("'", '')
          .split(',');
      selectedTakeTimes = cleaned.map((e) => e.trim()).toList();
      for (int i = 0; i < timeList.length; i++) {
        selectedTimeList[i] = selectedTakeTimes.contains(timeList[i]);
      }
    }
  }

  @override
  void dispose() {
    tObsName.dispose();
    tObsNote.dispose();
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
          textField1('อาการ', controller: tObsName),
          const SizedBox(height: 10),
          textField1('หมายเหตุ', controller: tObsNote),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                  spacing: 8.0,
                  children: setValue.map((key) {
                    return ChoiceChip(
                      label: text(
                        context,
                        key,
                        color:
                            selectedValues[key]! ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                      selected: selectedValues[key]!,
                      selectedColor: Color.fromARGB(255, 4, 138, 161),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selectedValues[key]!
                              ? Colors.grey
                              : Colors.teal.shade200,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      onSelected: (selected) {
                        setState(() {
                          selectedValues.updateAll((key, value) => false);
                          selectedValues[key] = selected;
                          selectedValue = key;
                        });
                      },
                    );
                  }).toList()),
            ],
          ),
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
                'ยืนยันการส่งสังเกตอาการเพิ่มเติม',
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
                  final setValueMap = {
                    "obs": selectedValue == 'obs' ? 1 : 0,
                    "col": selectedValue == 'col' ? 1 : 0,
                    "time_slot": selectedTimeSlot,
                    "delete": 0,
                  };
                  final updatedObs = ListDataObsDetailModel(
                    set_name: tObsName.text,
                    set_value: jsonEncode(setValueMap),
                    remark: tObsNote.text,
                    take_time:
                        "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                  );
                  widget.cb(updatedObs, widget.indexObs);
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
