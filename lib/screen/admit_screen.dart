// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/dialog/create_food_dialog.dart';
import 'package:e_smartward/dialog/create_obs_dialog.dart';
import 'package:e_smartward/dialog/edit_obs_dialog.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/dialog/create_drug_dialog.dart';
import 'package:e_smartward/dialog/edit_Food_dialog.dart';
import 'package:e_smartward/dialog/edit_drug_dialog.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/card_drug_detail.dart';
import 'package:e_smartward/widget/card_food_detail.dart';
import 'package:e_smartward/widget/card_obs_detail.dart';
import 'package:e_smartward/widget/card_pet.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class AdmitScreen extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  Map<String, String> headers;
  List<ListUserModel> lUserLogin;
  final void Function(int index) onDelete;

  AdmitScreen({
    super.key,
    required this.headers,
    required this.lUserLogin,
    required this.lDataCard,
    required this.onDelete,
  });

  @override
  _AdmitScreenState createState() => _AdmitScreenState();
}

class _AdmitScreenState extends State<AdmitScreen> {
  final GlobalKey<FoodListWidgetState> foodListKey =
      GlobalKey<FoodListWidgetState>();
  final GlobalKey<DrugListWidgetState> DrugListKey =
      GlobalKey<DrugListWidgetState>();

  List<ListDataCardModel> lDataCardDrug = [];
  List<ListDataCardModel> lDataCardFood = [];

