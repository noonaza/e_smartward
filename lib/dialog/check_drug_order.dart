// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/search_dropdown.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:e_smartward/widget/text.dart';

// ignore: must_be_immutable
class CheckDrugOrderDialog extends StatefulWidget {
  String screen;
  final DataAddOrderModel drug;
  Map<String, String> headers;
  final int indexDrug;
  final Function(DataAddOrderModel updatedDrug, int index_) cb;
  final ListPetModel mPetAdmit;
  final ListAnModel mListAn;
  final ListUserModel mUser;
  final VoidCallback onConfirmed;

  CheckDrugOrderDialog({
    super.key,
    required this.screen,
    required this.drug,
    required this.headers,
    required this.indexDrug,
    required this.cb,
    required this.mPetAdmit,
    required this.mListAn,
    required this.mUser,
    required this.onConfirmed,
  });

  @override
  State<CheckDrugOrderDialog> createState() => _CheckDrugOrderDialogState();

  static void show(
    BuildContext context,
    DataAddOrderModel drug,
    int index_,
    Function(DataAddOrderModel updatedDrug, int index_) cb_,
    Map<String, String> headers, {
    required String screen,
    required ListPetModel mPetAdmit,
    required ListAnModel mListAn,
    required ListUserModel mUser,
    required VoidCallback onConfirmed,
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
      customHeader: Image.asset(
        'assets/gif/medicin.gif',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
      body: CheckDrugOrderDialog(
        screen: screen,
        drug: drug,
        indexDrug: index_,
        onConfirmed: onConfirmed,
        cb: cb_,
        headers: headers,
        mPetAdmit: mPetAdmit,
        mListAn: mListAn,
        mUser: mUser,
      ),
    ).show();
  }
}

class _CheckDrugOrderDialogState extends State<CheckDrugOrderDialog> {
  TextEditingController tDrudName = TextEditingController();
  TextEditingController tDrugDose = TextEditingController();
  TextEditingController tDrugCondition = TextEditingController();
  TextEditingController tUnit = TextEditingController();
  TextEditingController tDrugTime = TextEditingController();
  TextEditingController tproperties = TextEditingController();
  TextEditingController tnote = TextEditingController();
  TextEditingController tdoctor = TextEditingController();
  TextEditingController ttimeHour = TextEditingController();
  TextEditingController tDescription = TextEditingController();
  TextEditingController tDrugUnit = TextEditingController();
  TextEditingController tDrugQty = TextEditingController();
  TextEditingController tDrugUnitQty = TextEditingController();
  TextEditingController tSearchDoctor = TextEditingController();

  ScheduleMode? _scheduleMode;
  ScheduleResult? _schedule; // ถ้าอยากเก็บรายละเอียดอื่น ๆ จากตัวเลือก

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

  Map<String, bool> selectStatus = {
    'รอของหมด': false,
  };
  List<String> setValueStatus = [
    'รอของหมด',
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

  Map<String, bool> selectStatusd = {
    'ให้ยาทันที': false,
  };
  List<String> setValueStatusd = [
    'ให้ยาทันที',
  ];

  bool isEnabled = false;
  List<DropdownMenuItem<DoctorModel>> drugItems = [];
  bool hasNewOrders = false;
  DoctorModel? selectedDoctor;

  List<DoctorModel> ListDoctors = [];

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

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });

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

  List<bool> selected = [];
  List<bool> selectedTimeList = [];
  int? selectedTimeIndex;
  String? selectedTypeDrug;
  String selectedTimeSlot = '';

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

