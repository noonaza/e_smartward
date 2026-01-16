// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
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
import '../widget/text.dart';

// ignore: must_be_immutable
class CreateObsDialogV2 extends StatefulWidget {
  Map<String, String> headers;
  final Function(GetObsModel) onAddObs;
  String screen;
  final List<ListUserModel>? lUserLogin;
  final List<ListPetModel>? lPetAdmit;
  Function() rwAddObs;
  final List<ListAnModel>? lListAn;
  final String? drugTypeName;
  CreateObsDialogV2({
    super.key,
    required this.headers,
    required this.onAddObs,
    required this.screen,
    this.lUserLogin,
    this.lPetAdmit,
    required this.rwAddObs,
    this.lListAn,
    this.drugTypeName,
  });

  @override
  State<CreateObsDialogV2> createState() => _CreateObsDialogState();

  static void show(
    BuildContext context, {
    required String screen,
    required Map<String, String> headers,
    required Function(GetObsModel) onAddObs,
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
      body: CreateObsDialogV2(
        screen: screen,
        headers: headers,
        onAddObs: onAddObs,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn,
        rwAddObs: rwAddObs_,
      ),
    ).show();
  }
}

class _CreateObsDialogState extends State<CreateObsDialogV2> {
  TextEditingController tobsnote = TextEditingController();
  TextEditingController tFoodtimeHour = TextEditingController();
  final TextEditingController tObsDetail = TextEditingController();
  final TextEditingController tObsName = TextEditingController();
  final TextEditingController tObsNote = TextEditingController();

  ScheduleMode? _scheduleMode;
  ScheduleResult? _schedule; // ถ้าอยากเก็บรายละเอียดอื่น ๆ จากตัวเลือก
  final bool _noSchedule = false;

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