  List<ListDataObsDetailModel> lDataCardObs = [];
  List<ListDataObsDetailModel> lSettingTime = [];
  List<String> selectedDrugTimes = [];
  List<ListPetModel> lPetAdmit = [];
  TextEditingController tHnNumber = TextEditingController();
  final List<Map<String, dynamic>> listFood = [];
  String? hnNumber;
  String? visit_id;
  bool isLoaded = false;
  int reloadCard = 0;
  bool isHideBtn = false;

  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'กำหนดเอง',
    'เมื่อมีอาการ',
  ];

  List<Map<String, String>> items = [];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });

  @override
  void initState() {
    super.initState();

    // tHnNumber.text = 'SV-81472-05';
    // 'CM-285962-03';

    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        lSettingTime = await AdmitApi().loadSettingTime(
          context,
          headers_: widget.headers,
        );

        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 225, 242, 243),
                Color.fromARGB(255, 201, 234, 240),
                Color.fromARGB(255, 221, 248, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(children: [
            Header.title(
                title: '',
                context: context,
                onHover: (value) {},
                onTap: () {},
                isBack: true,
                headers: widget.headers,
                lUserLogin: widget.lUserLogin),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/petward.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 5),
                      text(context, "จัดการสัตว์เลี้ยงขึ้นวอร์ด",
                          color: const Color.fromARGB(255, 34, 136, 112),
                          fontSize: 16),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 130, 216, 216),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  text(
                                    context,
                                    'HN : ',
                                    color: Colors.teal,
                                    // fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 250,
                                    height: 30,
                                    child: TextFormField(
                                      controller: tHnNumber,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.teal),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            EdgeInsets.only(left: 8, bottom: 5),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      String hn = tHnNumber.text.trim();

                                      dialog.loadData(context);

                                      if (hn.isNotEmpty) {
                                        hnNumber = hn;
                                        isLoaded = true;
                                        lPetAdmit.clear();
                                        lDataCardDrug.clear();
                                        lDataCardFood.clear();
                                        lDataCardObs.clear();
                                      } else {
                                        hnNumber = null;
                                        isLoaded = false;
                                        lPetAdmit.clear();
                                        lDataCardDrug.clear();
                                        lDataCardFood.clear();
                                        lDataCardObs.clear();
                                      }

                                      reloadCard++;

                                      await Future.delayed(
                                          const Duration(milliseconds: 500));

                                      Navigator.of(context).pop();

                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.teal, width: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: text(context, 'Load',
                                        fontSize: 12, color: Colors.teal),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.date_range_rounded,
                        size: 20,
                        color: Colors.teal,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      text(
                        context,
                        'วันที่ : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        fontWeight: FontWeight.normal,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
                if (hnNumber != null && isLoaded)
                  Row(
                    children: [
                      Expanded(
                        child: CardPet(
                          key: ValueKey(reloadCard),
                          hnNumber: hnNumber!,
                          lUserLogin: widget.lUserLogin,
                          headers: widget.headers,
                          cb: (lPetAdmit_) async {
                            lPetAdmit = lPetAdmit_;
                            visit_id = lPetAdmit_.first.visit_id;

                            lDataCardDrug = await AdmitApi().load(
                              context,
                              type: 'ยา',
                              visitId: visit_id ?? '',
                              headers_: widget.headers,
                            );

                            lDataCardFood = await AdmitApi().load(
                              context,
                              type: 'อาหาร',
                              visitId: visit_id ?? '',
                              headers_: widget.headers,
                            );

                            final lDataCardObs_ = await AdmitApi().load(
                              context,
                              type: 'OBS',
                              visitId: visit_id ?? '',
                              headers_: widget.headers,
                            );

                            lDataCardObs.clear();

                            if (lDataCardObs_.isEmpty) {
                              lDataCardObs = await AdmitApi().loadObs(
                                context,
                                code: "OBSV-DEFAULT",
                                setKey: "",
                                headers_: widget.headers,
                              );
                            } else {
                              for (var ee in lDataCardObs_) {
                                lDataCardObs.add(ListDataObsDetailModel(
                                  id: ee.id,
                                  code: "OBSV-DEFAULT",
                                  set_name: ee.item_name,
                                  remark: ee.remark,
                                  set_value: ee.drug_instruction,
                                  take_time: ee.take_time,
                                ));
                              }
                            }
                            final hasDrug = lDataCardDrug.any((e) =>
                                e.id != null &&
                                e.id.toString().trim().isNotEmpty);
                            final hasFood = lDataCardFood.any((e) =>
                                e.id != null &&
                                e.id.toString().trim().isNotEmpty);
                            final hasObs = lDataCardObs_.any((e) =>
                                e.id != null &&
                                e.id.toString().trim().isNotEmpty);

                            setState(() {
                              isHideBtn = hasDrug || hasFood || hasObs;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                if (hnNumber != null && isLoaded)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          //!Drug List
                          DrugListWidget(
                            lDataCard: lDataCardDrug,
                            lSettingTime: lSettingTime,
                            headers: widget.headers,
                            onDelete: (index) {
                              setState(() {
                                lDataCardDrug.removeAt(index);
                              });
                            },
                            onEdit: (drug) {
                              final index = lDataCardDrug.indexOf(drug);
                              EditDrugDialog.show(
                                screen: 'admit',
                                context,
                                drug,
                                index,
                                (updatedDrug, index) {
                                  setState(() {
                                    lDataCardDrug[index] = updatedDrug;
                                  });
                                },
                                widget.headers,
                              );
                            },
                            onAdd: () {
                              CreateDrugDialog.show(
                                context,
                                screen: 'admit',
                                onAddDrug_: (ListDataCardModel drug) {
                                  setState(() {
                                    lDataCardDrug.add(drug);
                                  });
                                },
                                headers: widget.headers,
                                rwAddDrug_: () {},
                              );
                              (context);
                            },
                            onConfirmed: () {
                              foodListKey.currentState?.setConfirmed();
                            },
                          ),
                          //!Food List
                          FoodListWidget(
                            key: foodListKey,
                            lSettingTime: lSettingTime,
                            lDataCard: lDataCardFood,
                            headers: widget.headers,
                            onDelete: (index) {
                              setState(() {
                                lDataCardFood.removeAt(index);
                              });
                            },
                            onEdit: (food) {
                              final index = lDataCardFood.indexOf(food);
                              EditFoodDialog.showEditFoodDialog(
                                screen: 'admit',
                                context,
                                food,
                                index,
                                (updatedFood, index) {
                                  setState(() {
                                    lDataCardFood[index] = updatedFood;
                                  });
                                },
                                widget.headers,
                              );
                            },
                            onAdd: () {
                              CreateFoodDialog.show(context, width: width,
                                  onAddFood: (ListDataCardModel food) {
                                setState(() {
                                  lDataCardFood.add(food);
                                });
                              },
                                  headers: widget.headers,
                                  rwAddFood_: () {},
                                  screen: 'admit');
                              (context);
                            },
                            onConfirmed: () {
                              foodListKey.currentState?.setConfirmed();
                            },
                          ),

                          //!obs List
                          ObsListWidget(
                            lSettingTime: lSettingTime,
                            lDataObs: lDataCardObs,
                            headers: widget.headers,
                            onDelete: (index) {
                              setState(() {
                                lDataCardObs.removeAt(index);
                              });
                            },
                            onEdit: (obs) {
                              final index = lDataCardObs.indexOf(obs);
                              EditObsDialog.showObs(context, obs, index,
                                  screen: 'admit', (updatedObs, index) {
                                setState(() {
                                  lDataCardObs[index] = updatedObs;
                                });
                              },widget.headers);
                            },
                            onAdd: () {
                              CreateObsDialog.show(context, width: width,
                                  onAddObs: (obs) {
                                setState(() {
                                  lDataCardObs.add(obs);
                                });
                              },
                                  headers: widget.headers,
                                  rwAddObs_: () {},
                                  screen: 'admit');
                              (context);
                            },
                            onCopy: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
              ])),
            ),
            if (hnNumber != null && isLoaded)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(builder: (context) {
                      bool hasValidTakeTime(String? timeSlot) {
                        if (timeSlot == null) return false;

                        if (timeSlot.contains('เมื่อมีอาการ')) return true;

                        final cleaned = timeSlot
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                            .replaceAll('"', '')
                            .replaceAll("'", '')
                            .trim();

                        final times =
                            cleaned.split(',').map((e) => e.trim()).toList();

                        return times.any((t) =>
                            t.isNotEmpty &&
                            t != '-' &&
                            t.toLowerCase() != 'null');
                      }

                      final isDrugValid = lDataCardDrug.every((e) =>
                          hasValidTakeTime(e.time_slot) ||
                          (e.time_slot?.contains('เมื่อมีอาการ') ?? false));

                      final isFoodValid = lDataCardFood.every((e) =>
                          hasValidTakeTime(e.time_slot) ||
                          (e.time_slot?.contains('เมื่อมีอาการ') ?? false));

                      final allHaveTakeTime = isDrugValid && isFoodValid;

                      return Visibility(
                        visible: !isHideBtn,
                        child: IgnorePointer(
                          ignoring: !allHaveTakeTime,
                          child: actionSlider(context, 'ยืนยันการส่งขึ้นวอร์ด',
                              width: 350.0,
                              height: 30.0,
                              togglecolor:
                                  allHaveTakeTime ? Colors.green : Colors.grey,
                              icons: Icons.check,
                              iconColor: Colors.white,
                              asController: ActionSliderController(),
                              action: (controller) async {
                            final dialog = AwesomeDialog(
                              context: context,
                              customHeader: Lottie.asset(
                                "assets/animations/Send1.json",
                                repeat: true,
                                width: 200,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                              dialogType: DialogType.noHeader,
                              animType: AnimType.scale,
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              width: MediaQuery.of(context).size.width * 0.3,
                              body: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  SizedBox(height: 10),
                                  Text(
                                    "กำลังส่งข้อมูลขึ้นวอร์ด กรุณารอสักครู่...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );

                            dialog.show();

                            await AdmitApi().CreateCard(
                              context,
                              headers_: widget.headers,
                              mUser: widget.lUserLogin.first,
                              mPetAdmit_: lPetAdmit.first,
                              lDataCardDrug_: lDataCardDrug,
                              lDataCardFood_: lDataCardFood,
                              lDataObs_: lDataCardObs,
                            );

                            dialog.dismiss();
                            setState(() {
                              foodListKey.currentState?.setConfirmed();
                              DrugListKey.currentState?.setConfirmed();
                              reloadCard++;
                            });
                          }),
                        ),
                      );
                    })
                  ],
                ),
              )
          ])),
    );
  }
}
