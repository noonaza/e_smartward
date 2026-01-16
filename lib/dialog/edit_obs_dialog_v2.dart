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
  final void Function(ListRoundwardModel updatedItem)? onLocalUpdate;
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
    this.onLocalUpdate,
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
    final void Function(ListRoundwardModel updatedItem)? onLocalUpdate,
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
  ScheduleMode? _scheduleMode;
  ScheduleResult? _schedule; // ถ้าอยากเก็บรายละเอียดอื่น ๆ จากตัวเลือก
  bool get isPRN => selectedTimeSlot == 'เมื่อมีอาการ';
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
    'ไม่กำหนด': false,
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

  DateTime _buildStartDateFromSchedule(
    ScheduleResult? s, {
    String? orderDate,
    String? initialStart,
  }) {
    final now = DateTime.now();

    DateTime? init;
    if (initialStart != null && initialStart.trim().isNotEmpty) {
      init = _parseStartDateUse(initialStart);
    }

    DateTime? order;
    if (orderDate != null && orderDate.isNotEmpty) {
      try {
        order = DateFormat('yyyy-MM-dd').parseStrict(orderDate);
      } catch (_) {
        try {
          order = DateFormat('dd/MM/yyyy').parseStrict(orderDate);
        } catch (_) {}
      }
    }

    if (s?.mode == ScheduleMode.dailyCustom && s?.dailyDate != null) {
      final d = s!.dailyDate!;

      return DateTime(d.year, d.month, d.day, now.hour, now.minute, now.second);
    }

    if (order != null) {
      return DateTime(
          order.year, order.month, order.day, now.hour, now.minute, now.second);
    }

    return init ?? now;
  }

  bool isEnabled = false;

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
    ScheduleMode? mode,
    Set<String> weeklyNames,
    String? dailyNote,
    Set<int> monthlyDays,
  }) _parseDrugSlot(String? setSlot, String? typeSlot) {
    final s = (setSlot ?? '').trim();
    final t = (typeSlot ?? '').trim().toLowerCase();

    bool isWeekly(String x) => ['weekly', 'days', 'weekly_once'].contains(x);
    bool isDaily(String x) => ['daily', 'date', 'daily_custom'].contains(x);
    bool isMonthly(String x) =>
        ['monthly', 'd_m', 'monthly_custom'].contains(x);
    bool isAll(String x) => ['all'].contains(x);

    // ✅ ถ้าไม่มีทั้ง setSlot และ typeSlot => "ยังไม่เลือกอะไร"
    if (s.isEmpty && t.isEmpty) {
      return (mode: null, weeklyNames: {}, dailyNote: null, monthlyDays: {});
    }

    if (s.isEmpty) {
      if (isAll(t)) {
        return (
          mode: ScheduleMode.all,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: {}
        );
      }
      if (isDaily(t)) {
        return (
          mode: ScheduleMode.dailyCustom,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: {}
        );
      }
      if (isMonthly(t)) {
        return (
          mode: ScheduleMode.monthlyCustom,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: {}
        );
      }
      if (isWeekly(t)) {
        return (
          mode: ScheduleMode.weeklyOnce,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: {}
        );
      }
      // ถ้า typeSlot แปลก ๆ แต่ setSlot ว่าง ก็ยังไม่เลือก
      return (mode: null, weeklyNames: {}, dailyNote: null, monthlyDays: {});
    }

    if (isDaily(t)) {
      return (
        mode: ScheduleMode.dailyCustom,
        weeklyNames: {},
        dailyNote: s,
        monthlyDays: {}
      );
    }

    if (isWeekly(t)) {
      final wk = _parseWeeklyNames(s);
      return (
        mode: ScheduleMode.weeklyOnce,
        weeklyNames: wk,
        dailyNote: null,
        monthlyDays: {}
      );
    }

    if (isMonthly(t)) {
      final days = _parseMonthlyDays(_looksLikeList(s) ? s : '[$s]');
      return (
        mode: ScheduleMode.monthlyCustom,
        weeklyNames: {},
        dailyNote: null,
        monthlyDays: days
      );
    }

    if (isAll(t)) {
      return (
        mode: ScheduleMode.all,
        weeklyNames: {},
        dailyNote: null,
        monthlyDays: {}
      );
    }

    // fallback เดิม
    final wk = _parseWeeklyNames(s);
    if (wk.isNotEmpty) {
      return (
        mode: ScheduleMode.weeklyOnce,
        weeklyNames: wk,
        dailyNote: null,
        monthlyDays: {}
      );
    }

    final md = _parseMonthlyDays(_looksLikeList(s) ? s : '[$s]');
    if (md.isNotEmpty) {
      return (
        mode: ScheduleMode.monthlyCustom,
        weeklyNames: {},
        dailyNote: null,
        monthlyDays: md
      );
    }

    return (
      mode: ScheduleMode.dailyCustom,
      weeklyNames: {},
      dailyNote: s,
      monthlyDays: {}
    );
  }

  DateTime? _parseStartDateUse(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final v = s.trim();

    for (final p in ['yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd HH:mm']) {
      try {
        return DateFormat(p).parseStrict(v);
      } catch (_) {}
    }
    return null;
  }

  final List<String> setValue = ['col'];
  Map<String, bool> selectedValues = {'col': false};

  List<String> levelOptions = [];
  String? selectedLevel;
  bool get hasLevelOptions => levelOptions.isNotEmpty;

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

  String toLabel(ScheduleMode m) {
    switch (m) {
      case ScheduleMode.weeklyOnce:
        return 'สัปดาห์ละครั้ง';
      case ScheduleMode.dailyCustom:
        return 'กำหนดรายวัน';
      case ScheduleMode.monthlyCustom:
        return 'กำหนดรายเดือน';
      case ScheduleMode.all:
        return 'ไม่กำหนด';
    }
  }

  @override
  void initState() {
    super.initState();

    selected = List.generate(time.length, (index) => false);
    selectedTimeList = List.generate(timeList.length, (index) => false);
    tObsName.text = widget.Obs.set_name ?? '';
    tObsNote.text = widget.mData?.remark ?? widget.Obs.remark ?? '';
    final decoded = _asMap(widget.Obs.set_value);
    final svParsed = SetValueParser.parse(widget.Obs.set_value);
    final itemName = (widget.mData?.item_name ?? '').trim();
    final detailFromSetValue = (SetValueParser.detailString(svParsed)).trim();
    tObsDetail.text = itemName.isNotEmpty ? itemName : detailFromSetValue;

    _extractLevel(decoded);

    if (_flag(decoded['col'])) {
      selectedValues.updateAll((k, v) => false);
      selectedValues['col'] = true;
      selectedValue = 'col';
    } else if (_flag(decoded['obs'])) {
      selectedValues.updateAll((k, v) => false);
      selectedValues['obs'] = true;
      selectedValue = 'obs';
    }

    selectedTimeSlot = (widget.Obs.time_slot ?? '').trim();

    // selectedTimeSlot =
    //     (decoded['time_slot'] ?? widget.mData?.time_slot ?? '').toString();

    if (widget.Obs.take_time != null) {
      final cleaned = widget.Obs.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      selectedTakeTimes = cleaned;
    }
    selectedTimeSlot = (widget.Obs.time_slot ?? '').trim();
    if (selectedTimeSlot.isEmpty) selectedTimeSlot = 'กำหนดเอง';
    final idx = time.indexOf(selectedTimeSlot);
    if (idx != -1) selectedTimeIndex = idx;

    final parsed = _parseDrugSlot(widget.Obs.set_slot, widget.Obs.type_slot);
    final startFromDb = _parseStartDateUse(widget.Obs.start_date_use);

    _scheduleMode = parsed.mode;

    _schedule = (parsed.mode == null)
        ? null
        : ScheduleResult(
            mode: parsed.mode!,
            modeLabel: toLabel(parsed.mode!),
            weekdayNames: parsed.weeklyNames,
            dailyNote: parsed.dailyNote,
            monthlyDays: parsed.monthlyDays,
            dailyDate:
                (parsed.mode == ScheduleMode.dailyCustom) ? startFromDb : null,
            monthlyDate: null,
          );

    selectedDay.updateAll((k, v) => false);

    final mode = _scheduleMode; // ScheduleMode?
    if (mode == null) {
    } else {
      switch (mode) {
        case ScheduleMode.weeklyOnce:
          selectedDay['กำหนดรายสัปดาห์'] = true;
          break;
        case ScheduleMode.dailyCustom:
          selectedDay['กำหนดรายวัน'] = true;
          break;
        case ScheduleMode.monthlyCustom:
          selectedDay['กำหนดรายเดือน'] = true;
          break;
        case ScheduleMode.all:
          selectedDay['ไม่กำหนด'] = true;
          break;
      }
    }

    selectedWeekdays.updateAll((k, v) => false);
    for (final name in parsed.weeklyNames) {
      if (selectedWeekdays.containsKey(name)) {
        selectedWeekdays[name] = true;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
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
    // _parseDrugSlot(widget.Obs.set_slot, widget.Obs.type_slot);
    // _parseStartDateUse(widget.Obs.start_date_use);

    final String displayCode = (() {
      final code = widget.mData?.item_code?.trim();
      if (code == null || code.isEmpty) {
        return 'กำหนดเอง';
      }
      return code;
    })();
    final titleText = (widget.screen == 'roundward')
        ? displayCode
        : (tObsName.text.isEmpty ? 'กำหนดเอง' : tObsName.text);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 5),
          text(context, titleText,
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
          _buildLevelSection(),
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
              // ignoring: false,
              ignoring: !isEnabled,
              child: actionSlider(context, 'ยืนยันการให้อาหารเพิ่มเติม',
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
                final bool isPRN = selectedTimeSlot == 'เมื่อมีอาการ';

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

                final startDt = _buildStartDateFromSchedule(
                  _schedule,
                  orderDate: widget.Obs.order_date,
                  initialStart: widget.Obs.start_date_use,
                );
                final String detailText = tObsDetail.text.trim();

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
                  final String normalizedItemCode = (() {
                    final v = widget.mData?.item_code?.trim();
                    return (v == null || v.isEmpty) ? 'กำหนดเอง' : v;
                  })();

                  final updatedObs = UpdateOrderModel(
                    item_name: detailText,
                    drug_instruction: jsonEncode(setValueMap),
                    remark: tObsNote.text,
                    caution: cautionVal.toString(),
                    //take_time: data.take_time,
                    //  set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    drug_description:
                        buildSetSlot(_schedule, weeklyAsNumber: false),
                    // type_slot: _typeSlotFromMode(_scheduleMode),
                    drug_type_name: widget.drugTypeName ??
                        widget.mData?.drug_type_name ??
                        '',
                    start_date_use:
                        DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                    time_slot: selectedTimeSlot,

                    set_slot: setSlot,
                    type_slot: typeSlot,
                    take_time: takeTime,
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

                  widget.mData!.item_name = detailText;
                  widget.mData!.remark = tObsNote.text;
                  widget.mData!.drug_instruction = jsonEncode(setValueMap);
                  widget.mData!.take_time = takeTime;
                  widget.mData!.time_slot = selectedTimeSlot;
                  widget.mData!.type_slot = typeSlot;
                  widget.mData!.set_slot = setSlot;
                  widget.mData!.item_code = normalizedItemCode;
                  widget.mData!.caution = cautionVal.toString();
                  widget.onLocalUpdate?.call(widget.mData!);

                  final updatedData = await RoundWardApi().loadDataRoundWard(
                    context,
                    headers_: widget.headers,
                    mListAn_: widget.lListAn!.first,
                    mGroup_: widget.group!,
                  );

                  widget.onRefresh?.call(updatedData, false);
                } else {
                  final setValueMap2 = {
                    "detail": detailText,
                    "level": _levelForSubmit(),
                    "col": selectedValue == 'col' ? 1 : 0,
                    "time_slot": selectedTimeSlot,
                    "delete": 0,
                  };

                  final updatedObs2 = GetObsModel(
                    set_name: tObsName.text,
                    set_value: jsonEncode(setValueMap2),
                    remark: tObsNote.text,
                    //  set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    drug_description:
                        buildSetSlot(_schedule, weeklyAsNumber: false),
                    start_date_use:
                        DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                    //  type_slot: _typeSlotFromMode(_scheduleMode),
                    schedule_mode_label:
                        _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                    time_slot: selectedTimeSlot,
                    set_slot: setSlot,
                    type_slot: typeSlot,
                    take_time: takeTime,
                  );

                  widget.cb(updatedObs2, widget.indexObs);
                  Navigator.of(context).pop();
                }
              }),
            ),
          )
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
