import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/dialog/create_food_dialog.dart';
import 'package:e_smartward/dialog/create_obs_dialog_v2.dart';
import 'package:e_smartward/dialog/edit_obs_dialog_v2.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:e_smartward/widget/textfield.dart';
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

class AdmitScreenV2 extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  Map<String, String> headers;
  List<ListUserModel> lUserLogin;

  final VoidCallback? onChangedVisit;
  ValueNotifier<bool>? noteBtnVisible = ValueNotifier<bool>(false);
  final void Function(int index) onDelete;

  AdmitScreenV2({
    super.key,
    required this.headers,
    required this.lUserLogin,
    required this.lDataCard,
    required this.onDelete,
    this.noteBtnVisible,
    this.onChangedVisit,
  });

  @override
  _AdmitScreenState createState() => _AdmitScreenState();
}

class _AdmitScreenState extends State<AdmitScreenV2> {
  final GlobalKey<DrugListWidgetState> DrugListKey =
      GlobalKey<DrugListWidgetState>();

  List<ListDataCardModel> lDataCardDrug = [];
  List<ListDataCardModel> lDataCardFood = [];

  List<GetObsModel> lDataCardObs = [];
  List<ListDataObsDetailModel> lSettingTime = [];

  late TextEditingController txtNote;
  List<String> selectedDrugTimes = [];
  List<ListPetModel> lPetAdmit = [];
  TextEditingController tHnNumber = TextEditingController();
  TextEditingController tNote = TextEditingController();
  final List<Map<String, dynamic>> listFood = [];
  String? hnNumber;
  String? visit_id;
  bool isLoaded = false;
  int reloadCard = 0;
  bool isHideBtn = false;
  final drugListKey = GlobalKey<DrugListWidgetState>();
  final foodListKey = GlobalKey<FoodListWidgetState>();
  final ValueNotifier<bool> noteBtnVisible = ValueNotifier<bool>(false);

  void resetNoteVisibility() => noteBtnVisible.value = false;

