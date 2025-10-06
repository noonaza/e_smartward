// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/roundward_api.dart';
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
  bool isEnabled = false;
  List<DropdownMenuItem<DoctorModel>> drugItems = [];
  bool hasNewOrders = false;
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
          TimeSelection(
            time: time,
            timeList: timeList,
            initialTakeTimes: selectedTakeTimes,
            initialTimeSlot: selectedTimeSlot,
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
                // final selectedStatusList = selectStatus.entries
                //     .where((entry) => entry.value)
                //     .map((entry) => entry.key)
                //     .toList();

                String status = 'Order';

                if (selectStatus['รอของหมด'] == true) {
                  status = 'Pending';
                }
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
                    status: status,
                    remark: tnote.text,
                    stock_out: 0,
                    doctor_eid: selectedDoctor?.employee_id,
                    start_date_use: DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now()),
                    meal_timing: selectedValues.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .join(','),
                    take_time:
                        "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                    time_slot: selectedTimeSlot,
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
    setState(() {
      isEnabled = tDrudName.text.trim().isNotEmpty &&
          tDrugQty.text.trim().isNotEmpty &&
          tDrugUnitQty.text.trim().isNotEmpty &&
          tDrugDose.text.trim().isNotEmpty &&
          tDrugUnit.text.trim().isNotEmpty &&
          selectedTypeDrug != null &&
          selectedDoctor != null &&
          selectedValues.containsValue(true) &&
          (selectedTimeSlot.isNotEmpty &&
              (selectedTimeSlot == 'เมื่อมีอาการ' ||
                  selectedTakeTimes.isNotEmpty));
    });
  }

  List<DataAddOrderModel> AddOrderDrug(List<DataAddOrderModel> lDrug) {
    return lDrug.map((e) {
      return DataAddOrderModel(
        item_name: e.item_name,
        type_card: 'Drug',
        item_qty: e.item_qty?.toString(),
        unit_name: e.unit_name,
        dose_qty: e.dose_qty.toString(),
        drug_instruction: e.drug_instruction,
        take_time: e.take_time ?? '[]',
        meal_timing: e.meal_timing ?? '',
        start_date_use: e.start_date_use,
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
        time_slot: e.time_slot,
        drug_type_name: e.drug_type_name,
        unit_stock: e.unit_stock,
        status: e.status,
      );
    }).toList();
  }
}
