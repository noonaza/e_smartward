// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';

import '../Model/list_data_obs_model.dart';
import '../widget/text.dart';

// ignore: must_be_immutable
class CreateObsDialog extends StatefulWidget {
  Map<String, String> headers;
  final Function(ListDataObsDetailModel) onAddObs;
  String screen;
  final List<ListUserModel>? lUserLogin;
  final List<ListPetModel>? lPetAdmit;
  Function() rwAddObs;
  final List<ListAnModel>? lListAn;
  final String? drugTypeName;
  CreateObsDialog({
    Key? key,
    required this.headers,
    required this.onAddObs,
    required this.screen,
    this.lUserLogin,
    this.lPetAdmit,
    required this.rwAddObs,
    this.lListAn,
    this.drugTypeName,
  }) : super(key: key);

  @override
  State<CreateObsDialog> createState() => _CreateObsDialogState();

  static void show(
    BuildContext context, {
    required String screen,
    required Map<String, String> headers,
    required Function(ListDataObsDetailModel) onAddObs,
    double? width,
    List<ListUserModel>? lUserLogin,
    List<ListPetModel>? lPetAdmit,
    List<ListAnModel>? lListAn,
    required Function() rwAddObs_,
    String? drugTypeName,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth;

    if (screenWidth >= 1024) {
      dialogWidth = screenWidth * 0.5; // Desktop
    } else if (screenWidth >= 600) {
      dialogWidth = screenWidth * 0.9; // Tablet
    } else {
      dialogWidth = screenWidth * 0.9; // Mobile
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: dialogWidth,
      dismissOnTouchOutside: false,
      customHeader: Stack(
        children: [
          Image.asset(
            'assets/gif/index3.gif',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      body: CreateObsDialog(
        screen: screen,
        headers: headers,
        onAddObs: onAddObs,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn, rwAddObs: rwAddObs_,
      ),
    ).show();
  }
}

class _CreateObsDialogState extends State<CreateObsDialog> {
  TextEditingController tobsName = TextEditingController();
  TextEditingController tobsnote = TextEditingController();
  TextEditingController tFoodtimeHour = TextEditingController();
  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'ทุกๆ 6 ชม.',
    'ทุกๆ 8 ชม.',
    'กำหนดเอง',
    'เมื่อมีอาการ'
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
  }

  @override
  Widget build(BuildContext context) {
    // final bool isEnabled =
    //     selectedTakeTimes.isNotEmpty || selectedTimeSlot == 'เมื่อมีอาการ';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 5),
          textField1('คำสั่งพิเศษ', controller: tobsName),
          const SizedBox(height: 10),
          textField1('หมายเหตุ', controller: tobsnote),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                  spacing: 8.0,
                  children: setValue.map((key) {
                    final isSelected = selectedValues[key] ?? false;
                    return ChoiceChip(
                      label: text(
                        context,
                        key,
                        color: isSelected ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                      selected: isSelected,
                      selectedColor: Color.fromARGB(255, 4, 138, 161),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              isSelected ? Colors.teal : Colors.teal.shade200,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                      onSelected: (selected) {
                        setState(() {
                          selectedValues.updateAll((key, value) => false);

                          selectedValues[key] = selected;
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
            child: actionSlider(
              context,
              'ยืนยันการส่งสังเกตอาการเพิ่มเติม',
              width: MediaQuery.of(context).size.width * 0.4,
              height: 30.0,
              backgroundColor: const Color.fromARGB(255, 203, 230, 252),
              togglecolor: const Color.fromARGB(255, 76, 172, 175),
              icons: Icons.check,
              iconColor: Colors.white,
              asController: ActionSliderController(),
              action: (controller) async {
                if (widget.screen == 'roundward') {
                  final setValueMap = {
                    for (var entry in selectedValues.entries)
                      entry.key: entry.value ? 1 : 0,
                    "time_slot": selectedTimeSlot,
                    "delete": 0,
                  };
                  final newFood = DataAddOrderModel(
                    item_name: tobsName.text,
                    type_card: 'Observe',
                    drug_type_name: "OBS",
                    remark: tobsnote.text,
                    take_time:
                        "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                    drug_instruction: jsonEncode(setValueMap),
                    start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
         
                  );

                  await RoundWardApi().AddOrder(
                    context,
                    headers_: widget.headers,
                    mUser: widget.lUserLogin!.first,
                    mPetAdmit_: widget.lPetAdmit!.first,
                    lDataOrder_: [newFood],
                    mListAn_: widget.lListAn!.first,
                  );
                   await widget.rwAddObs();
                    Navigator.of(context).pop();
                } else {
                  final setValueMap = {
                    for (var entry in selectedValues.entries)
                      entry.key: entry.value ? 1 : 0,
                    "time_slot": selectedTimeSlot,
                    "delete": 0,
                  };

                  final newObs = ListDataObsDetailModel(
                      set_name: tobsName.text,
                      set_value: jsonEncode(setValueMap),
                      remark: tobsnote.text,
                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]");
                  widget.onAddObs(newObs);
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
