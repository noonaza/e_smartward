// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:intl/intl.dart';

class EditDrugDialog extends StatefulWidget {
  final ListDataCardModel drug;
  final int indexDrug;
  final Function(ListDataCardModel updatedDrug, int index_) cb;

  const EditDrugDialog({
    super.key,
    required this.drug,
    required this.indexDrug,
    required this.cb,
  });

  @override
  State<EditDrugDialog> createState() => _EditDetailDialogState();

  static void show(
    BuildContext context,
    ListDataCardModel drug,
    int index_,
    Function(ListDataCardModel updatedDrug, int index_) cb_,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: MediaQuery.of(context).size.width * 0.5,
      dismissOnTouchOutside: false,
      customHeader: Image.asset(
        'assets/gif/medicin.gif',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
      body: EditDrugDialog(
        drug: drug,
        indexDrug: index_,
        cb: cb_,
      ),
    ).show();
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
  TextEditingController tdoctor = TextEditingController();
  TextEditingController ttimeHour = TextEditingController();
  TextEditingController tDescription = TextEditingController();
  TextEditingController tDrugUnit = TextEditingController();
  TextEditingController tDrugQty = TextEditingController();

  List<String> typeDrug = [
    'ยาเม็ด',
    'ยาหยอดตา',
    'ยาหยอดหู',
    'ยาฉีด',
    'ยาน้ำ',
    'ยาทา (ยาภายนอก)',
  ];
  List<String> setValue = [
    'ก่อนอาหาร',
    'หลังอาหาร',
  ];
  Map<String, bool> selectedValues = {
    'ก่อนอาหาร': false,
    'หลังอาหาร': false,
  };
  List<String> selectedTakeTimes = [];
  List<String> initialTakeTimes = []; // เก็บค่าที่โหลดมาครั้งแรก
  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'กำหนดเอง',
  ];

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
    tDrudName.text = widget.drug.item_name ?? '';
    tDrugDose.text = widget.drug.dose_qty?.toString() ?? '';
    tDrugCondition.text = widget.drug.drug_description ?? '';
    tnote.text = widget.drug.note_to_team ?? '';
    tDrugQty.text = widget.drug.item_qty?.toString() ?? '';
    tDrugUnit.text = widget.drug.unit_name?.toString() ?? '';
    tdoctor.text = widget.drug.doctor_eid ?? '';
    tproperties.text = widget.drug.drug_description ?? '';
    selectedTypeDrug = widget.drug.drug_type_name;

    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    if (widget.drug.meal_timing != null) {
      final selectedMeals = widget.drug.meal_timing!.split(',');
      selectedValues = {
        for (var val in setValue) val: selectedMeals.contains(val),
      };
    }
    if (widget.drug.take_time != null) {
      final cleaned = widget.drug.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .toList();
      selectedTakeTimes = cleaned;
    }

    selectedTimeSlot = widget.drug.time_slot ?? '';
    if (selectedTimeSlot.isNotEmpty) {
      final index = time.indexOf(selectedTimeSlot);
      if (index != -1) {
        selectedTimeIndex = index;
      }
    }
  }

  @override
  void dispose() {
    tDrudName.dispose();
    tDrugDose.dispose();
    tproperties.dispose();
    tDrugCondition.dispose();
    tnote.dispose();
    tdoctor.dispose();
    tDrugQty.dispose();
    tDrugUnit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = selectedTakeTimes.isNotEmpty;
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
                child: textField1('จำนวน', controller: tDrugQty),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1('วิธีให้', controller: tDrugDose),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: textField1('หน่วย', controller: tDrugUnit),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
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
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งยา', controller: tdoctor),
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
                        });
                  }).toList()),
            ],
          ),
          const SizedBox(height: 15),
          TimeSelection(
            time: time,
            timeList: timeList,
            selectedMealTiming: selectedValues.entries
                .firstWhere((e) => e.value, orElse: () => MapEntry('', false))
                .key,
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
              action: (controller) {
                final updatedDrug = ListDataCardModel(
                  item_name: tDrudName.text,
                  dose_qty: double.tryParse(tDrugDose.text) ?? 0,
                  item_qty: int.tryParse(tDrugQty.text) ?? 0,
                  unit_name: tDrugUnit.text,
                  drug_type_name: selectedTypeDrug,
                  drug_description: tDrugCondition.text,
                  note_to_team: tnote.text,
                  doctor_eid: tdoctor.text,
                  start_date_use: DateFormat('yyyy-MM-dd').format(DateTime.now()),

                  meal_timing: selectedValues.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .join(','),
                  take_time:
                      "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                  time_slot: selectedTimeSlot,
                );

                widget.cb(updatedDrug, widget.indexDrug);
                Navigator.of(context).pop();
              },
            ),
          ),
          )
        ],
      ),
    );
  }
}
