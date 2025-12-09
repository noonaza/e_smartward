// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
import 'package:e_smartward/widget/text.dart';
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
  ScheduleMode _scheduleMode = ScheduleMode.weeklyOnce; // ค่าเริ่มต้นที่ต้องการ
  ScheduleResult? _schedule; // ถ้าอยากเก็บรายละเอียดอื่น ๆ จากตัวเลือก
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
  List<String> setDay = [
    'สัปดาห์ละครั้ง',
    'กำหนดรายวัน',
    'กำหนดรายเดือน',
    'ไม่กำหนด'
  ];
  Map<String, bool> selectedDay = {
    'สัปดาห์ละครั้ง': false,
    'กำหนดรายวัน': false,
    'กำหนดรายเดือน': false,
    'ไม่กำหนด': false
  };

  final Map<String, bool> selectedWeekdays = {
    'จันทร์': false,
    'อังคาร': false,
    'พุธ': false,
    'พฤหัสบดี': false,
    'ศุกร์': false,
    'เสาร์': false,
    'อาทิตย์': false,
  };
  String _typeSlotFromMode(ScheduleMode m) {
    switch (m) {
      case ScheduleMode.weeklyOnce:
        return 'DAYS';
      case ScheduleMode.dailyCustom:
        return 'DATE';
      case ScheduleMode.monthlyCustom:
        return 'D_M';
      case ScheduleMode.all:
        return 'ALL';
    }
  }

  String labelFromTypeSlot(String? t) {
    switch (t) {
      case 'weekly_once':
        return 'สัปดาห์ละครั้ง';
      case 'daily_custom':
        return 'กำหนดรายวัน';
      case 'monthly_custom':
        return 'กำหนดรายเดือน';
      case 'all':
        return 'ไม่กำหนด';
      default:
        return '-';
    }
  }

  Map<String, bool> selectStatus = {
    'ให้อาหารทันที': false,
  };
  List<String> setValueStatus = [
    'ให้อาหารทันที',
  ];

  List<String> setValue = [
    'วางให้ทาน',
    'ปั่น',
    'แช่น้ำอุ่น',
    'สอดท่อกรองอาหาร',
    'ชั่งน้ำหนักอาหาร',
  ];
  Map<String, bool> selectedValues = {
    'วางให้ทาน': false,
    'ปั่น': false,
    'แช่น้ำอุ่น': false,
    'สอดท่อกรองอาหาร': false,
    'ชั่งน้ำหนักอาหาร': false,
  };

  String selectedTimeSlot = '';
  List<String> selectedTakeTimes = [];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });
  String encodeTakeTime({
    required List<bool> selectedTimeList,
    required List<String> timeList,
  }) {
    final times = <String>[];
    for (int i = 0; i < timeList.length; i++) {
      if (selectedTimeList[i]) times.add(timeList[i]);
    }
    if (times.isEmpty) return '[]';
    return "[${times.map((e) => "'$e'").join(',')}]";
  }

  String resolveTimeSlot({
    required List<bool> selected,
    required List<String> time,
    required String customNote,
  }) {
    final idx = selected.indexWhere((v) => v == true);
    if (idx < 0) return '';
    final label = time[idx];
    if (label == 'กำหนดเอง') return customNote.trim();
    return label;
  }

  void checkIsEnablede() {
    final ok = (tFoodName.text.trim().isNotEmpty) &&
        ((int.tryParse(tFoodQty.text) ?? 0) >= 0) &&
        (tFoodUnit.text.trim().isNotEmpty);
    if (ok != isEnabled) {
      setState(() => isEnabled = ok);
    }
  }

  bool _isScheduleDetailValid() {
    switch (_scheduleMode) {
      case ScheduleMode.weeklyOnce:
        return _schedule!.weekdayNames.isNotEmpty;

      case ScheduleMode.dailyCustom:
        // ต้องมี note/ค่า custom สำหรับรายวัน
        return (_schedule!.dailyNote?.trim().isNotEmpty ?? false);

      case ScheduleMode.monthlyCustom:
        // ต้องมีวันของเดือนอย่างน้อย 1
        return _schedule!.monthlyDays.isNotEmpty;
      case ScheduleMode.all:
        return _schedule!.monthlyDays.isNotEmpty;
    }
  }

  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;
  bool isEnabled = false;

  List<DoctorModel> doctorList = [];

  List<DropdownMenuItem<DoctorModel>> drugItems = [];

  DoctorModel? selectedDoctor;

  List<DoctorModel> ListDoctors = [];

  final List<String> prepOptions = [
    'วางให้ทาน',
    'ปั่น',
    'แช่น้ำอุ่น',
    'สอดท่อกรองอาหาร',
    'ชั่งน้ำหนักอาหาร',
  ];

  // void _initPrepFromFeed(String? feed) {
  //   selectedPrep = {
  //     for (final v in prepOptions) v: false,
  //   };

  //   if (feed == null || feed.trim().isEmpty) return;

  //   final parts =
  //       feed.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);

  //   for (final label in parts) {
  //     if (selectedPrep.containsKey(label)) {
  //       selectedPrep[label] = true;
  //     }
  //   }
  // }

  late Map<String, bool> selectedPrep;

  @override
  void initState() {
    super.initState();

    tFoodName.addListener(checkIsEnabled);
    tFoodQty.addListener(checkIsEnabled);
    tFoodUnitQty.addListener(checkIsEnabled);
    tFoodDose.addListener(checkIsEnabled);
    tFoodUnit.addListener(checkIsEnabled);
    tFoodRemark.addListener(checkIsEnabled);
    // tFooddoctor.addListener(checkIsEnabled);
    selected = List.generate(time.length, (index) => false);
    selectedTimeList = List.generate(timeList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final result = _schedule;

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
          textField1('หมายเหตุอื่นๆ', controller: tFoodRemark),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                        onSelected: (selected) {
                          setState(() {
                            selectedValues[key] = selected;
                          });
                          checkIsEnabled();
                        });
                  }).toList()),
            ],
          ),
          const SizedBox(height: 15),
          SchedulePicker(
            allowAll: false,
            key: const ValueKey('create_sched'),
            initialMode: _scheduleMode,
            initialWeeklySelectedNames: result?.weekdayNames.isNotEmpty == true
                ? result!.weekdayNames
                : const {},
            initialDailyNote: result?.dailyNote,
            initialMonthlyDate: result?.monthlyDate,
            initialMonthlyDays: result?.monthlyDays ?? const <int>{},
            onChanged: (cfg) {
              setState(() {
                _scheduleMode = cfg.mode;
                _schedule = cfg;
              });
              checkIsEnabled();
            },
          ),

          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Wrap(
                spacing: 8.0,
                children: setValueStatus.map((key) {
                  final isSelected = selectStatus[key] ?? false;

                  return ChoiceChip(
                    label: text(
                      context,
                      key,
                      color: isSelected ? Colors.white : Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                    selected: isSelected,
                    selectedColor: const Color.fromARGB(255, 4, 138, 161),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.teal : Colors.teal.shade200,
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    onSelected: (selected) {
                      setState(() {
                        selectStatus.updateAll((key, value) => false);
                        selectStatus[key] = selected;
                      });
                      checkIsEnabled();
                    },
                  );
                }).toList(),
              ),
            ],
          ),
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
                  final typeSlot = _typeSlotFromMode(_scheduleMode);
                  if (widget.screen == 'roundward') {
                    String status = '0';

                    if (selectStatus['ให้อาหารทันที'] == true) {
                      status = '1';
                    }

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
                      use_now: status,
                      set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                      type_slot: _typeSlotFromMode(_scheduleMode),
                      start_date_imed:
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      remark: tFoodRemark.text,
                      schedule_mode_label:
                          _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                      //  doctor_eid: selectedDoctor?.employee_id,
                      unit_stock: tFoodUnitQty.text,
                      meal_take: selectedValues.entries
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
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      start_date_imed:
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      drug_description: tFoodDescription.text,
                      remark: tFoodRemark.text,
                      unit_stock: tFoodUnitQty.text,
                      set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                      type_slot: _typeSlotFromMode(_scheduleMode),
                      schedule_mode_label:
                          _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                      meal_take: selectedValues.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .join(','),

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

  void checkIsEnabled() {
    final hasBasics = tFoodName.text.trim().isNotEmpty &&
        tFoodQty.text.trim().isNotEmpty &&
        tFoodUnitQty.text.trim().isNotEmpty &&
        tFoodDose.text.trim().isNotEmpty &&
        tFoodUnit.text.trim().isNotEmpty &&
        (selectedTimeSlot.isNotEmpty &&
            (selectedTimeSlot == 'เมื่อมีอาการ' ||
                selectedTakeTimes.isNotEmpty));
    selectedTakeTimes.isNotEmpty;

    final scheduleOk = _isScheduleDetailValid();
    final timeOk = _isTimeOk();

    final ok = hasBasics && scheduleOk && timeOk;

    if (ok != isEnabled) {
      setState(() => isEnabled = ok);
    }
  }

  bool _isTimeOk() {
    if (selectedTimeSlot.isEmpty) return false;
    if (selectedTimeSlot == 'เมื่อมีอาการ') return true;
    return selectedTakeTimes.isNotEmpty;
  }
}
