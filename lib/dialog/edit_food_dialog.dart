// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_group_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_roundward_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/Model/update_order_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/search_dropdown.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';

// ignore: must_be_immutable
class EditFoodDialog extends StatefulWidget {
  final ListDataCardModel food;
  String screen;
  final int indexFood;
  Map<String, String> headers;
  final List<ListUserModel>? lUserLogin;
  final Function(ListDataCardModel updatedFood, int index_) cb;
  final ListGroupModel? group;
  final void Function(List<ListRoundwardModel>, bool)? onRefresh;
  final ListRoundwardModel? mData;
  final List<ListPetModel>? lPetAdmit;
  final String? drugTypeName;
  final List<ListAnModel>? lListAn;

  EditFoodDialog({
    Key? key,
    required this.food,
    required this.screen,
    required this.indexFood,
    required this.headers,
    this.lUserLogin,
    required this.cb,
    this.group,
    this.onRefresh,
    this.mData,
    this.lPetAdmit,
    this.drugTypeName,
    this.lListAn,
  }) : super(key: key);

  @override
  State<EditFoodDialog> createState() => _EditFoodDialogState();

  static Future<void> showEditFoodDialog(
    BuildContext context,
    ListDataCardModel food,
    int index_,
    Function(ListDataCardModel updatedFood, int index_) cb_,
    Map<String, String> headers, {
    required String screen,
    List<ListUserModel>? lUserLogin,
    List<ListPetModel>? lPetAdmit,
    List<ListAnModel>? lListAn,
    String? drugTypeName,
    ListRoundwardModel? mData,
    ListGroupModel? group,
    void Function(List<ListRoundwardModel>, bool)? onRefresh,
  }) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth;

