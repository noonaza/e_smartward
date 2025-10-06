// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';

// ignore: must_be_immutable
class CreateFoodDialog extends StatefulWidget {
  Map<String, String> headers;
  final Function(ListDataCardModel) onAddFood;
  String screen;
  Function() rwAddFood;
  final List<ListUserModel>? lUserLogin;
  final List<ListPetModel>? lPetAdmit;
  final List<ListAnModel>? lListAn;
  final String? drugTypeName;

  CreateFoodDialog({
    super.key,
    required this.headers,
    required this.onAddFood,
    required this.screen,
    required this.rwAddFood,
    this.lUserLogin,
    this.lPetAdmit,
    this.lListAn,
    this.drugTypeName,
  });

  @override
  State<CreateFoodDialog> createState() => _CreateFoodDialogState();

  static void show(
    BuildContext context, {
    required String screen,
    required Map<String, String> headers,
    required Function(ListDataCardModel) onAddFood,
    List<ListUserModel>? lUserLogin,
    List<ListPetModel>? lPetAdmit,
    required Function() rwAddFood_,
    List<ListAnModel>? lListAn,
    double? width,
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
        screen: screen,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn,
        rwAddFood: rwAddFood_,
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
  TextEditingController tFoodUnitQty = TextEditingController();
  TextEditingController tSearchDoctor = TextEditingController();
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
  bool isEnabled = false;

  List<DoctorModel> doctorList = [];

  List<DropdownMenuItem<DoctorModel>> drugItems = [];

  DoctorModel? selectedDoctor;

  List<DoctorModel> ListDoctors = [];

  void checkIsEnabled() {
    setState(() {
      isEnabled = tFoodName.text.trim().isNotEmpty &&
          tFoodQty.text.trim().isNotEmpty &&
          tFoodUnitQty.text.trim().isNotEmpty &&
          tFoodDose.text.trim().isNotEmpty &&
          tFoodRemark.text.trim().isNotEmpty &&
          // selectedDoctor != null &&
          tFoodUnit.text.trim().isNotEmpty &&
          // tFooddoctor.text.trim().isNotEmpty &&
          (selectedTimeSlot.isNotEmpty &&
              (selectedTimeSlot == 'เมื่อมีอาการ' ||
                  selectedTakeTimes.isNotEmpty));
    });
  }

  @override
  void initState() {
    super.initState();
    //  initDoctors();

    tFoodName.addListener(checkIsEnabled);
    tFoodQty.addListener(checkIsEnabled);
    tFoodUnitQty.addListener(checkIsEnabled);
    tFoodDose.addListener(checkIsEnabled);
    tFoodUnit.addListener(checkIsEnabled);
    tFoodRemark.addListener(checkIsEnabled);
    // tFooddoctor.addListener(checkIsEnabled);
    selected = List.generate(time.length, (index) => false);
    selectedTimeList = List.generate(timeList.length, (index) => false);

    // setState(() {
    //   drugItems = ListDoctors.map((doctor) {
    //     return DropdownMenuItem<DoctorModel>(
    //       value: doctor,
    //       child: Text(
    //         '${doctor.employee_id}  ${doctor.full_nameth}',
    //         style: const TextStyle(fontSize: 12),
    //       ),
    //     );
    //   }).toList();
    // });
  }

  // void initDoctors() async {
  //   List<DoctorModel> result =
  //       await AdmitApi().loadDataDoctor(context, headers_: widget.headers);

  //   setState(() {
  //     ListDoctors = result;

  //     drugItems = ListDoctors.map((doctor) {
  //       return DropdownMenuItem<DoctorModel>(
  //         value: doctor,
  //         child: Text(
  //           '${doctor.prename} ${doctor.full_nameth}',
  //           style: const TextStyle(fontSize: 12),
  //         ),
  //       );
  //     }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final bool isEnabled = (selectedTimeSlot.isNotEmpty &&
    //     (selectedTimeSlot == 'เมื่อมีอาการ' || selectedTakeTimes.isNotEmpty));
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
          textField1('สรรพคุณ', controller: tFoodDescription),
          const SizedBox(height: 10),
          textField1('วิธีเตรียมอาหาร / หมายเหตุอื่นๆ',
              controller: tFoodRemark),
          const SizedBox(height: 15),
          // SizedBox(
          //   height: 35,
          //   child: Dropdown.lModel<DoctorModel>(
          //     context: context,
          //     value: selectedDoctor,
          //     items: drugItems,
          //     tController: tSearchDoctor,
          //     isSelect: true,
          //     validator: '',
          //     width: double.infinity,
          //     onChanged: (value) {
          //       setState(() {
          //         selectedDoctor = value;
          //         checkIsEnabled();
          //       });
          //     },
          //     hintLabel: 'เลือกชื่อแพทย์ที่ทำการสั่งยา',
          //     labelInSearch: 'ค้นหาชื่อหรือรหัสแพทย์',
          //   ),
          // ),
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
                checkIsEnabled();
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
                action: (controller) async {
                  if (widget.screen == 'roundward') {
                    final newFood = DataAddOrderModel(
                      item_name: tFoodName.text,
                      type_card: 'Food',
                      dose_qty: tFoodDose.text,
                      unit_name: tFoodUnit.text,
                      item_qty: tFoodQty.text,
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      drug_type_name: "อาหารสัตว์",
                      drug_description: tFoodDescription.text,
                      stock_out: 0,
                      remark: tFoodRemark.text,
                      //  doctor_eid: selectedDoctor?.employee_id,
                      unit_stock: tFoodUnitQty.text,
                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                    );

                    await RoundWardApi().AddOrder(
                      context,
                      headers_: widget.headers,
                      mUser: widget.lUserLogin!.first,
                      mPetAdmit_: widget.lPetAdmit!.first,
                      lDataOrder_: [newFood],
                      mListAn_: widget.lListAn!.first,
                    );
                    await widget.rwAddFood();
                    Navigator.of(context).pop();
                  } else {
                    final newFood = ListDataCardModel(
                      item_name: tFoodName.text,
                      dose_qty: tFoodDose.text,
                      dose_qty_name: tFoodDose.text,

                      // double.parse(
                      //     tFoodDose.text.isEmpty ? '0' : tFoodDose.text),
                      unit_name: tFoodUnit.text,
                      drug_type_name: "อาหารสัตว์",
                      stock_out: 0,
                      item_qty: int.parse(
                          tFoodQty.text.isEmpty ? '0' : tFoodQty.text),
                      start_date_use:
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      drug_description: tFoodDescription.text,
                      remark: tFoodRemark.text,
                      unit_stock: tFoodUnitQty.text,
                      //  doctor_eid: selectedDoctor?.full_nameth ?? '',
                      take_time:
                          "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                    );
                    widget.onAddFood(newFood);
                    widget.rwAddFood();
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
}
