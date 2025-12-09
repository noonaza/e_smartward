// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
import 'package:e_smartward/widget/set_level.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_roundward_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import '../Model/list_data_card_model.dart';
import '../Model/list_data_obs_model.dart';
import '../Model/list_group_model.dart';
import '../Model/update_order_model.dart';
import '../api/roundward_api.dart';
import '../widget/text.dart';

// ignore: must_be_immutable
class EditObsDialogV2 extends StatefulWidget {
  final GetObsModel Obs;
  final int indexObs;
  final Function(GetObsModel updatedObs, int index_) cb;
  final void Function(List<ListRoundwardModel>, bool)? onRefresh;
  Map<String, String> headers;
  final List<ListUserModel>? lUserLogin;
  final ListGroupModel? group;
  final List<ListAnModel>? lListAn;
  final ListRoundwardModel? mData;
  final List<ListPetModel>? lPetAdmit;
  final String? drugTypeName;
  String screen;

  EditObsDialogV2({
    Key? key,
    required this.Obs,
    required this.indexObs,
    required this.cb,
    this.onRefresh,
    required this.headers,
    this.lUserLogin,
    this.group,
    this.lListAn,
    this.mData,
    this.lPetAdmit,
    this.drugTypeName,
    required this.screen,
  }) : super(key: key);

  @override
  State<EditObsDialogV2> createState() => _EditDetailDialogState();

  static void showObs(
    BuildContext context,
    GetObsModel Obs,
    int index_,
    Function(GetObsModel updatedObs, int index_) cb_,
    Map<String, String> headers, {
    required String screen,
    List<ListUserModel>? lUserLogin,
    List<ListPetModel>? lPetAdmit,
    List<ListAnModel>? lListAn,
    String? drugTypeName,
    ListRoundwardModel? mData,
    ListGroupModel? group,
    void Function(List<ListRoundwardModel>, bool)? onRefresh,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth;

    if (screenWidth >= 1024) {
      dialogWidth = screenWidth * 0.5; // Desktop
    } else if (screenWidth >= 680) {
      dialogWidth = screenWidth * 0.8; // Tablet
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
      body: EditObsDialogV2(
        Obs: Obs,
        indexObs: index_,
        cb: cb_,
        screen: screen,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn,
        mData: mData,
        group: group,
        headers: headers,
        onRefresh: (updatedData, hasNew) {
          onRefresh?.call(updatedData, hasNew);
        },
      ),
    ).show();
  }
}

class _EditDetailDialogState extends State<EditObsDialogV2> {
  // --- Controllers ---
  final TextEditingController tObsName = TextEditingController();
  final TextEditingController tObsNote = TextEditingController();
  final TextEditingController tObsDetail = TextEditingController();
  final TextEditingController ttimeHour = TextEditingController();
  ScheduleMode _scheduleMode = ScheduleMode.weeklyOnce; // ค่าเริ่มต้นที่ต้องการ
  ScheduleResult? _schedule; // ถ้าอยากเก็บรายละเอียดอื่น ๆ จากตัวเลือก
  final bool _noSchedule = false;

  // --- Static choices (ของเดิมคุณ) ---
  final List<String> typeDrug = [
    'ยาหยอด',
    'ยาฉีด (วัคซีน และ ยาฉีดอื่นๆ)',
    'ยาน้ำ',
    'ยาทา (ยาภายนอก)',
  ];
  final List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'ทุกๆ 6 ชม.',
    'ทุกๆ 8 ชม.',
    'กำหนดเอง',
    'เมื่อมีอาการ'
  ];
  static const _thaiWeekdays = [
    'อาทิตย์',
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์'
  ];
  static const _engToThai = {
    'Sun': 'อาทิตย์',
    'Mon': 'จันทร์',
    'Tue': 'อังคาร',
    'Wed': 'พุธ',
    'Thu': 'พฤหัสบดี',
    'Fri': 'ศุกร์',
    'Sat': 'เสาร์',
  };