  List<Map<String, String>> items = [];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });

  String _deriveFloorFromBedNumber(String bedRaw) {
    final base = bedRaw.trim();
    if (base.isEmpty) return '';
    final parts = base.split('-').where((e) => e.trim().isNotEmpty).toList();

    if (parts.length >= 2) return parts[1].trim();
    return '';
  }

  Future<List<GetObsModel>> GetObsByPet(
    BuildContext context, {
    required ListPetModel mPetAdmit,
    required Map<String, String> headers_,
  }) async {
    final bed = (mPetAdmit.bed_number ?? '').trim();
    if (bed.isEmpty) return [];

    final floor = ((mPetAdmit.floor ?? '').trim().isNotEmpty)
        ? (mPetAdmit.floor ?? '').trim()
        : _deriveFloorFromBedNumber(bed);

    if (floor.isEmpty) return [];

    debugPrint('[GetObsByPet] floor="$floor", bed="$bed"');
    return AdmitApi().GetObs(
      context,
      floor: floor,
      bed_number: bed,
      headers_: headers_,
    );
  }

  @override
  void initState() {
    super.initState();
    tHnNumber.text = 'SR-168158-05';
  }

  @override
  void dispose() {
    noteBtnVisible.dispose();
    super.dispose();
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
                                      onChanged: (v) {
                                        if (v.trim().isEmpty) {
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
                                      },
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
                          noteBtnVisible: noteBtnVisible,
                          headers: widget.headers,
                          cb: (lPetAdmit_) async {
                            noteBtnVisible.value = false;

                            lPetAdmit = lPetAdmit_;
                            final selected =
                                lPetAdmit.isNotEmpty ? lPetAdmit.first : null;
                            if (selected == null) {
                              setState(() {
                                visit_id = null;
                                lDataCardDrug.clear();
                                lDataCardFood.clear();
                                lDataCardObs.clear();
                                isHideBtn = false;
                                noteBtnVisible.value = false;
                              });
                              return;
                            }

                            visit_id = selected.visit_id;

                            final drugFuture = AdmitApi().load(
                              context,
                              type: 'ยา',
                              visitId: visit_id ?? '',
                              headers_: widget.headers,
                            );
                            final foodFuture = AdmitApi().load(
                              context,
                              type: 'อาหาร',
                              visitId: visit_id ?? '',
                              headers_: widget.headers,
                            );
                            final obsFromVisitFuture = AdmitApi().load(
                              context,
                              type: 'OBS',
                              visitId: visit_id ?? '',
                              headers_: widget.headers,
                            );

                            final results = await Future.wait([
                              drugFuture,
                              foodFuture,
                              obsFromVisitFuture,
                            ]);
                            final drugs = results[0];
                            final foods = results[1];
                            final obsFromVisit = results[2] as List<dynamic>;

                            List<GetObsModel> obsFinal = [];

                            if (obsFromVisit.isEmpty) {
                              String bedNumber =
                                  (selected.bed_number ?? '').trim();

                              String floor = (selected.floor ?? '').trim();
                              if (floor.isEmpty) {
                                floor = _deriveFloorFromBedNumber(bedNumber);
                              }

                              if (floor.isEmpty || bedNumber.isEmpty) {
                                debugPrint(
                                    '[AdmitScreen] skip GetObs: floor="$floor", bed="$bedNumber"');
                                obsFinal = [];
                              } else {
                                obsFinal = await AdmitApi().GetObs(
                                  context,
                                  floor: floor,
                                  bed_number: bedNumber,
                                  headers_: widget.headers,
                                );
                              }
                            } else {
                              for (final ee in obsFromVisit) {
                                obsFinal.add(GetObsModel(
                                  id: ee.id,
                                  code: 'OBSV-DEFAULT',
                                  set_name: ee.item_name,
                                  remark: ee.remark,
                                  set_value: ee.drug_instruction,
                                  take_time: ee.take_time,
                                  time_slot: ee.time_slot,
                                ));
                              }
                            }

                            if (!mounted) return;
                            setState(() {
                              lDataCardDrug = drugs;
                              lDataCardFood = foods;
                              lDataCardObs = obsFinal;
                              isHideBtn = obsFinal.any((e) => (e.id ?? '')
                                      .toString()
                                      .trim()
                                      .isNotEmpty) ||
                                  drugs.any((e) => (e.id ?? '')
                                      .toString()
                                      .trim()
                                      .isNotEmpty) ||
                                  foods.any((e) => (e.id ?? '')
                                      .toString()
                                      .trim()
                                      .isNotEmpty);
                            });
                            noteBtnVisible.value = isHideBtn;

                            final hasDrug = drugs.any((e) =>
                                e.id != null &&
                                e.id.toString().trim().isNotEmpty);
                            final hasFood = foods.any((e) =>
                                e.id != null &&
                                e.id.toString().trim().isNotEmpty);
                            final hasObs = obsFinal.any((e) =>
                                e.id != null &&
                                e.id.toString().trim().isNotEmpty);
                            final alreadyConfirmed =
                                hasDrug || hasFood || hasObs;

                            if (!mounted) return;
                            setState(() {
                              lDataCardDrug = drugs;
                              lDataCardFood = foods;
                              lDataCardObs = obsFinal;
                              isHideBtn = alreadyConfirmed;
                            });
                            noteBtnVisible.value = alreadyConfirmed;
                          },
                        ),
                      ),
                    ],
                  ),
                if (hnNumber != null && isLoaded && visit_id != null)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          //!Drug List
                          DrugListWidget(
                            key: drugListKey,
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
                              drugListKey.currentState?.setConfirmed();
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
                              CreateFoodDialog.show(
                                context,
                                width: width,
                                screen: 'admit',
                                onAddFood: (ListDataCardModel food) {
                                  setState(() {
                                    lDataCardFood.add(food);
                                  });
                                },
                                headers: widget.headers,
                                rwAddFood_: () {},
                              );
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
                              EditObsDialogV2.showObs(context, obs, index,
                                  screen: 'admit', (updatedObs, index) {
                                setState(() {
                                  lDataCardObs[index] = updatedObs;
                                });
                              }, widget.headers);
                            },
                            onAdd: () {
                              CreateObsDialogV2.show(
                                context,
                                width: width,
                                onAddObs: (obs) {
                                  setState(() {
                                    lDataCardObs.add(obs);
                                  });
                                },
                                headers: widget.headers,
                                rwAddObs_: () {},
                                screen: 'admit',
                              );
                            },
                            onCopy: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
              ])),
            ),
            if (!isHideBtn && hnNumber != null)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: textFieldNote(
                  context,
                  'โน๊ตพิเศษ : ',
                  controller: tNote,
                  color: Colors.black,
                ),
              ),
            if (hnNumber != null && isLoaded && visit_id != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        String? pickTimeString(
                            {String? timeSlot, String? takeTime}) {
                          final ts = (timeSlot ?? '').trim();
                          final tt = (takeTime ?? '').trim();
                          if (ts.isNotEmpty &&
                              ts.toLowerCase() != 'null' &&
                              ts != '-') return ts;
                          if (tt.isNotEmpty &&
                              tt.toLowerCase() != 'null' &&
                              tt != '-') return tt;
                          return null;
                        }

                        bool hasValidTakeTimeString(String? raw) {
                          if (raw == null) return false;

                          if (raw.contains('เมื่อมีอาการ')) return true;

                          final cleaned = raw
                              .replaceAll('[', '')
                              .replaceAll(']', '')
                              .replaceAll('"', '')
                              .replaceAll("'", '')
                              .trim();

                          final times =
                              cleaned.split(',').map((e) => e.trim()).toList();
                          return times.any(
                            (t) =>
                                t.isNotEmpty &&
                                t != '-' &&
                                t.toLowerCase() != 'null',
                          );
                        }

                        final isDrugValid = lDataCardDrug.every((e) {
                          final raw = pickTimeString(
                              timeSlot: e.time_slot, takeTime: e.take_time);
                          return hasValidTakeTimeString(raw);
                        });

                        final isFoodValid = lDataCardFood.every((e) {
                          final raw = pickTimeString(
                              timeSlot: e.time_slot, takeTime: e.take_time);
                          return hasValidTakeTimeString(raw);
                        });

                        final isDrugslot = lDataCardDrug.every((e) {
                          final raw = pickTimeString(
                              timeSlot: e.type_slot, takeTime: e.time_slot);
                          return hasValidTakeTimeString(raw);
                        });

                        final isFoodslot = lDataCardFood.every((e) {
                          final raw = pickTimeString(
                              timeSlot: e.type_slot, takeTime: e.type_slot);
                          return hasValidTakeTimeString(raw);
                        });

                        final allHaveTakeTime = isDrugValid &&
                            isFoodValid &&
                            isFoodslot &&
                            isDrugslot;

                        return Visibility(
                          visible: !isHideBtn,
                          child: IgnorePointer(
                            ignoring: !allHaveTakeTime,
                            child: actionSlider(
                              context,
                              'ยืนยันการส่งขึ้นวอร์ด',
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  body: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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

                                await AdmitApi().CreateCardV2(
                                  context,
                                  headers_: widget.headers,
                                  mUser: widget.lUserLogin.first,
                                  mPetAdmit_: lPetAdmit.first,
                                  message: tNote.text,
                                  lDataCardDrug_: lDataCardDrug,
                                  lDataCardFood_: lDataCardFood,
                                  lDataObs_: lDataCardObs,
                                );

                                setState(() {
                                  foodListKey.currentState?.setConfirmed();
                                  drugListKey.currentState?.setConfirmed();

                                  reloadCard++;
                                });

                                dialog.dismiss();

                                noteBtnVisible.value = true;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
          ])),
    );
  }
}
