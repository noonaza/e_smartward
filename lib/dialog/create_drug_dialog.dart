// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:e_smartward/widgets/text.copy';

// ignore: must_be_immutable
class CreateDrugDialog extends StatefulWidget {
  Map<String, String> headers;
  CreateDrugDialog({
    Key? key,
    required this.headers,
  }) : super(key: key);

  @override
  State<CreateDrugDialog> createState() => _CreateDrugDialogState();

  static void show(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: MediaQuery.of(context).size.width * 0.5,
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
      body: CreateDrugDialog(headers: {}),
    ).show();
  }
}

class _CreateDrugDialogState extends State<CreateDrugDialog> {
  TextEditingController tDrudName = TextEditingController();
  TextEditingController tDrugDose = TextEditingController();
  TextEditingController tDrugCondition = TextEditingController();
  TextEditingController tDrugTime = TextEditingController();
  List<String> typeDrug = [
    'ยาหยอด',
    'ยาฉีด (วัคซีน และ ยาฉีดอื่นๆ)',
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCloseButton(context),
          const SizedBox(height: 5),
          textField1('ชื่อยา', controller: tDrudName),
          const SizedBox(height: 10),
          textField1('วิธีให้', controller: tDrugDose),
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
          textField1('สรรพคุณ', controller: tDrudName),
          const SizedBox(height: 10),
          textField1('หมายเหตุอื่นๆ', controller: tDrudName),
          const SizedBox(height: 10),
          textField1('ชื่อแพทย์ที่ทำการสั่งยา', controller: tDrudName),
          const SizedBox(height: 15),
          TimeSelection(
            time: time,
            timeList: timeList,
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
                CreateCardDetail();
                // final newDrug = ListDataCardModel(
                //   item_name: 'ยาใหม่',
                //   dose_qty: '10 mg',
                //   dose_unit_name: 'เม็ด',
                //   drug_type_name: 'ยา',
                //   drug_instruction: 'ทานหลังอาหาร',

                //   // item_name: tDrudName.text,
                //   // dose_qty: tDrugDose.text,
                //   // dose_unit_name: selectedTypeDrug,
                //   // drug_type_name: selectedTypeDrug,
                //   // drug_instruction: time,
                // );

                // ปิด dialog และส่งค่ากลับ
                Navigator.pop(
                  context,
                );
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Future CreateCardDetail() async {
    final Map<String, dynamic> requestData = {
      "hn_number": "R8-160993-04",
      "an_number": "IR9-67-036974",
      "visit_number": "824121113541314501",
      "pet_name": "Cheesecake",
      "tl_common_users_id": "4785",
      "data_drug": [
        {
          "card_name": "TRAMADOL HCI 50MG (1X100) tab (TAB)",
          "total_order": "9",
          "unit": "เม็ด",
          "dose": 1.5,
          "take_name":
              "รับประทานครั้งละ 1 เม็ด + 1 ชิ้นวันละ 2 ครั้ง หลังอาหาร  เช้า เย็น",
          "take_time": ["08:00", "18:00"],
          "start_date": "2024-12-17",
          "end_date": "2024-12-20",
          "stock_out": 0,
          "remark": "test ยา",
          "order_item_id": "824121716373914401",
          "doctor_eid": "สพ.ญ.ออมอุสาห์ กัวหา",
          "item_code": "T-MABR",
          "note_team":
              "รับประทานครั้งละ 1.5 เม็ด\r\nวันละ 2 ครั้ง หลังอาหาร  เช้า เย็น",
          "caution": "",
          "properties": "บรรเทาอาการปวด",
          "verify_eid": "สพ.ญ.ออมอุสาห์ กัวหา",
          "verify_date": "2024-12-17",
          "verify_time": "16:37:39"
        },
        {
          "card_name": "YunnanBaiyaoJiaonang/tab16's_เขียว (TAB)",
          "total_order": "6",
          "unit": "เม็ด",
          "dose": 1,
          "take_name":
              "รับประทานครั้งละ 1 เม็ดวันละ 2 ครั้ง ก่อนอาหาร  เช้า เย็น",
          "take_time": ["09:00", "17:00"],
          "start_date": "2024-12-17",
          "end_date": "2024-12-20",
          "stock_out": 0,
          "remark": "test ยา2",
          "order_item_id": "824121716375363001",
          "doctor_eid": "สพ.ญ.ออมอุสาห์ กัวหา",
          "item_code": "T-YUNN-3",
          "note_team": "",
          "caution": "สำหรับน้ำหนัก 15-25 กก./cap.",
          "properties": "ยาสมุนไพรจีน ช่วยห้ามเลือด บรรเทาอาการปวด ลดการอักเสบ",
          "verify_eid": "สพ.ญ.ออมอุสาห์ กัวหา",
          "verify_date": "2024-12-17",
          "verify_time": "16:37:39"
        }
      ],
      "data_food": [
        {
          "card_name": "Dog_Wet_RC_Gastrointestinal Low Fat_420g_24515",
          "total_order": "2",
          "unit": "กระป๋อง",
          "dose": null,
          "take_name": "",
          "take_time": ["08:00", "18:00"],
          "start_date": "",
          "end_date": "",
          "stock_out": 0,
          "remark": "test อาหาร",
          "order_item_id": "825012718100088001",
          "doctor_eid": "",
          "item_code": "2-223-24515",
          "note_team": "",
          "caution": "",
          "properties": "",
          "verify_eid": "คุณวาสนา ตอแคะ(R9)",
          "verify_date": "2025-01-27",
          "verify_time": "18:10:00"
        }
      ],
      "data_observe": [
        {
          "card_name": "ตรวจอุจจาระ",
          "total_order": "1",
          "unit": "0",
          "dose": null,
          "take_name": "",
          "take_time": [
            "00:00",
            "03:00",
            "06:00",
            "09:00",
            "12:00",
            "15:00",
            "18:00",
            "21:00"
          ],
          "start_date": "",
          "end_date": "",
          "stock_out": 0,
          "remark": "test ตรววจอาการ",
          "order_item_id": "",
          "doctor_eid": "",
          "item_code": "",
          "note_team": "",
          "caution": "",
          "properties": "",
          "verify_eid": "",
          "verify_date": "",
          "verify_time": ""
        }
      ]
    };

    String api = '${TlConstant.syncApi}/create_admit';
    final dio = Dio();
    final response = await dio.post(
      api,
      options: Options(
        headers: widget.headers,
      ),
      data: requestData,
    );

    try {
      String api = '${TlConstant.syncApi}/create_admit';
      final dio = Dio();
      final response = await dio.post(
        api,
        options: Options(
          headers: widget.headers,
        ),
        data: requestData,
      );

      if (response.statusCode == 200 && response.data['code'] == 1) {
        print("Create success: ${response.data}");
      } else {
        print("Create failed: ${response.data}");
      }
    } catch (e) {
      print("Error sending request: $e");
    }
  }
}
