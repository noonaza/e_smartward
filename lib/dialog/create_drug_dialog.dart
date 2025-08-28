// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/search_dropdown.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';

// ignore: must_be_immutable
class CreateDrugDialog extends StatefulWidget {
  final String screen;
  final Map<String, String> headers;
  final Function(ListDataCardModel) onAddDrug;
  Function() rwAddDrug;
  final List<ListUserModel>? lUserLogin;
  final List<ListPetModel>? lPetAdmit;
  final List<ListAnModel>? lListAn;
  final String? drugTypeName;

  CreateDrugDialog({
    Key? key,
    required this.screen,
    required this.headers,
    required this.onAddDrug,
    required this.rwAddDrug,
    this.lUserLogin,
    this.lPetAdmit,
    this.lListAn,
    this.drugTypeName,
  }) : super(key: key);

  @override
  State<CreateDrugDialog> createState() => _CreateDrugDialogState();

  static void show(
    BuildContext context, {
    required String screen,
    required Map<String, String> headers,
    required Function(ListDataCardModel) onAddDrug_,
    required Function() rwAddDrug_,
    List<ListUserModel>? lUserLogin,
    List<ListPetModel>? lPetAdmit,
    List<ListAnModel>? lListAn,
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
            'assets/gif/medicin.gif',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      body: CreateDrugDialog(
        screen: screen,
        headers: headers,
        onAddDrug: onAddDrug_,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn,
        rwAddDrug: rwAddDrug_,
      ),
    ).show();
  }
}

class _CreateDrugDialogState extends State<CreateDrugDialog> {
  TextEditingController tDrudName = TextEditingController();
  TextEditingController tDrugDose = TextEditingController();
  TextEditingController tDrugCondition = TextEditingController();
  TextEditingController tDrugTime = TextEditingController();
  TextEditingController tDrugDescription = TextEditingController();
  TextEditingController tDrugRemark = TextEditingController();
  TextEditingController tDrugDoc = TextEditingController();
  TextEditingController tDrugUnit = TextEditingController();
  TextEditingController tDrugQty = TextEditingController();
  TextEditingController tDrugUnitQty = TextEditingController();

