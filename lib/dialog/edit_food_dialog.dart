// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
import 'package:e_smartward/widget/text.dart';
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
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
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
    super.key,
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
  });

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
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: dialogWidth,
      dismissOnTouchOutside: false,
      customHeader: Image.asset(
        'assets/gif/eat.gif',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
      body: EditFoodDialog(
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
  ScheduleMode? _scheduleMode;
  ScheduleResult? _schedule;
// ---------- Static refs ----------
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

  List<String> typeDrug = [
    '[T]ยาเม็ด',
    '[L]ยาหยอด',
    '[I]ยาฉีด',
    '[S]ยาน้ำ',
    '[E]ยาใช้ภายนอก',
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
  List<String> setDay = [
    'กำหนดรายสัปดาห์',
    'กำหนดรายวัน',
    'กำหนดรายเดือน',
  ];
  Map<String, bool> selectedDay = {
    'กำหนดรายสัปดาห์': false,
    'กำหนดรายวัน': false,
    'กำหนดรายเดือน': false,
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

  Map<String, bool> selectStatus = {
    'ให้อาหารทันที': false,
  };
  List<String> setValueStatus = [
    'ให้อาหารทันที',
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
  List<String> selectedTakeTimes = [];
  bool get isPRN => selectedTimeSlot == 'เมื่อมีอาการ';

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
    ScheduleMode.weeklyOnce: 'กำหนดรายสัปดาห์',
    ScheduleMode.dailyCustom: 'กำหนดรายวัน',
    ScheduleMode.monthlyCustom: 'กำหนดรายเดือน',
    ScheduleMode.all: 'ไม่กำหนด',
  };
  String labelFromTypeSlot(String? t) {
    switch ((t ?? '').trim().toLowerCase()) {
      case 'weekly_once':
      case 'weekly':
      case 'days':
        return 'กำหนดรายสัปดาห์';

      case 'daily_custom':
      case 'daily':
      case 'date':
        return 'กำหนดรายวัน';

      case 'monthly_custom':
      case 'monthly':
      case 'd_m':
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
    final t = (typeSlot ?? '').trim().toLowerCase();
    const defaultWeekly = <String>{'อังคาร'};

    bool isWeekly(String x) => ['weekly', 'days', 'weekly_once'].contains(x);
    bool isDaily(String x) => ['daily', 'date', 'daily_custom'].contains(x);
    bool isMonthly(String x) =>
        ['monthly', 'd_m', 'monthly_custom'].contains(x);
    bool isAll(String x) => ['all'].contains(x);

    if (s.isEmpty) {
      switch (t) {
        case 'daily':
        case 'date':
        case 'daily_custom':
          return (
            mode: ScheduleMode.dailyCustom,
            weeklyNames: {},
            dailyNote: null,
            monthlyDays: {}
          );

        case 'monthly':
        case 'd_m':
        case 'monthly_custom':
          return (
            mode: ScheduleMode.monthlyCustom,
            weeklyNames: {},
            dailyNote: null,
            monthlyDays: {}
          );

        case 'all':
          return (
            mode: ScheduleMode.all,
            weeklyNames: {},
            dailyNote: null,
            monthlyDays: {}
          );

        case 'weekly':
        case 'days':
        case 'weekly_once':
        default:
          return (
            mode: ScheduleMode.weeklyOnce,
            weeklyNames: {},
            dailyNote: null,
            monthlyDays: {}
          );
      }
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
        weeklyNames: wk.isEmpty ? {...defaultWeekly} : wk,
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
        return true; // หรือ business rule ของคุณ
    }
  }

  bool isEnabled = false;
  List<DropdownMenuItem<DoctorModel>> drugItems = [];
  DoctorModel? selectedDoctor;

  List<DoctorModel> ListDoctors = [];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });

  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;
  String selectedTimeSlot = '';

  String toLabel(ScheduleMode m) {
    switch (m) {
      case ScheduleMode.weeklyOnce:
        return 'กำหนดรายสัปดาห์';
      case ScheduleMode.dailyCustom:
        return 'กำหนดรายวัน';
      case ScheduleMode.monthlyCustom:
        return 'กำหนดรายเดือน';
      case ScheduleMode.all:
        return 'ไม่กำหนด';
    }
  }

  List<DropdownMenuItem<DoctorModel>> FoodItems = [];

  @override
  // ================== initState ==================

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 40), () async {
      ListDoctors =
          await AdmitApi().loadDataDoctor(context, headers_: widget.headers);
      final matchedDoctors =
          ListDoctors.where((d) => d.employee_id == widget.food.doctor_eid)
              .toList();
      selectedDoctor = matchedDoctors.isNotEmpty ? matchedDoctors.first : null;
      initDoctors();
    });

    tFoodName.text = widget.food.item_name ?? '';
    tFoodDose.text = widget.food.dose_qty?.toString() ?? '';
    tFoodCondition.text = widget.food.drug_description ?? '';
    tFoodUnit.text = widget.food.unit_name?.toString() ?? '';
    tFoodNote.text = widget.food.remark ?? '';
    tFoodQty.text = widget.food.item_qty?.toString() ?? '';
    tFoodUnitQty.text = widget.food.unit_name?.toString() ?? '';

    tFoodProperties.text = widget.food.drug_description ?? '';
    selectedTypeDrug = widget.food.drug_type_name;

    tFoodUnit.addListener(() {
      tFoodUnitQty.text = tFoodUnit.text;
    });

    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    // มื้ออาหาร
    if (widget.food.meal_timing != null) {
      final cleanedMealTiming = widget.food.meal_timing!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      for (var key in setValue) {
        selectedValues[key] = cleanedMealTiming.contains(key);
      }
    }

    if (widget.food.meal_take != null) {
      final cleanedMealTiming = widget.food.meal_take!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      for (var key in setValue) {
        selectedValues[key] = cleanedMealTiming.contains(key);
      }
    }

    selectStatus = {for (final k in setValueStatus) k: false};

    const kUseNowLabel = 'ให้อาหารทันที';

    final useNowRaw = (widget.food.use_now ?? '').toString().trim();
    final isUseNow = useNowRaw == '1' || useNowRaw.toLowerCase() == 'true';

    if (isUseNow && selectStatus.containsKey(kUseNowLabel)) {
      selectStatus.updateAll((k, v) => false);
      selectStatus[kUseNowLabel] = true;
    }

    if (widget.food.take_time != null) {
      final cleaned = widget.food.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      selectedTakeTimes = cleaned;
    }

    // time slot
    selectedTimeSlot = (widget.food.time_slot ?? '').trim();
    if (selectedTimeSlot.isEmpty) selectedTimeSlot = 'กำหนดเอง';
    final idx = time.indexOf(selectedTimeSlot);
    if (idx != -1) selectedTimeIndex = idx;

    final parsed = _parseDrugSlot(widget.food.set_slot, widget.food.type_slot);

    final startFromDb = _parseStartDateUse(widget.food.start_date_use);

    _scheduleMode = parsed.mode;
    _schedule = ScheduleResult(
      mode: parsed.mode,
      modeLabel: toLabel(parsed.mode),
      weekdayNames: parsed.weeklyNames,
      dailyNote: parsed.dailyNote,
      monthlyDays: parsed.monthlyDays,
      dailyDate: (parsed.mode == ScheduleMode.dailyCustom) ? startFromDb : null,
      monthlyDate: null,
    );

    selectedDay.updateAll((k, v) => false);

    final mode = _scheduleMode;
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

  void initDoctors() {
    setState(() {
      FoodItems = ListDoctors.map((doctor) {
        return DropdownMenuItem<DoctorModel>(
          value: doctor,
          child: Text('${doctor.prename} ${doctor.full_nameth}',
              style: const TextStyle(fontSize: 12)),
        );
      }).toList();
    });
    checkIsEnabled();

    tFoodName.addListener(checkIsEnabled);
    tFoodQty.addListener(checkIsEnabled);
    tFoodUnitQty.addListener(checkIsEnabled);
    tFoodDose.addListener(checkIsEnabled);
    tFoodUnit.addListener(checkIsEnabled);
    // tFoodCondition.addListener(checkIsEnabled);
  }

  @override
  void dispose() {
    tFoodName.dispose();
    tFoodDose.dispose();
    tFoodProperties.dispose();
    // tFoodCondition.dispose();
    tFoodQty.dispose();
    tFoodUnit.dispose();
    tFoodUnitQty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _parseDrugSlot(widget.food.set_slot, widget.food.type_slot);
    _parseStartDateUse(widget.food.start_date_use);

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
          textField1('หมายเหตุอื่นๆ', controller: tFoodNote),
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
            key: ValueKey(
                'create_sched_${isPRN ? 'prn' : 'normal'}_${_scheduleMode ?? 'none'}'),
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          TimeSelection(
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
                  final startDt = _buildStartDateFromSchedule(
                    _schedule,
                    orderDate: widget.food.order_date,
                    initialStart: widget.food.start_date_use,
                  );

                  String status = '0';

                  if (selectStatus['ให้อาหารทันที'] == true) {
                    status = '1';
                  }
                  final bool isPRN = selectedTimeSlot == 'เมื่อมีอาการ';
                  final String typeSlot =
                      isPRN ? 'ALL' : _typeSlotFromMode(_scheduleMode!);
                  final String? setSlot = (typeSlot == 'ALL')
                      ? null
                      : buildSetSlot(_schedule, weeklyAsNumber: false);
                  final String takeTime = (typeSlot == 'ALL')
                      ? '[]'
                      : "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]";
                  // final typeSlot = _typeSlotFromMode(_scheduleMode);
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
                      meal_take: selectedValues.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .join(','),
                      // meal_take: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),
                      // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                      // type_slot: _typeSlotFromMode(_scheduleMode),
                      schedule_mode_label:
                          _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                      use_now: status,
                      // doctor_eid: selectedDoctor?.employee_id,
                      start_date_use:
                          DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                      start_date_imed: widget.food.order_date,
                      // take_time:
                      //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,
                      meal_timing: selectedValues.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .join(','),
                      order_item_id: widget.food.order_item_id,

                      set_slot: setSlot,
                      type_slot: typeSlot,
                      take_time: takeTime,
                    );

                    final updatedDrug = UpdateOrderModel(
                      id: int.tryParse(widget.food.order_item_id ?? '') ?? 0,
                      item_name: data.item_name,
                      item_qty: data.item_qty,
                      unit_name: data.unit_name,
                      dose_qty: data.dose_qty,
                      // meal_timing: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),
                      drug_instruction: data.drug_instruction ?? '',
                      // take_time: data.take_time ?? '[]',
                      start_date_use:
                          DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                      end_date_use: data.end_date_use ?? '',
                      stock_out: data.stock_out,
                      remark: data.remark ?? '',
                      meal_take: selectedValues.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .join(','),
                      caution: data.caution.toString(),
                      drug_description: data.drug_description ?? '',
                      drug_type_name: data.drug_type_name ?? '',
                      time_slot: data.time_slot ?? '',
                      unit_stock: data.unit_stock ?? '',
                      // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                      // type_slot: _typeSlotFromMode(_scheduleMode),
                      status: data.status ?? 'Order',
                      tl_common_users_id: widget.lUserLogin?.first.id ?? 0,
                      // meal_take: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),

                      set_slot: setSlot,
                      type_slot: typeSlot,
                      take_time: takeTime,
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
                      schedule_mode_label:
                          _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                      meal_take: selectedValues.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .join(','),
                      order_eid: widget.food.order_eid,
                      item_code: widget.food.item_code,
                      order_date: widget.food.order_date,
                      order_time: widget.food.order_time,
                      // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                      // type_slot: _typeSlotFromMode(_scheduleMode),
                      use_now: status,
                      // doctor_eid: selectedDoctor?.employee_id,
                      start_date_use:
                          DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                      start_date_imed: widget.food.order_date,
                      remark: tFoodNote.text,
                      // meal_take: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),
                      // meal_timing: selectedValues.entries
                      //     .where((entry) => entry.value)
                      //     .map((entry) => entry.key)
                      //     .join(','),

                      // take_time:
                      //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                      time_slot: selectedTimeSlot,

                      set_slot: setSlot,
                      type_slot: typeSlot,
                      take_time: takeTime,
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
    final hasBasics = tFoodName.text.trim().isNotEmpty &&
        tFoodQty.text.trim().isNotEmpty &&
        tFoodUnitQty.text.trim().isNotEmpty &&
        tFoodDose.text.trim().isNotEmpty &&
        tFoodUnit.text.trim().isNotEmpty;

    final mealOk = selectedValues.containsValue(true);
    final scheduleOk = isPRN ? true : _isScheduleDetailValid();

    final timeOk = _isTimeOk();

    final ok = hasBasics && mealOk && scheduleOk && timeOk;

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
