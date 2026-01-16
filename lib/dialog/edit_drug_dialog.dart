// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_group_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_roundward_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/Model/update_order_model.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/search_dropdown.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:e_smartward/widget/text.dart';

// ignore: must_be_immutable
class EditDrugDialog extends StatefulWidget {
  String screen;
  final ListDataCardModel drug;
  Map<String, String> headers;
  final List<ListUserModel>? lUserLogin;
  final ListRoundwardModel? mData;
  final int indexDrug;
  final String? schedule_mode_label;
  final List<ListPetModel>? lPetAdmit;
  final List<ListAnModel>? lListAn;
  final bool showNoSchedule;
  final String? drugTypeName;
  final Function(ListDataCardModel updatedDrug, int index_) cb;
  final ListGroupModel? group;
  final void Function(List<ListRoundwardModel>, bool)? onRefresh;

  EditDrugDialog({
    super.key,
    required this.screen,
    required this.drug,
    required this.headers,
    required this.indexDrug,
    required this.cb,
    this.lUserLogin,
    this.showNoSchedule = false,
    this.lPetAdmit,
    this.lListAn,
    this.drugTypeName,
    this.mData,
    this.group,
    this.onRefresh,
    this.schedule_mode_label,
  });

  @override
  State<EditDrugDialog> createState() => _EditDetailDialogState();

  static Future<void> show(
    BuildContext context,
    ListDataCardModel drug,
    int index_,
    Function(ListDataCardModel updatedDrug, int index_) cb_,
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
      dialogWidth = screenWidth * 0.5; // Desktop
    } else if (screenWidth >= 680) {
      dialogWidth = screenWidth * 0.8; // Tablet
    } else {
      dialogWidth = screenWidth * 0.9; // Mobile
    }

    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: dialogWidth,
      dismissOnTouchOutside: false,
      customHeader: Image.asset(
        'assets/gif/medicin.gif',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
      body: EditDrugDialog(
        screen: screen,
        drug: drug,
        indexDrug: index_,
        cb: cb_,
        headers: headers,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn,
        mData: mData,
        group: group,
        onRefresh: onRefresh,
      ),
    );

    await dialog.show();
  }
}

class _EditDetailDialogState extends State<EditDrugDialog> {
  TextEditingController tDrudName = TextEditingController();
  TextEditingController tDrugDose = TextEditingController();
  TextEditingController tDrugCondition = TextEditingController();
  TextEditingController tUnit = TextEditingController();
  TextEditingController tDrugTime = TextEditingController();
  TextEditingController tproperties = TextEditingController();
  TextEditingController tnote = TextEditingController();
  TextEditingController tUseImed = TextEditingController();
  TextEditingController tdoctor = TextEditingController();
  TextEditingController ttimeHour = TextEditingController();
  TextEditingController tDescription = TextEditingController();
  TextEditingController tDrugUnit = TextEditingController();
  TextEditingController tDrugQty = TextEditingController();
  TextEditingController tDrugUnitQty = TextEditingController();
  TextEditingController tSearchDoctor = TextEditingController();