    if (screenWidth >= 1024) {
      dialogWidth = screenWidth * 0.5;
    } else if (screenWidth >= 680) {
      dialogWidth = screenWidth * 0.8;
    } else {
      dialogWidth = screenWidth * 0.9;
    }

    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: dialogWidth,
      dismissOnTouchOutside: false,
      body: Builder(
        builder: (dialogContext) => EditFoodDialog(
          screen: screen,
          food: food,
          cb: cb_,
          headers: headers,
          drugTypeName: drugTypeName,
          lUserLogin: lUserLogin,
          lPetAdmit: lPetAdmit,
          lListAn: lListAn,
          mData: mData,
          group: group,
          indexFood: index_,
          onRefresh: (updatedData, hasNew) {
            onRefresh?.call(updatedData, hasNew);
           
          },
        ),
      ),
    );

    await dialog.show();
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
  TextEditingController tFoodUnitQty = TextEditingController();
  TextEditingController tSearchDoctor = TextEditingController();

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
    'ทุกๆ 6 ชม.',
    'ทุกๆ 8 ชม.',
    'กำหนดเอง',
    'เมื่อมีอาการ'
  ];
  List<DropdownMenuItem<DoctorModel>> FoodItems = [];

  DoctorModel? selectedDoctor;
  List<DoctorModel> ListDoctors = [];
  bool isEnabled = false;

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
    tFoodNote.text = widget.food.remark ?? '';
    tFoodQty.text = widget.food.item_qty?.toString() ?? '';
    tFoodUnit.text = widget.food.unit_name?.toString() ?? '';
    // tFoodDoctor.text = widget.food.doctor_eid ?? '';
    tFoodUnitQty.text = widget.food.unit_stock ?? '';
    selectedTypeDrug = widget.food.drug_type_name;

    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    if (widget.food.take_time != null) {
      final cleaned = widget.food.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .toList();
      selectedTakeTimes = cleaned;
    }
    selectedTimeSlot = widget.food.time_slot ?? 'กำหนดเอง';
    if (selectedTimeSlot.isEmpty) {
      selectedTimeSlot = 'กำหนดเอง';
    }

    final index = time.indexOf(selectedTimeSlot);
    if (index != -1) {
      selectedTimeIndex = index;
    }
    setupListeners();
    checkIsEnabled();
  }

  void setupListeners() {
    checkIsEnabled();
    tFoodName.addListener(checkIsEnabled);
    tFoodQty.addListener(checkIsEnabled);
    tFoodUnitQty.addListener(checkIsEnabled);
    tFoodDose.addListener(checkIsEnabled);
    tFoodUnit.addListener(checkIsEnabled);
    tFoodNote.addListener(checkIsEnabled);
  }

  @override
  void dispose() {
    tFoodName.dispose();
    tFoodDose.dispose();
    tFoodProperties.dispose();
    tFoodCondition.dispose();
    tFoodNote.dispose();
    tFoodQty.dispose();
    tFoodUnit.dispose();
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
          Row(
            children: [
              Expanded(
                flex: 1,
                child: textField1(
                  'จำนวน',
                  controller: tFoodQty,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1(
                  'หน่วยเบิก',
                  controller: tFoodUnitQty,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1(
                  'วิธีให้',
                  controller: tFoodDose,
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
                child: textField1('หน่วย', controller: tFoodUnit),
              ),
            ],
          ),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tFoodCondition),
          const SizedBox(height: 10),
          textField1('วิธีเตรียมอาหาร / หมายเหตุอื่นๆ', controller: tFoodNote),
          // const SizedBox(height: 15),
          // SizedBox(
          //   height: 35,
          //   child: Dropdown.lModel<DoctorModel>(
          //     context: context,
          //     value: selectedDoctor,
          //     items: FoodItems,
          //     tController: tSearchDoctor,
          //     isSelect: true,
          //     validator: '',
          //     width: double.infinity,
          //     onChanged: (value) {
          //       setState(() {
          //         selectedDoctor = value;
          //         checkIsEnabled();
          //         tFoodDoctor.text =
          //             '${value?.employee_id ?? ''} : ${value?.full_nameth ?? ''}';
          //       });
          //     },
          //     hintLabel: 'เลือกชื่อแพทย์ที่ทำการสั่งยา',
          //     labelInSearch: 'ค้นหาชื่อหรือรหัสแพทย์',
          //   ),
          // ),
          const SizedBox(height: 10),
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
              checkIsEnabled();
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
                action: (controller) async {
                  if (widget.screen == 'roundward') {
                    final data = ListDataCardModel(
                      item_name: tFoodName.text,
                      dose_qty: tFoodDose.text,

                      // double.tryParse(tFoodDose.text) ?? 0,
                      unit_name: tFoodUnit.text,
                      item_qty: int.tryParse(tFoodQty.text) ?? 0,
                      unit_stock: tFoodUnitQty.text,
                      drug_type_name: selectedTypeDrug,
                      drug_description: tFoodCondition.text,
                      remark: tFoodNote.text,
                      stock_out: 0,
                      // doctor_eid: selectedDoctor?.employee_id,
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                      order_item_id: widget.food.order_item_id,
                    );

                    final updatedDrug = UpdateOrderModel(
                      id: int.tryParse(widget.food.order_item_id ?? '') ?? 0,
                      item_name: data.item_name,
                      item_qty: data.item_qty,
                      unit_name: data.unit_name,
                      dose_qty: data.dose_qty,
                      meal_timing: data.meal_timing ?? '',
                      drug_instruction: data.drug_instruction ?? '',
                      take_time: data.take_time ?? '[]',
                      start_date_use: data.start_date_use ?? '',
                      end_date_use: data.end_date_use ?? '',
                      stock_out: data.stock_out,
                      remark: data.remark ?? '',
                      caution: data.caution ?? '',
                      drug_description: data.drug_description ?? '',
                      drug_type_name: data.drug_type_name ?? '',
                      time_slot: data.time_slot ?? '',
                      unit_stock: data.unit_stock ?? '',
                      status: data.status ?? 'Order',
                      tl_common_users_id: widget.lUserLogin?.first.id ?? 0,
                    );

                    await RoundWardApi().updateOrderData(
                      context: context,
                      headers_: widget.headers,
                      updatedDrug: updatedDrug,
                      mUser: widget.lUserLogin!.first,
                      mPetAdmit_: widget.lPetAdmit!.first,
                      mListAn_: widget.lListAn!.first,
                      mData_: widget.mData!,
                    );
                    final updatedData = await RoundWardApi().loadDataRoundWard(
                      context,
                      headers_: widget.headers,
                      mListAn_: widget.lListAn!.first,
                      mGroup_: widget.group!,
                    );

                    widget.onRefresh?.call(updatedData, false);
                  } else {
                    final updatedFood = ListDataCardModel(
                      item_name: tFoodName.text,
                      dose_qty: tFoodDose.text,
                      // double.tryParse(tFoodDose.text) ?? 0,
                      item_qty: int.tryParse(tFoodQty.text) ?? 0,
                      unit_name: tFoodUnit.text,
                      drug_type_name: "อาหารสัตว์",
                      stock_out: 0,
                      drug_description: tFoodCondition.text,
                      unit_stock: tFoodUnitQty.text,
                      order_item_id: widget.food.order_item_id,
                      //  doctor_eid: selectedDoctor?.employee_id,
                      order_eid: widget.food.order_eid,
                      item_code: widget.food.item_code,
                      order_date: widget.food.order_date,
                      order_time: widget.food.order_time,
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      remark: tFoodNote.text,

                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                    );

                    widget.cb(updatedFood, widget.indexFood);

                    Navigator.of(context).pop();
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
      isEnabled = tFoodName.text.trim().isNotEmpty &&
          tFoodQty.text.trim().isNotEmpty &&
          tFoodUnitQty.text.trim().isNotEmpty &&
          tFoodDose.text.trim().isNotEmpty &&
          tFoodNote.text.trim().isNotEmpty &&
          tFoodUnit.text.trim().isNotEmpty &&
          (selectedTimeSlot.isNotEmpty &&
              (selectedTimeSlot == 'เมื่อมีอาการ' ||
                  selectedTakeTimes.isNotEmpty));
    });
  }
}
