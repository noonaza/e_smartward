import 'package:action_slider/action_slider.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/button.dart';
import 'package:e_smartward/widget/textfield.dart';
import 'package:e_smartward/widget/time.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EditObsDialog extends StatefulWidget {
  final String obsName;
  final String obsNote;
  final List<String> obsTimes;

  const EditObsDialog({
    super.key,
    required this.obsName,
    required this.obsTimes,
    required this.obsNote,
  });

  @override
  State<EditObsDialog> createState() => _EditDetailDialogState();

  static void show(
    BuildContext context,
    String obsName,
    String obsNote,
    List<String> obsTimes,
  ) {
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
      body: EditObsDialog(
        obsName: obsName,
        obsTimes: obsTimes,
        obsNote: obsNote,
      ),
    ).show();
  }
}

class _EditDetailDialogState extends State<EditObsDialog> {
  TextEditingController tObsName = TextEditingController();
  TextEditingController tObsNote = TextEditingController();
  TextEditingController ttimeHour = TextEditingController();

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
    tObsName.text = widget.obsName;
    tObsNote.text = widget.obsNote;
  }

  @override
  void dispose() {
    tObsName.dispose();
    tObsNote.dispose();
    ttimeHour.dispose();
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
          textField1('อาการ', controller: tObsName),
          const SizedBox(height: 10),
          textField1('หมายเหตุ', controller: tObsNote),
          const SizedBox(height: 10),
          TimeSelection(
            time: time,
            timeList: timeList,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: actionSlider(
              context,
              'ยืนยันการให้อาหารเพิ่มเติม',
              width: MediaQuery.of(context).size.width * 0.4,
              height: 30.0,
              backgroundColor: const Color.fromARGB(255, 203, 230, 252),
              togglecolor: const Color.fromARGB(255, 76, 172, 175),
              icons: Icons.check,
              iconColor: Colors.white,
              asController: ActionSliderController(),
              action: (controller) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