  ScheduleMode? _scheduleMode;
  ScheduleResult? _schedule;

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
    'ก่อนอาหาร',
    'หลังอาหาร',
    'ไม่ระบุ',
  ];
  Map<String, bool> selectedValues = {
    'ก่อนอาหาร': false,
    'หลังอาหาร': false,
    'ไม่ระบุ': false,
  };

  List<String> setDay = [
    'กำหนดรายสัปดาห์',
    'กำหนดรายวัน',
    'กำหนดรายเดือน',
    'ไม่กำหนด',
  ];
  Map<String, bool> selectedDay = {
    'กำหนดรายสัปดาห์': false,
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

  Map<String, bool> selectStatus = {
    'ให้ยาทันที': false,
  };
  List<String> setValueStatus = [
    'ให้ยาทันที',
  ];

  List<String> selectedTakeTimes = [];
  List<String> initialTakeTimes = [];
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

  DateTime _buildStartDateFromSchedule(
    ScheduleResult? s, {
    String? orderDate,
    String? initialStart,
  }) {
    final now = DateTime.now();

    DateTime? init;
    if (initialStart != null && initialStart.trim().isNotEmpty) {
      init = _parseStartDateUse(initialStart); // รองรับ HH:mm:ss และ HH:mm
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

    if (s.isEmpty) {
      return (
        mode: ScheduleMode.weeklyOnce,
        weeklyNames: {},
        dailyNote: null,
        monthlyDays: {}
      );
    }

    switch (t) {
      case 'daily':
      case 'date':
      case 'daily_custom':
        return (
          mode: ScheduleMode.dailyCustom,
          weeklyNames: {},
          dailyNote: s,
          monthlyDays: {}
        );

      case 'weekly':
      case 'days':
      case 'weekly_once':
        return (
          mode: ScheduleMode.weeklyOnce,
          weeklyNames: _parseWeeklyNames(s),
          dailyNote: null,
          monthlyDays: {}
        );

      case 'monthly':
      case 'd_m':
      case 'monthly_custom':
        final days = _parseMonthlyDays(_looksLikeList(s) ? s : '[$s]');
        return (
          mode: ScheduleMode.monthlyCustom,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: days
        );

      case 'all':
        return (
          mode: ScheduleMode.all,
          weeklyNames: {},
          dailyNote: null,
          monthlyDays: {}
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

  void checkIsEnablede() {
    final ok = (tDrudName.text.trim().isNotEmpty) &&
        ((int.tryParse(tDrugQty.text) ?? 0) >= 0) &&
        (tDrugUnit.text.trim().isNotEmpty);
    if (ok != isEnabled) {
      setState(() => isEnabled = ok);
    }
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

  @override
  // ================== initState ==================
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 40), () async {
      ListDoctors =
          await AdmitApi().loadDataDoctor(context, headers_: widget.headers);
      final matchedDoctors =
          ListDoctors.where((d) => d.employee_id == widget.drug.doctor_eid)
              .toList();
      selectedDoctor = matchedDoctors.isNotEmpty ? matchedDoctors.first : null;
      initDoctors();
    });

    tDrudName.text = widget.drug.item_name ?? '';
    tDrugDose.text = widget.drug.dose_qty?.toString() ?? '';
    tDrugCondition.text = widget.drug.drug_description ?? '';
    tDrugUnit.text = widget.drug.unit_name?.toString() ?? '';
    tnote.text = widget.drug.remark ?? '';
    tDrugQty.text = widget.drug.item_qty?.toString() ?? '';
    tDrugUnitQty.text = widget.drug.unit_name?.toString() ?? '';
    tdoctor.text = widget.drug.doctor_eid ?? '';
    tproperties.text = widget.drug.drug_description ?? '';
    selectedTypeDrug = widget.drug.drug_type_name;

    tDrugUnit.addListener(() {
      tDrugUnitQty.text = tDrugUnit.text;
    });

    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    // มื้ออาหาร
    if (widget.drug.meal_timing != null) {
      final cleanedMealTiming = widget.drug.meal_timing!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      for (var key in setValue) {
        selectedValues[key] = cleanedMealTiming.contains(key);
      }
    }

    selectStatus = {for (final k in setValueStatus) k: false};

    const kUseNowLabel = 'ให้ยาทันที';

    final useNowRaw = (widget.drug.use_now ?? '').toString().trim();
    final isUseNow = useNowRaw == '1' || useNowRaw.toLowerCase() == 'true';

    if (isUseNow && selectStatus.containsKey(kUseNowLabel)) {
      selectStatus.updateAll((k, v) => false);
      selectStatus[kUseNowLabel] = true;
    }

    if (widget.drug.take_time != null) {
      final cleaned = widget.drug.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      selectedTakeTimes = cleaned;
    }

    // time slot
    selectedTimeSlot = (widget.drug.time_slot ?? '').trim();
    if (selectedTimeSlot.isEmpty) selectedTimeSlot = 'กำหนดเอง';
    final idx = time.indexOf(selectedTimeSlot);
    if (idx != -1) selectedTimeIndex = idx;

    final parsed = _parseDrugSlot(widget.drug.set_slot, widget.drug.type_slot);

    final startFromDb = _parseStartDateUse(widget.drug.start_date_use);

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

  void initDoctors() {
    setState(() {
      drugItems = ListDoctors.map((doctor) {
        return DropdownMenuItem<DoctorModel>(
          value: doctor,
          child: Text('${doctor.prename} ${doctor.full_nameth}',
              style: const TextStyle(fontSize: 12)),
        );
      }).toList();
    });
    checkIsEnabled();

    tDrudName.addListener(checkIsEnabled);
    tDrugQty.addListener(checkIsEnabled);
    tDrugUnitQty.addListener(checkIsEnabled);
    tDrugDose.addListener(checkIsEnabled);
    tDrugUnit.addListener(checkIsEnabled);
    tDrugCondition.addListener(checkIsEnabled);
  }

  @override
  void dispose() {
    tDrudName.dispose();
    tDrugDose.dispose();
    tproperties.dispose();
    tDrugCondition.dispose();
    tDrugQty.dispose();
    tDrugUnit.dispose();
    tDrugUnitQty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _parseDrugSlot(widget.drug.set_slot, widget.drug.type_slot);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 10),
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
                labelStyle: TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 1, 99, 87)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
              ),
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  selectedTypeDrug = newValue;
                });
                checkIsEnabled();
              },
              items: typeDrug.map((
                String type,
              ) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: text(context, type, color: Colors.teal),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          textField1('สรรพคุณ', controller: tDrugCondition),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tnote),
          const SizedBox(height: 10),
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
                  tdoctor.text =
                      '${value?.employee_id ?? ''} : ${value?.full_nameth ?? ''}';
                });
              },
              hintLabel: 'เลือกชื่อแพทย์ที่ทำการสั่งยา',
              labelInSearch: 'ค้นหาชื่อหรือรหัสแพทย์',
            ),
          ),
          const SizedBox(height: 10),
          // SchedulePicker(
          //   allowAll: false,
          //   key: ValueKey(
          //     'sched_${widget.drug.order_item_id ?? widget.indexDrug}_${widget.drug.start_date_use ?? ""}',
          //   ),
          //   initialMode: _scheduleMode,
          //   initialWeeklySelectedNames:
          //       (_schedule?.weekdayNames.isNotEmpty == true)
          //           ? _schedule!.weekdayNames
          //           : parsed.weeklyNames,
          //   initialDailyNote: _schedule?.dailyNote ?? parsed.dailyNote,
          //   initialMonthlyDate: _schedule?.monthlyDate,
          //   initialMonthlyDays: _schedule?.monthlyDays ?? parsed.monthlyDays,
          //   initialDailyDate: _schedule?.dailyDate,
          //   onChanged: (cfg) {
          //     const engToThai = {
          //       'Mon': 'จันทร์',
          //       'Tue': 'อังคาร',
          //       'Wed': 'พุธ',
          //       'Thu': 'พฤหัสบดี',
          //       'Fri': 'ศุกร์',
          //       'Sat': 'เสาร์',
          //       'Sun': 'อาทิตย์',
          //     };
          //     Set<String> toThaiSet(Iterable<String> names) =>
          //         names.map((n) => engToThai[n.trim()] ?? n.trim()).toSet();

          //     final normalized = cfg.mode == ScheduleMode.weeklyOnce
          //         ? toThaiSet(cfg.weekdayNames)
          //         : cfg.weekdayNames;

          //     setState(() {
          //       _scheduleMode = cfg.mode;
          //       _schedule = ScheduleResult(
          //         mode: cfg.mode,
          //         modeLabel: kModeLabels[cfg.mode]!,
          //         weekdayNames: normalized,
          //         dailyNote: cfg.dailyNote,
          //         monthlyDate: cfg.monthlyDate,
          //         monthlyDays: cfg.monthlyDays,
          //         dailyDate: cfg.dailyDate,
          //       );
          //     });
          //     checkIsEnabled();
          //   },
          // ),
          // const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            selectedValues.updateAll((key, value) => false);
                            selectedValues[key] = selected;
                          });
                          checkIsEnabled();
                        });
                  }).toList()),
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
          const SizedBox(height: 15),
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
          // TimeSelection(
          //   time: time,
          //   timeList: timeList,
          //   initialTakeTimes: selectedTakeTimes,
          //   initialTimeSlot: selectedTimeSlot,
          //   onSelectionChanged: (selectedIndex, selectedList) {
          //     setState(() {
          //       final idx = (selectedIndex == null ||
          //               selectedIndex < 0 ||
          //               selectedIndex >= time.length)
          //           ? 0
          //           : selectedIndex;

          //       selectedTimeSlot = time[idx];

          //       if (selectedTimeSlot == 'เมื่อมีอาการ') {
          //         selectedTakeTimes = [];
          //       } else {
          //         selectedTakeTimes = [];
          //         for (int i = 0;
          //             i < selectedList.length && i < timeList.length;
          //             i++) {
          //           if (selectedList[i]) selectedTakeTimes.add(timeList[i]);
          //         }
          //       }
          //     });
          //     checkIsEnabled();
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IgnorePointer(
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
                final startDt = _buildStartDateFromSchedule(
                  _schedule,
                  orderDate: widget.drug.order_date,
                  initialStart: widget.drug.start_date_use,
                );

                String status = '0';

                if (selectStatus['ให้ยาทันที'] == true) {
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

                if (widget.screen == 'roundward') {
                  final data = ListDataCardModel(
                    item_name: tDrudName.text,
                    dose_qty: tDrugDose.text,
                    // double.tryParse(tDrugDose.text) ?? 0,
                    unit_name: tDrugUnit.text,
                    item_qty: int.tryParse(tDrugQty.text) ?? 0,
                    unit_stock: tDrugUnitQty.text,
                    use_now: status,
                    drug_type_name: selectedTypeDrug,
                    drug_description: tDrugCondition.text,
                    remark: tnote.text,
                    stock_out: 0,
                    set_slot: setSlot,
                    type_slot: typeSlot,
                    take_time: takeTime,
                    // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    // type_slot: _typeSlotFromMode(_scheduleMode),
                    schedule_mode_label:
                        _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                    doctor_eid: selectedDoctor?.employee_id,
                    start_date_use:
                        DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                    start_date_imed: widget.drug.order_date,
                    meal_timing: selectedValues.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .join(','),
                    // take_time:
                    //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                    time_slot: selectedTimeSlot,
                    order_item_id: widget.drug.order_item_id,
                  );

                  final updatedDrug = UpdateOrderModel(
                    id: int.tryParse(widget.drug.order_item_id ?? '') ?? 0,
                    item_name: data.item_name,
                    item_qty: data.item_qty,
                    unit_name: data.unit_name,
                    dose_qty: data.dose_qty,
                    meal_timing: data.meal_timing,
                    drug_instruction: data.drug_instruction,
                    // take_time: data.take_time,
                    start_date_use:
                        DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                    end_date_use: data.end_date_use,
                    stock_out: data.stock_out,
                    remark: data.remark,
                    caution: data.caution.toString(),
                    drug_description: data.drug_description,
                    drug_type_name: data.drug_type_name,
                    time_slot: data.time_slot,
                    unit_stock: data.unit_stock,
                    status: data.status ?? 'Order',
                    // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    // type_slot: _typeSlotFromMode(_scheduleMode),
                    tl_common_users_id: widget.lUserLogin?.first.id ?? 0,
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
                  final startDt = _buildStartDateFromSchedule(
                    _schedule,
                    orderDate: widget.drug.order_date,
                    initialStart: widget.drug.start_date_use,
                  );

                  final updatedDrug = ListDataCardModel(
                    item_name: tDrudName.text,
                    dose_qty: tDrugDose.text,
                    unit_name: tDrugUnit.text,
                    item_qty: int.tryParse(tDrugQty.text) ?? 0,
                    unit_stock: tDrugUnitQty.text,
                    drug_type_name: selectedTypeDrug,
                    drug_description: tDrugCondition.text,
                    remark: tnote.text,
                    start_date_imed: widget.drug.order_date,
                    use_now: status,
                    stock_out: 0,
                    set_slot: setSlot,
                    type_slot: typeSlot,
                    take_time: takeTime,
                    order_item_id: widget.drug.order_item_id,
                    order_eid: widget.drug.order_eid,
                    item_code: widget.drug.item_code,
                    // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    // type_slot: _typeSlotFromMode(_scheduleMode),
                    schedule_mode_label:
                        _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                    order_date: widget.drug.order_date,
                    order_time: widget.drug.order_time,
                    doctor_eid: selectedDoctor?.employee_id,
                    start_date_use:
                        DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                    meal_timing: selectedValues.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .join(','),
                    // take_time:
                    //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                    time_slot: selectedTimeSlot,
                  );

                  widget.cb(updatedDrug, widget.indexDrug);
                  Navigator.of(context).pop();
                }
              }),
            ),
          )
        ],
      ),
    );
  }

  void checkIsEnabled() {
    final hasBasics = tDrudName.text.trim().isNotEmpty &&
        tDrugQty.text.trim().isNotEmpty &&
        tDrugUnitQty.text.trim().isNotEmpty &&
        tDrugDose.text.trim().isNotEmpty &&
        tDrugUnit.text.trim().isNotEmpty &&
        selectedTypeDrug != null &&
        selectedDoctor != null;

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