  TextEditingController tSearchDoctor = TextEditingController();
  List<String> typeDrug = [
    '[T]ยาเม็ด',
    '[L]ยาหยอด',
    '[I]ยาฉีด',
    '[S]ยาน้ำ',
    '[E]ยาใช้ภายนอก',
  ];
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
    'ก่อนอาหาร',
    'หลังอาหาร',
    'ไม่ระบุ',
  ];
  Map<String, bool> selectedValues = {
    'ก่อนอาหาร': false,
    'หลังอาหาร': false,
    'ไม่ระบุ': false,
  };
  String selectedTimeSlot = '';
  List<String> selectedTakeTimes = [];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });
  bool isEnabled = false;

  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;

  List<DoctorModel> doctorList = [];

  List<DropdownMenuItem<DoctorModel>> drugItems = [];
  DoctorModel? selectedDoctor;
  List<DoctorModel> ListDoctors = [];

  @override
  void initState() {
    super.initState();
    initDoctors();

    if (widget.drugTypeName == 'ยาเม็ด') {
      selectedTypeDrug = '[T]ยาเม็ด';
    } else if (widget.drugTypeName == 'ยาฉีด') {
      selectedTypeDrug = '[I]ยาฉีด';
    } else if (widget.drugTypeName == 'ยาน้ำ') {
      selectedTypeDrug = '[S]ยาน้ำ';
    } else if (widget.drugTypeName == 'ยาหยอด') {
      selectedTypeDrug = '[L]ยาหยอด';
    } else if (widget.drugTypeName == 'ยาใช้ภายนอก') {
      selectedTypeDrug = '[E]ยาใช้ภายนอก';
    }

    tDrudName.addListener(checkIsEnabled);
    tDrugQty.addListener(checkIsEnabled);
    tDrugUnitQty.addListener(checkIsEnabled);
    tDrugDose.addListener(checkIsEnabled);
    tDrugUnit.addListener(checkIsEnabled);
    tDrugDescription.addListener(checkIsEnabled);
    tDrugRemark.addListener(checkIsEnabled);

    selectedTimeList = List.generate(timeList.length, (index) => false);
    selected = List.generate(time.length, (index) => false);

    tDrugUnit.addListener(() {
      tDrugUnitQty.text = tDrugUnit.text;
    });
  }

  void initDoctors() async {
    List<DoctorModel> result =
        await AdmitApi().loadDataDoctor(context, headers_: widget.headers);

    setState(() {
      ListDoctors = result;

      drugItems = ListDoctors.map((doctor) {
        return DropdownMenuItem<DoctorModel>(
          value: doctor,
          child: Text(
            '${doctor.prename} ${doctor.full_nameth}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList();
    });
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
          Row(
            children: [
              Expanded(
                flex: 1,
                child: textField1(
                  'จำนวนเบิก',
                  controller: tDrugQty,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: IgnorePointer(
                  child: textField1(
                    'หน่วยเบิก',
                    controller: tDrugUnitQty,
                    initialValue: tDrugUnit.text,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1(
                  'วิธีให้',
                  controller: tDrugDose,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9./]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = newValue.text;
                      final fractionRegExp = RegExp(r'^\d*\/?\d*$');
                      final decimalRegExp = RegExp(r'^\d*\.?\d*$');

                      if (fractionRegExp.hasMatch(text) ||
                          decimalRegExp.hasMatch(text) ||
                          text.isEmpty) {
                        return newValue;
                      }

                      return oldValue;
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1('หน่วยให้', controller: tDrugUnit),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              value: selectedTypeDrug,
              decoration: InputDecoration(
                labelText: 'ประเภทยา',
                labelStyle: const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
              ),
              isDense: true,
              onChanged: widget.screen == 'roundward'
                  ? null
                  : (newValue) {
                      setState(() {
                        selectedTypeDrug = newValue;
                      });
                      checkIsEnabled();
                    },
              items: typeDrug.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: text(context, type, color: Colors.teal),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tDrugDescription),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tDrugRemark),
          const SizedBox(height: 15),
          SizedBox(
            height: 35,
            child: Dropdown.lModel<DoctorModel>(
              context: context,
              value: selectedDoctor,
              items: drugItems,
              tController: tSearchDoctor,
              isSelect: true,
              validator: '',
              width: double.infinity,
              onChanged: (value) {
                setState(() {
                  selectedDoctor = value;
                  checkIsEnabled();
                });
              },
              hintLabel: 'เลือกชื่อแพทย์ที่ทำการสั่งยา',
              labelInSearch: 'ค้นหาชื่อหรือรหัสแพทย์',
            ),
          ),
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
                        checkIsEnabled();
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
              checkIsEnabled();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IgnorePointer(
              ignoring: !isEnabled,
              child: actionSlider(
                context,
                'ยืนยันการให้ยาเพิ่มเติม',
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
                action: (controller) async {
                  if (widget.screen == 'roundward') {
                    final newDrug = DataAddOrderModel(
                      item_name: tDrudName.text,
                      type_card: 'Drug',
                      dose_qty: tDrugDose.text,
                      unit_name: tDrugUnit.text,
                      item_qty: tDrugQty.text,
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      drug_type_name: selectedTypeDrug,
                      drug_description: tDrugDescription.text,
                      stock_out: 0,
                      remark: tDrugRemark.text,
                      doctor_eid: selectedDoctor?.employee_id,
                      unit_stock: tDrugUnitQty.text,
                      meal_timing: selectedValues.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .join(','),
                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                    );

                    await RoundWardApi().AddOrder(
                      context,
                      headers_: widget.headers,
                      mUser: widget.lUserLogin!.first,
                      mPetAdmit_: widget.lPetAdmit!.first,
                      lDataOrder_: [newDrug],
                      mListAn_: widget.lListAn!.first,
                    );
                    await widget.rwAddDrug();
                    Navigator.of(context).pop();
                  } else {
                    final newDrug = ListDataCardModel(
                      item_name: tDrudName.text,
                      dose_qty: tDrugDose.text,
                      dose_qty_name: tDrugDose.text,
                      // double.parse(
                      //     tDrugDose.text.isEmpty ? '0' : tDrugDose.text),
                      unit_name: tDrugUnit.text,
                      item_qty: int.tryParse(tDrugQty.text) ?? 0,
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      drug_type_name: selectedTypeDrug,
                      drug_description: tDrugDescription.text,
                      stock_out: 0,
                      remark: tDrugRemark.text,
                      doctor_eid: selectedDoctor?.employee_id,
                      unit_stock: tDrugUnitQty.text,
                      meal_timing: selectedValues.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .join(','),
                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                    );

                    widget.onAddDrug(newDrug);
                    widget.rwAddDrug();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void checkIsEnabled() {
    setState(() {
      isEnabled = tDrudName.text.trim().isNotEmpty &&
          tDrugQty.text.trim().isNotEmpty &&
          tDrugUnitQty.text.trim().isNotEmpty &&
          tDrugDose.text.trim().isNotEmpty &&
          tDrugUnit.text.trim().isNotEmpty &&
          selectedTypeDrug != null &&
          selectedDoctor != null &&
          // tDrugDoc.text.trim().isNotEmpty &&
          selectedValues.containsValue(true) &&
          (selectedTimeSlot.isNotEmpty &&
              (selectedTimeSlot == 'เมื่อมีอาการ' ||
                  selectedTakeTimes.isNotEmpty));
    });
  }
}
