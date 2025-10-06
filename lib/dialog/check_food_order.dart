// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';

// ignore: must_be_immutable
class CheckFoodOrderDialog extends StatefulWidget {
  String screen;
  final DataAddOrderModel food;
  Map<String, String> headers;
  final int indexfood;
  final Function(DataAddOrderModel updatedfood, int index_) cb;
  final ListPetModel mPetAdmit;
  final ListAnModel mListAn;
  final ListUserModel mUser;
  final VoidCallback onConfirmed;
  Function cbConfirm;

  CheckFoodOrderDialog({
    Key? key,
    required this.screen,
    required this.food,
    required this.headers,
    required this.indexfood,
    required this.cb,
    required this.mPetAdmit,
    required this.mListAn,
    required this.mUser,
    required this.onConfirmed,
    required this.cbConfirm,
  }) : super(key: key);

  @override
  State<CheckFoodOrderDialog> createState() => _CheckFoodOrderDialogState();

  static void show(
    BuildContext context,
    DataAddOrderModel food,
    int index_,
    Function(DataAddOrderModel updatedfood, int index_) cb_,
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
        'assets/gif/eat.gif',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
      body: CheckFoodOrderDialog(
        screen: screen,
        food: food,
        indexfood: index_,
        onConfirmed: onConfirmed,
        cb: cb_,
        headers: headers,
        mPetAdmit: mPetAdmit,
        mListAn: mListAn,
        mUser: mUser,
        cbConfirm: () {},
      ),
    ).show();
  }
}

class _CheckFoodOrderDialogState extends State<CheckFoodOrderDialog> {
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
  ];
  Map<String, bool> selectStatus = {
    'รอของหมด': false,
  };
  List<String> setValueStatus = [
    'รอของหมด',
  ];
  Map<String, bool> selectedValues = {
    'ก่อนอาหาร': false,
    'หลังอาหาร': false,
  };
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
  List<DropdownMenuItem<DoctorModel>> foodItems = [];
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
    tFoodName.text = widget.food.item_name ?? '';
    tFoodDose.text = widget.food.dose_qty?.toString() ?? '';
    tFoodCondition.text = widget.food.drug_description ?? '';
    tFoodNote.text = widget.food.remark ?? '';
    tFoodQty.text = widget.food.item_qty?.toString() ?? '';
    tFoodUnit.text = widget.food.unit_name?.toString() ?? '';
    tFoodUnitQty.text = widget.food.unit_stock ?? '';
    selectedTypeDrug = widget.food.drug_type_name;
    if (selectedTypeDrug != null && !typeDrug.contains(selectedTypeDrug)) {
      typeDrug.add(selectedTypeDrug!);
    }

    if (widget.food.take_time != null) {
      final cleaned = widget.food.take_time!
          .replaceAll(RegExp(r"[\[\]']"), '')
          .split(',')
          .map((e) => e.trim())
          .toList();
      selectedTakeTimes = cleaned;
    }
    selectedTimeSlot = widget.food.time_slot ?? 'กำหนดเอง';
    if (selectedTimeSlot.isEmpty) {
      selectedTimeSlot = 'กำหนดเอง';
    }

    final index = time.indexOf(selectedTimeSlot);
    if (index != -1) {
      selectedTimeIndex = index;
    }

    checkIsEnabled();
  }

  void checkNull() {
    checkIsEnabled();
    tFoodName.addListener(checkIsEnabled);
    tFoodQty.addListener(checkIsEnabled);
    tFoodUnitQty.addListener(checkIsEnabled);
    tFoodDose.addListener(checkIsEnabled);
    tFoodUnit.addListener(checkIsEnabled);
    tFoodNote.addListener(checkIsEnabled);
  }

  @override
  void dispose() {
    tFoodName.dispose();
    tFoodDose.dispose();
    tFoodProperties.dispose();
    tFoodCondition.dispose();
    tFoodNote.dispose();
    tFoodQty.dispose();
    tFoodUnit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isEnabled =
    //     selectedTakeTimes.isNotEmpty || selectedTimeSlot == 'กำหนดเอง';
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
                child: textField1('วิธีให้', controller: tFoodDose),
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
          textField1('วิธีเตรียมอาหาร / หมายเหตุอื่นๆ', controller: tFoodNote),
          // const SizedBox(height: 15),
          // SizedBox(
          //   height: 35,
          //   child: Dropdown.lModel<DoctorModel>(
          //     context: context,
          //     value: selectedDoctor,
          //     items: foodItems,
          //     tController: tSearchDoctor,
          //     isSelect: true,
          //     validator: '',
          //     width: double.infinity,
          //     onChanged: (value) {
          //       setState(() {
          //         selectedDoctor = value;
          //         checkIsEnabled();
          //         tFoodDoctor.text =
          //             '${value?.employee_id ?? ''} : ${value?.full_nameth ?? ''}';
          //       });
          //     },
          //     hintLabel: 'เลือกชื่อแพทย์ที่ทำการสั่งยา',
          //     labelInSearch: 'ค้นหาชื่อหรือรหัสแพทย์',
          //   ),
          // ),
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
                      // checkIsEnabled();
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
                selectedTimeIndex = selectedIndex;
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
                String status = 'Order';

                if (selectStatus['รอของหมด'] == true) {
                  status = 'Pending';
                }
                if (widget.screen == 'imedx') {
                  final newOrder = DataAddOrderModel(
                    item_name: tFoodName.text,
                    dose_qty: tFoodDose.text,
                    unit_name: tFoodUnit.text,
                    item_qty: tFoodQty.text,
                    status: status,
                    unit_stock: tFoodUnitQty.text,
                    order_date: widget.food.order_date,
                    order_time: widget.food.order_time,
                    order_eid: widget.food.order_eid,
                    drug_type_name: selectedTypeDrug,
                    drug_description: tFoodCondition.text,
                    remark: tFoodNote.text,
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

                  final lDataOrder = AddOrderFood([newOrder]);
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
      isEnabled = tFoodName.text.trim().isNotEmpty &&
          tFoodQty.text.trim().isNotEmpty &&
          tFoodUnitQty.text.trim().isNotEmpty &&
          tFoodDose.text.trim().isNotEmpty &&
          tFoodNote.text.trim().isNotEmpty &&
          tFoodUnit.text.trim().isNotEmpty &&
          (selectedTimeSlot.isNotEmpty &&
              (selectedTimeSlot == 'เมื่อมีอาการ' ||
                  selectedTakeTimes.isNotEmpty));
    });
  }

  List<DataAddOrderModel> AddOrderFood(List<DataAddOrderModel> lFood) {
    return lFood.map((e) {
      return DataAddOrderModel(
        item_name: e.item_name,
        type_card: 'Food',
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
        // doctor_eid: e.doctor_eid,
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
        status: 'Order',
      );
    }).toList();
  }
}