  bool get isPRN => selectedTimeSlot == 'เมื่อมีอาการ';

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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 40), () async {
      ListDoctors =
          await AdmitApi().loadDataDoctor(context, headers_: widget.headers);

      final matchedDoctors = ListDoctors.where(
        (doctor) => doctor.employee_id == widget.drug.doctor_eid,
      ).toList();

      if (matchedDoctors.isNotEmpty) {
        selectedDoctor = matchedDoctors.first;
      } else {
        selectedDoctor = null;
      }

      initDoctors();
    });

    // selectedDoctor = DoctorModel(
    //   employee_id: 'dddd',
    //   employee_nameen: 'dddd',
    //   full_nameth: widget.drug.doctor_eid,
    //   key_search: 'dddd',
    //   prename: 'dddd',
    // );

    tDrudName.text = widget.drug.item_name ?? '';
    tDrugDose.text = widget.drug.dose_qty?.toString() ?? '';
    tDrugCondition.text = widget.drug.drug_description ?? '';
    tDrugUnit.text = widget.drug.unit_name?.toString() ?? '';
    tnote.text = widget.drug.drug_instruction ?? '';

    tDrugQty.text = widget.drug.item_qty?.toString() ?? '';
    tDrugUnitQty.text = widget.drug.unit_name?.toString() ?? '';
    tdoctor.text = widget.drug.doctor_eid ?? '';
    tproperties.text = widget.drug.drug_description ?? '';
    selectedTypeDrug = widget.drug.drug_type_name;

    tDrugUnit.addListener(() {
      tDrugUnitQty.text = tDrugUnit.text;
    });

    tDrugUnit.addListener(() {
      tDrugUnitQty.text = tDrugUnit.text;
    });

    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    if (widget.drug.meal_timing != null) {
      final mealTimingRaw = widget.drug.meal_timing!;
      final cleanedMealTiming = mealTimingRaw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (var key in setValue) {
        selectedValues[key] = cleanedMealTiming.contains(key);
      }
    }
    if (widget.drug.take_time != null) {
      final cleaned = widget.drug.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .toList();
      selectedTakeTimes = cleaned;
    }

    selectedTimeSlot = widget.drug.time_slot ?? 'กำหนดเอง';
    if (selectedTimeSlot.isEmpty) {
      selectedTimeSlot = 'กำหนดเอง';
    }

    final index = time.indexOf(selectedTimeSlot);
    if (index != -1) {
      selectedTimeIndex = index;
    }
  }

  initDoctors() {
    setState(() {
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
    checkIsEnabled();

    tDrudName.addListener(checkIsEnabled);
    tDrugQty.addListener(checkIsEnabled);
    tDrugUnitQty.addListener(checkIsEnabled);
    tDrugDose.addListener(checkIsEnabled);
    tDrugUnit.addListener(checkIsEnabled);
    tDrugCondition.addListener(checkIsEnabled);
    tnote.addListener(checkIsEnabled);
  }

  @override
  void dispose() {
    tDrudName.dispose();
    tDrugDose.dispose();
    tproperties.dispose();
    tDrugCondition.dispose();
    tnote.dispose();
    tDrugQty.dispose();
    tDrugUnit.dispose();
    tDrugUnitQty.dispose();
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
                    controller: tDrugUnit,
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
                child: textField1('หน่วยให้', controller: tDrugUnitQty),
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
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tDrugCondition),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tnote),
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
                  tdoctor.text =
                      '${value?.employee_id ?? ''} : ${value?.full_nameth ?? ''}';
                });
              },
              hintLabel: 'เลือกชื่อแพทย์ที่ทำการสั่งยา',
              labelInSearch: 'ค้นหาชื่อหรือรหัสแพทย์',
            ),
          ),
          const SizedBox(height: 10),
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
                            selectedValues[key] = selected;
                          });
                          checkIsEnabled();
                        });
                  }).toList()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                            color:
                                isSelected ? Colors.teal : Colors.teal.shade200,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 5),
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
                  SizedBox(
                    width: 5,
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: setValueStatusd.map((key) {
                      final isSelected = selectStatusd[key] ?? false;

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
                            color:
                                isSelected ? Colors.teal : Colors.teal.shade200,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 5),
                        onSelected: (selected) {
                          setState(() {
                            selectStatusd.updateAll((key, value) => false);
                            selectStatusd[key] = selected;
                          });
                          checkIsEnabled();
                        },
                      );
                    }).toList(),
                  ),
                ],
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

                String statusd = '0';

                if (selectStatusd['ให้ยาทันที'] == true) {
                  statusd = '1';
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
                // final selectedStatusList = selectStatus.entries
                //     .where((entry) => entry.value)
                //     .map((entry) => entry.key)
                //     .toList();

                String status = 'Order';
                if (selectStatus['รอของหมด'] == true) {
                  status = 'Pending';
                }
                // final typeSlot = _typeSlotFromMode(_scheduleMode!);
                if (widget.screen == 'imedx') {
                  final newOrder = DataAddOrderModel(
                    item_name: tDrudName.text,
                    dose_qty: tDrugDose.text,
                    unit_name: tDrugUnit.text,
                    item_qty: tDrugQty.text,
                    unit_stock: tDrugUnitQty.text,
                    drug_type_name: selectedTypeDrug,
                    order_date: widget.drug.order_date,
                    order_time: widget.drug.order_time,
                    order_eid: widget.drug.order_eid,
                    item_code: widget.drug.item_code,
                    order_item_id: widget.drug.order_item_id,
                    drug_description: tDrugCondition.text,
                    status: statusd,
                    remark: tnote.text,
                    stock_out: 0,
                    use_now: status,
                    schedule_mode_label:
                        _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
                    doctor_eid: selectedDoctor?.employee_id,
                    start_date_use:
                        DateFormat('yyyy-MM-dd HH:mm').format(startDt),
                    // set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
                    // type_slot: _typeSlotFromMode(_scheduleMode!),
                    start_date_imed:
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    meal_timing: selectedValues.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .join(','),
                    // take_time:
                    //     "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                    time_slot: selectedTimeSlot,

                    set_slot: setSlot,
                    type_slot: typeSlot,
                    take_time: takeTime,
                  );

                  final lDataOrder = AddOrderDrug([newOrder]);
                  await RoundWardApi().AddOrder(
                    context,
                    headers_: widget.headers,
                    mUser: widget.mUser,
                    mPetAdmit_: widget.mPetAdmit,
                    mListAn_: widget.mListAn,
                    lDataOrder_: lDataOrder,
                  );

                  final newOrders = await RoundWardApi().loadNewOrder(
                    context,
                    mPetAdmit_: widget.mPetAdmit,
                    headers_: widget.headers,
                  );

                  if (mounted) {
                    setState(() {
                      hasNewOrders = newOrders.isNotEmpty;
                    });
                  }

                  widget.onConfirmed();
                  return;
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

  // void checkIsEnabled() {
  //   setState(() {
  //     isEnabled = tDrudName.text.trim().isNotEmpty &&
  //         tDrugQty.text.trim().isNotEmpty &&
  //         tDrugUnitQty.text.trim().isNotEmpty &&
  //         tDrugDose.text.trim().isNotEmpty &&
  //         tDrugUnit.text.trim().isNotEmpty &&
  //         selectedTypeDrug != null &&
  //         selectedDoctor != null &&
  //         selectedValues.containsValue(true) &&
  //         (selectedTimeSlot.isNotEmpty &&
  //             (selectedTimeSlot == 'เมื่อมีอาการ' ||
  //                 selectedTakeTimes.isNotEmpty));
  //   });
  // }

  List<DataAddOrderModel> AddOrderDrug(List<DataAddOrderModel> lDrug) {
    final startDt = _buildStartDateFromSchedule(
      _schedule,
      orderDate: widget.drug.order_date,
      initialStart: widget.drug.start_date_use,
    );
    return lDrug.map((e) {
      final typeSlot = _typeSlotFromMode(_scheduleMode!);
      return DataAddOrderModel(
        item_name: e.item_name,
        type_card: 'Drug',
        item_qty: e.item_qty?.toString(),
        unit_name: e.unit_name,
        dose_qty: e.dose_qty.toString(),
        drug_instruction: e.drug_instruction,
        take_time: e.take_time ?? '[]',
        meal_timing: e.meal_timing ?? '',
        start_date_use: DateFormat('yyyy-MM-dd HH:mm').format(startDt),
        end_date_use: e.end_date_use,
        stock_out: 0,
        remark: e.remark ?? '',
        order_item_id: e.order_item_id,
        doctor_eid: selectedDoctor?.employee_id,
        item_code: e.item_code,
        note_to_team: e.note_to_team,
        caution: e.caution,
        drug_description: e.drug_description,
        order_eid: e.order_eid,
        order_date: e.order_date,
        order_time: e.order_time,
        set_slot: buildSetSlot(_schedule, weeklyAsNumber: false),
        schedule_mode_label:
            _schedule?.modeLabel ?? labelFromTypeSlot(typeSlot),
        type_slot: _typeSlotFromMode(_scheduleMode!),
        start_date_imed: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        time_slot: e.time_slot,
        drug_type_name: e.drug_type_name,
        unit_stock: e.unit_stock,
        status: e.status,
      );
    }).toList();
  }
}