  List<String> levelOptions = [];
  List<String> setValue = [
    'obs',
    'col',
  ];
  Map<String, bool> selectedValues = {
    'obs': false,
    'col': false,
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

  bool get _isObsPopup => true;

  Map<ScheduleMode, String> kModeLabels = {
    ScheduleMode.weeklyOnce: 'กำหนดรายสัปดาห์',
    ScheduleMode.dailyCustom: 'กำหนดรายวัน',
    ScheduleMode.monthlyCustom: 'กำหนดรายเดือน',
    ScheduleMode.all: 'ไม่กำหนด',
  };
  String labelFromTypeSlot(String? t) {
    switch (t) {
      case 'weekly_once':
        return 'กำหนดรายสัปดาห์';
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

  bool get isPRN => selectedTimeSlot == 'เมื่อมีอาการ';

  String? selectedLevel;

  String encodeTakeTime({
    required List<bool> selectedTimeList,
    required List<String> timeList,
  }) {
    final times = <String>[];
    for (int i = 0; i < timeList.length; i++) {
      if (selectedTimeList[i]) times.add(timeList[i]);
    }
    if (times.isEmpty) return '[]';
    return "[${times.map((e) => "'$e'").join(',')}]"; // "['08:00','12:00']"
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

  bool _isScheduleDetailValid() {
    if (_scheduleMode == null || _schedule == null) {
      return false;
    }

    switch (_scheduleMode!) {
      case ScheduleMode.weeklyOnce:
        return _schedule!.weekdayNames.isNotEmpty;

      case ScheduleMode.dailyCustom:
        return (_schedule!.dailyNote?.trim().isNotEmpty ?? false);

      case ScheduleMode.monthlyCustom:
        return _schedule!.monthlyDays.isNotEmpty;

      case ScheduleMode.all:
        return true;
    }
  }

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
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
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
          text(context, 'กลุ่ม กำหนดเอง',
              color: const Color.fromARGB(255, 4, 138, 161)),
          const SizedBox(height: 10),
          textField1('คำสั่งพิเศษ', controller: tObsDetail),
          const SizedBox(height: 10),
          textField1('หมายเหตุ', controller: tobsnote),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SchedulePicker(
                allowAll: false,
                trailingModeChip: _buildUnspecifiedButton(),
                key: ValueKey(
                  'create_sched_${isPRN ? 'prn' : 'normal'}_${_scheduleMode ?? 'none'}',
                ),
                initialMode: isPRN ? null : _scheduleMode,
                initialWeeklySelectedNames: _schedule?.weekdayNames ?? const {},
                initialDailyNote: _schedule?.dailyNote,
                initialMonthlyDate: _schedule?.monthlyDate,
                initialDailyDate: _schedule?.dailyDate,
                initialMonthlyDays: _schedule?.monthlyDays ?? const <int>{},
                onChanged: (cfg) {
                  setState(() {
                    _scheduleMode = cfg.mode;
                    _schedule = cfg;
                  });
                  checkIsEnabled();
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          TimeSelection(
            key: ValueKey('time_reset_$_timeResetTick'),
            time: time,
            timeList: timeList,
            initialTakeTimes: selectedTakeTimes,
            initialTimeSlot: selectedTimeSlot,
            onSelectionChanged: (selectedIndex, selectedList) {
              setState(() {
                final idx = (selectedIndex == null ||
                        selectedIndex < 0 ||
                        selectedIndex >= time.length)
                    ? 0
                    : selectedIndex;

                selectedTimeSlot = time[idx];

                if (selectedTimeSlot == 'เมื่อมีอาการ') {
                  selectedTakeTimes = [];
                  _scheduleMode = null;
                  _schedule = null;
                } else {
                  selectedTakeTimes = [];
                  for (int i = 0;
                      i < selectedList.length && i < timeList.length;
                      i++) {
                    if (selectedList[i]) selectedTakeTimes.add(timeList[i]);
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
                child: actionSlider(context, 'ยืนยันการส่งสังเกตอาการเพิ่มเติม',
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
                  // final typeSlot = _typeSlotFromMode(_scheduleMode);
                  final String detailText = tObsDetail.text.trim();
                  final bool noTimesSelected = selectedTakeTimes.isEmpty;

                  final String typeSlot = noTimesSelected
                      ? 'ALL'
                      : (_scheduleMode == null
                          ? 'ALL'
                          : _typeSlotFromMode(_scheduleMode!));

                  final String? setSlot = (typeSlot == 'ALL')
                      ? null
                      : buildSetSlot(_schedule, weeklyAsNumber: false);

                  final String takeTime = (typeSlot == 'ALL')
                      ? '[]'
                      : "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]";

                  if (widget.screen == 'roundward') {
                    final setValueMap = {
                      "detail": detailText,
                      "obs": selectedValue == 'obs' ? 1 : 0,
                      "col": selectedValue == 'col' ? 1 : 0,
                      "time_slot": selectedTimeSlot,
                      "delete": 0,
                    };

                    final newObsOrder = DataAddOrderModel(
                      item_name: detailText,
                      type_card: 'Observe',
                      drug_type_name: widget.drugTypeName ?? "OBS",
                      remark: tobsnote.text,
                      time_slot: selectedTimeSlot,
                      // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                      // type_slot: typeSlot,
                      // take_time:
                      //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      drug_instruction: jsonEncode(setValueMap),
                      drug_description: (typeSlot == 'ALL')
                          ? null
                          : buildSetSlot(_schedule, weeklyAsNumber: false),
                      start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()),
                      schedule_mode_label:
                          _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                      // meal_timing: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),

                      set_slot: setSlot,
                      type_slot: typeSlot,
                      take_time: takeTime,
                    );

                    await RoundWardApi().AddOrder(
                      context,
                      headers_: widget.headers,
                      mUser: widget.lUserLogin!.first,
                      mPetAdmit_: widget.lPetAdmit!.first,
                      lDataOrder_: [newObsOrder],
                      mListAn_: widget.lListAn!.first,
                    );

                    await widget.rwAddObs();
                    Navigator.of(context).pop();
                  } else {
                    final setValueMap = {
                      "detail": detailText,
                      "obs": selectedValue == 'obs' ? 1 : 0,
                      "col": selectedValue == 'col' ? 1 : 0,
                      "time_slot": selectedTimeSlot,
                      "delete": 0,
                    };

                    final newObs = GetObsModel(
                      set_name: tObsName.text,
                      set_value: jsonEncode(setValueMap),
                      remark: tobsnote.text,
                      // meal_timing: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),
                      schedule_mode_label:
                          _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                      // take_time:
                      //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      set_slot: setSlot,
                      type_slot: typeSlot,
                      take_time: takeTime,
                    );

                    widget.onAddObs(newObs);
                    Navigator.pop(context);
                  }
                }),
              ))
        ],
      ),
    );
  }

  int _timeResetTick = 0;

  Widget _buildUnspecifiedButton() {
    if (!_isObsPopup) return const SizedBox.shrink();

    final bool isActive = (_scheduleMode == ScheduleMode.all);

    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          'ไม่กำหนด',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.teal.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      selected: isActive,
      backgroundColor: Colors.teal.shade50,
      selectedColor: Colors.teal.shade700,
      elevation: isActive ? 3 : 0,
      pressElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? Colors.teal.shade700 : Colors.teal.shade200,
          width: 1.2,
        ),
      ),
      onSelected: (_) {
        setState(() {
          _scheduleMode = ScheduleMode.all;
          selectedTakeTimes.clear();
          selectedTimeIndex = null;

          for (var i = 0; i < selected.length; i++) {
            selected[i] = false;
          }
          for (var i = 0; i < selectedTimeList.length; i++) {
            selectedTimeList[i] = false;
          }

          _schedule = null;
          selectedTimeSlot = 'ไม่กำหนด';

          _timeResetTick++; 
        });
        checkIsEnabled();
      },
    );
  }

  bool _isScheduleOkForObs() {
    if (_scheduleMode == ScheduleMode.all) return true;
    if (selectedTimeSlot.trim() == 'เมื่อมีอาการ') return true;
    if (_scheduleMode == null || _schedule == null) return false;
    switch (_scheduleMode!) {
      case ScheduleMode.weeklyOnce:
        return _schedule!.weekdayNames.isNotEmpty;

      case ScheduleMode.dailyCustom:
        return (_schedule!.dailyNote?.trim().isNotEmpty ?? false) &&
            _schedule!.dailyDate != null;

      case ScheduleMode.monthlyCustom:
        return _schedule!.monthlyDays.isNotEmpty;

      case ScheduleMode.all:
        return true;
    }
  }

  bool _isTimeOkForObs() {
    if (selectedTimeSlot.trim() == 'เมื่อมีอาการ') return true;
    if (_scheduleMode == ScheduleMode.all ||
        selectedTimeSlot.trim() == 'ไม่ระบุ') {
      return true;
    }
    return selectedTakeTimes.isNotEmpty;
  }

  void checkIsEnabled() {
    final scheduleOk = _isScheduleOkForObs();
    final timeOk = _isTimeOkForObs();

    final ok = scheduleOk && timeOk;

    if (ok != isEnabled) {
      setState(() => isEnabled = ok);
    }
  }
}