  Map<String, bool> selectedDay = {
    'สัปดาห์ละครั้ง': false,
    'กำหนดรายวัน': false,
    'กำหนดรายเดือน': false,
    'ไม่กำหมด': false,
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

  Map<ScheduleMode, String> kModeLabels = {
    ScheduleMode.weeklyOnce: 'สัปดาห์ละครั้ง',
    ScheduleMode.dailyCustom: 'กำหนดรายวัน',
    ScheduleMode.monthlyCustom: 'กำหนดรายเดือน',
    ScheduleMode.all: 'ไม่กำหนด',
  };
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

  bool _looksLikeList(String s) =>
      s.trim().startsWith('[') && s.trim().endsWith(']');

  List<String> _splitListLike(dynamic raw) {
    if (raw == null) return [];
    final s = raw.toString();

    final cleaned = s.replaceAll(RegExp(r"[{}\[\]\(\)']"), '').trim();

    if (cleaned.isEmpty) return [];
    return cleaned
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Set<String> _parseWeeklyNames(String raw) {
    final t = raw.trim();

    if (_thaiWeekdays.any((d) => t.contains(d))) {
      return t
          .split(',')
          .map((e) => e.trim())
          .toSet()
          .intersection(_thaiWeekdays.toSet());
    }

    final items = _splitListLike(t);
    if (items.isNotEmpty && _engToThai.keys.toSet().contains(items.first)) {
      return items.map((e) => _engToThai[e]!).toSet();
    }

    final nums = _splitListLike(t)
        .map((e) => int.tryParse(e) ?? -999)
        .where((n) => n >= 0)
        .toList();
    if (nums.isNotEmpty) {
      if (nums.any((n) => n == 0 || n == 6)) {
        return nums.map((n) => _thaiWeekdays[n % 7]).toSet();
      }
      const order = [
        'จันทร์',
        'อังคาร',
        'พุธ',
        'พฤหัสบดี',
        'ศุกร์',
        'เสาร์',
        'อาทิตย์'
      ];
      return nums
          .where((n) => n >= 1 && n <= 7)
          .map((n) => order[n - 1])
          .toSet();
    }
    return {};
  }

  Set<int> _parseMonthlyDays(String raw) {
    final items = _splitListLike(raw)
        .map((e) => int.tryParse(e) ?? -1)
        .where((n) => n >= 1 && n <= 31)
        .toSet();
    return items;
  }

  ({
    ScheduleMode mode,
    Set<String> weeklyNames,
    String? dailyNote,
    Set<int> monthlyDays,
  }) _parseDrugSlot(String? setSlot, String? typeSlot) {
    final s = (setSlot ?? '').trim();
    final t = (typeSlot ?? '').trim().toUpperCase();

    if (s.isEmpty) {
      return (
        mode: ScheduleMode.weeklyOnce,
        weeklyNames: {},
        dailyNote: null,
        monthlyDays: {}
      );
    }

    switch (t) {
      case 'DAYS':
      case 'WEEKLY':
        return (
          mode: ScheduleMode.weeklyOnce,
          weeklyNames: _parseWeeklyNames(s),
          dailyNote: null,
          monthlyDays: {}
        );
      case 'DATE':
      case 'DAILY':
        return (
          mode: ScheduleMode.dailyCustom,
          weeklyNames: {},
          dailyNote: s,
          monthlyDays: {}
        );
      case 'D_M':
      case 'MONTHLY':
        final days = _parseMonthlyDays(_looksLikeList(s) ? s : '[$s]');
        return (
          mode: ScheduleMode.monthlyCustom,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: days
        );
      default:
        return (
          mode: ScheduleMode.weeklyOnce,
          weeklyNames: _parseWeeklyNames(s),
          dailyNote: null,
          monthlyDays: {}
        );
    }
  }

  final List<String> setValue = ['col'];
  Map<String, bool> selectedValues = {'col': false};

  List<String> levelOptions = [];
  String? selectedLevel;
  bool get hasLevelOptions => levelOptions.isNotEmpty;

  String selectedValue = '';
  String selectedTimeSlot = '';
  List<String> selectedTakeTimes = [];

  final List<String> timeList = List.generate(24, (index) {
    final h = index.toString().padLeft(2, '0');
    return '$h:00';
  });

  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;

  dynamic _levelForSubmit() {
    if (selectedLevel != null && selectedLevel!.isNotEmpty) {
      return selectedLevel;
    }

    if (levelOptions.isNotEmpty) {
      return levelOptions;
    }

    final prev = SetValueParser.parse(widget.Obs.set_value);
    if (prev['level'] != null) {
      return prev['level'];
    }
    return [];
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v));
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final v = jsonDecode(raw);
        if (v is Map<String, dynamic>) return v;
        if (v is Map) {
          return v.map((k, v) => MapEntry(k.toString(), v));
        }
      } catch (_) {}
    }
    return {};
  }

  bool _flag(dynamic v) {
    if (v == null) return false;
    if (v is num) return v != 0;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  void _extractLevel(dynamic rawSetValue) {
    final sv = _asMap(rawSetValue);
    final rawLevel = sv['level'];

    levelOptions = [];
    selectedLevel = null;

    if (rawLevel is List) {
      levelOptions = rawLevel.map((e) => e.toString()).toList();
    } else if (rawLevel is String && rawLevel.trim().isNotEmpty) {
      selectedLevel = rawLevel.trim();
    } else if (rawLevel is num) {
      selectedLevel = rawLevel.toString();
    }
  }

  @override
  void initState() {
    super.initState();

    selected = List.generate(time.length, (index) => false);
    selectedTimeList = List.generate(timeList.length, (index) => false);

    tObsName.text = widget.Obs.set_name ?? '';
    tObsNote.text = widget.Obs.remark ?? '';

    final svParsed = SetValueParser.parse(widget.Obs.set_value);

    tObsDetail.text = SetValueParser.detailString(svParsed);

    final decoded = _asMap(widget.Obs.set_value);

    _extractLevel(decoded);

    if (_flag(decoded['col'])) {
      selectedValues.updateAll((k, v) => false);
      selectedValues['col'] = true;
      selectedValue = 'col';
    }

    // time_slot เดิม ถ้ามี
    selectedTimeSlot = (decoded['time_slot'] ?? '').toString();

    selectedDay.updateAll((k, v) => false);
    switch (_scheduleMode) {
      case ScheduleMode.weeklyOnce:
        selectedDay['สัปดาห์ละครั้ง'] = true;
        break;
      case ScheduleMode.dailyCustom:
        selectedDay['กำหนดรายวัน'] = true;
        break;
      case ScheduleMode.monthlyCustom:
        selectedDay['กำหนดรายเดือน'] = true;
        break;
      case ScheduleMode.all:
        selectedDay['ไม่กำหนด'] = true;
    }

    if (widget.Obs.take_time != null) {
      final cleaned = widget.Obs.take_time!
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll("'", '')
          .split(',');
      selectedTakeTimes =
          cleaned.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      for (int i = 0; i < timeList.length; i++) {
        selectedTimeList[i] = selectedTakeTimes.contains(timeList[i]);
      }
    }
  }

  @override
  void dispose() {
    tObsName.dispose();
    tObsNote.dispose();
    tObsDetail.dispose();
    ttimeHour.dispose();
    super.dispose();
  }

  Widget _buildLevelSection() {
    const pinkMain = Color.fromARGB(255, 67, 126, 139),
        pinkSelected = Color(0xFFE91E63);

    if (hasLevelOptions) {
      return IgnorePointer(
        ignoring: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: levelOptions.map((opt) {
                final isSelected = selectedLevel == opt;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ChoiceChip(
                    label: Text(
                      opt,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: pinkSelected,
                    backgroundColor: pinkMain,
                    pressElevation: 2,
                    elevation: isSelected ? 4 : 1,
                    side: BorderSide(
                      color:
                          isSelected ? pinkSelected : pinkMain.withOpacity(0.8),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    onSelected: (_) => setState(() => selectedLevel = opt),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    if (selectedLevel != null && selectedLevel!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(context, 'ระดับ (level)',
              color: pinkSelected, fontWeight: FontWeight.bold, fontSize: 16),
          const SizedBox(height: 8),
          Chip(
            label: Text(
              selectedLevel!,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: pinkSelected,
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNoSchedule = _noSchedule || _scheduleMode == ScheduleMode.all;
    final parsed = _parseDrugSlot(widget.Obs.set_slot, widget.Obs.type_slot);
    // final bool isEnabled = selectedTakeTimes.isNotEmpty || selectedTimeSlot == 'เมื่อมีอาการ';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 5),
          text(context, (tObsName.text.isEmpty) ? "กำหนดเอง" : tObsName.text,
              color: const Color.fromARGB(255, 4, 138, 161)),
          const SizedBox(height: 10),

          textField1('คำสั่งพิเศษ', controller: tObsDetail),
          const SizedBox(height: 10),
          textField1('หมายเหตุ', controller: tObsNote),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.0,
                children: setValue.map((key) {
                  return IgnorePointer(
                    ignoring: true,
                    child: ChoiceChip(
                      label: text(
                        context,
                        key,
                        color:
                            selectedValues[key]! ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                      selected: selectedValues[key]!,
                      selectedColor: const Color.fromARGB(255, 4, 138, 161),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selectedValues[key]!
                              ? Colors.grey
                              : Colors.teal.shade200,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      onSelected: (selected) {
                        setState(() {
                          selectedValues.updateAll((key, value) => false);
                          selectedValues[key] = selected;
                          selectedValue = key;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SchedulePicker(
            key: ValueKey('sched_${widget.Obs.set_name ?? widget.Obs}'),
            initialMode: _scheduleMode,
            initialWeeklySelectedNames:
                (_schedule?.weekdayNames.isNotEmpty == true)
                    ? _schedule!.weekdayNames
                    : parsed.weeklyNames,
            initialDailyNote: _schedule?.dailyNote ?? parsed.dailyNote,
            initialMonthlyDate: _schedule?.monthlyDate,
            initialMonthlyDays: _schedule?.monthlyDays ?? parsed.monthlyDays,
            initialDailyDate: _schedule?.dailyDate,
            onChanged: (cfg) {
              const engToThai = {
                'Mon': 'จันทร์',
                'Tue': 'อังคาร',
                'Wed': 'พุธ',
                'Thu': 'พฤหัสบดี',
                'Fri': 'ศุกร์',
                'Sat': 'เสาร์',
                'Sun': 'อาทิตย์',
              };
              Set<String> toThaiSet(Iterable<String> names) =>
                  names.map((n) => engToThai[n.trim()] ?? n.trim()).toSet();

              final normalized = cfg.mode == ScheduleMode.weeklyOnce
                  ? toThaiSet(cfg.weekdayNames)
                  : cfg.weekdayNames;

              setState(() {
                _scheduleMode = cfg.mode;
                _schedule = ScheduleResult(
                  mode: cfg.mode,
                  modeLabel: kModeLabels[cfg.mode]!,
                  weekdayNames: normalized,
                  dailyNote: cfg.dailyNote,
                  monthlyDate: cfg.monthlyDate,
                  monthlyDays: cfg.monthlyDays,
                  dailyDate: cfg.dailyDate,
                );
              });
            },
          ),
          const SizedBox(height: 10),

          // --- แสดง LEVEL ---
          _buildLevelSection(),

          const SizedBox(height: 15),
          if (!isNoSchedule)
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
              ignoring: false,
              // ignoring: !isEnabled,
              child: actionSlider(context, 'ยืนยันการส่งสังเกตอาการเพิ่มเติม',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 30.0,
                  backgroundColor: const Color.fromARGB(255, 203, 230, 252),
                  togglecolor: const Color.fromARGB(255, 76, 172, 175),
                  icons: Icons.check,
                  iconColor: Colors.white,
                  asController: ActionSliderController(),
                  action: (controller) async {
                final String detailText = tObsDetail.text.trim();
                final typeSlot = _typeSlotFromMode(_scheduleMode);
                final setValueMap = {
                  "detail": detailText,
                  "level": _levelForSubmit(),
                  "obs": selectedValue == 'obs' ? 1 : 0,
                  "col": selectedValue == 'col' ? 1 : 0,
                  "time_slot": selectedTimeSlot,
                  "delete": 0,
                };
                final int cautionVal = (setValueMap['col'] is num)
                    ? (setValueMap['col'] as num).toInt()
                    : int.tryParse(setValueMap['col']?.toString() ?? '0') ?? 0;

                if (widget.screen == 'roundward') {
                  final data = ListDataCardModel(
                    item_name: detailText,
                    remark: tObsNote.text,
                    stock_out: 0,
                    start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now()),
                    set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    type_slot: _typeSlotFromMode(_scheduleMode),
                    schedule_mode_label:
                        _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                    take_time:
                        "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                    time_slot: selectedTimeSlot,
                    caution: cautionVal,
                  );

                  final updatedObs = UpdateOrderModel(
                    item_name: detailText,
                    drug_instruction: jsonEncode(setValueMap),
                    remark: tObsNote.text,
                    caution: cautionVal.toString(),
                    take_time: data.take_time,
                    set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    drug_description:
                        buildSetSlot(_schedule, weeklyAsNumber: false),
                    type_slot: _typeSlotFromMode(_scheduleMode),
                    drug_type_name: widget.drugTypeName ??
                        widget.mData?.drug_type_name ??
                        '',
                  );

                  await RoundWardApi().updateOrderData(
                    context: context,
                    headers_: widget.headers,
                    updatedDrug: updatedObs,
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
                  final setValueMap = {
                    "detail": detailText,
                    "level": _levelForSubmit(),
                    "col": selectedValue == 'col' ? 1 : 0,
                    "time_slot": selectedTimeSlot,
                    "delete": 0,
                  };

                  final updatedObs = GetObsModel(
                    set_name: tObsName.text,
                    set_value: jsonEncode(setValueMap),
                    remark: tObsNote.text,
                    set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    drug_description:
                        buildSetSlot(_schedule, weeklyAsNumber: false),
                    type_slot: _typeSlotFromMode(_scheduleMode),
                    schedule_mode_label:
                        _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                    take_time:
                        "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                  );

                  widget.cb(updatedObs, widget.indexObs);
                  Navigator.of(context).pop();
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}
