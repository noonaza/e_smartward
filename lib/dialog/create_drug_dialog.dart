// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CreateDrugDialog extends StatefulWidget {
  Map<String, String> headers;
  final Function(ListDataCardModel) onAddDrug;

  CreateDrugDialog({
    super.key,
    required this.headers,
    required this.onAddDrug,
  });

  @override
  State<CreateDrugDialog> createState() => _CreateDrugDialogState();

  static void show(
    BuildContext context, {
    required Map<String, String> headers,
    required Function(ListDataCardModel) onAddDrug_,
    required double width,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: width * 0.5,
      dismissOnTouchOutside: false,
      customHeader: Stack(
        children: [
          Image.asset(
            'assets/gif/medicin.gif',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      body: CreateDrugDialog(
        headers: headers,
        onAddDrug: onAddDrug_,
      ),
    ).show();
  }
}

class _CreateDrugDialogState extends State<CreateDrugDialog> {
  TextEditingController tDrudName = TextEditingController();
  TextEditingController tDrugDose = TextEditingController();
  TextEditingController tDrugCondition = TextEditingController();
  TextEditingController tDrugTime = TextEditingController();
  TextEditingController tDrugDescription = TextEditingController();
  TextEditingController tDrugRemark = TextEditingController();
  TextEditingController tDrugDoc = TextEditingController();
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
  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'กำหนดเอง',
  ];
  List<String> setValue = [
    'ก่อนอาหาร',
    'หลังอาหาร',
  ];
  Map<String, bool> selectedValues = {
    'ก่อนอาหาร': false,
    'หลังอาหาร': false,
  };
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

  @override
  void initState() {
    super.initState();
    selected = List.generate(time.length, (index) => false);
    selectedTimeList = List.generate(timeList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
              items: typeDrug.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: text(context, type),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          textField1('สรรพคุณ', controller: tDrugDescription),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tDrugRemark),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งยา', controller: tDrugDoc),
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
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                      onSelected: (selected) {
                        setState(() {
                          selectedValues.updateAll((key, value) => false);

                          selectedValues[key] = selected;
                        });
                      },
                    );
                  }).toList()),
            ],
          ),
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
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: actionSlider(
              context,
              'ยืนยันการให้ยาเพิ่มเติม',
              width: MediaQuery.of(context).size.width * 0.4,
              height: 30.0,
              backgroundColor: const Color.fromARGB(255, 203, 230, 252),
              togglecolor: const Color.fromARGB(255, 76, 172, 175),
              icons: Icons.check,
              iconColor: Colors.white,
              asController: ActionSliderController(),
              action: (controller) {
                final newDrug = ListDataCardModel(
                  item_name: tDrudName.text,
                  dose_qty: double.parse(
                      tDrugDose.text.isEmpty ? '0' : tDrugDose.text),
                  unit_name: tDrugUnit.text,
                  item_qty:
                      int.parse(tDrugQty.text.isEmpty ? '0' : tDrugQty.text),
                  start_date_use: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  drug_type_name: selectedTypeDrug,
                  drug_description: tDrugDescription.text,
                  remark: tDrugRemark.text,
                  
                  doctor_eid: tDrugDoc.text,
                  meal_timing: selectedValues.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .join(','),
                  take_time:
                      "[${selectedTakeTimes.map((e) => "'$e'").join(',')}]",
                  time_slot: selectedTimeSlot,
                );
                widget.onAddDrug(newDrug);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
