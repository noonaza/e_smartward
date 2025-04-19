// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:action_slider/action_slider.dart';
import 'package:e_smartward/Model/list_data_card.dart';
import 'package:e_smartward/api/data_card_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/dialog/create_drug_dialog.dart';
import 'package:e_smartward/dialog/create_food_dialog.dart';
import 'package:e_smartward/dialog/create_obs_dialog.dart';
import 'package:e_smartward/dialog/edit_Food_dialog.dart';
import 'package:e_smartward/dialog/edit_drug_dialog.dart';
import 'package:e_smartward/dialog/edit_obs_dialog.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/card_drug_detail.dart';
import 'package:e_smartward/widget/card_food_detail.dart';
import 'package:e_smartward/widget/card_obs_detail.dart';
import 'package:e_smartward/widget/card_pet.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/text.dart';

// ignore: must_be_immutable
class AdmitScreen extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  Map<String, String> headers;
  List<ListUserModel> lUserLogin = [];
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
  List<ListUserModel> lUserLogin = [];
  List<ListDataCardModel> lDataCardDrug = [];
  List<ListDataCardModel> lDataCardFood = [];
  List<String> selectedDrugTimes = [];
  List<ListPetModel> lPetAdmit = [];
  TextEditingController tHnNumber = TextEditingController();
  final List<Map<String, dynamic>> listFood = [];
  String? hnNumber;
  String? visit_id;
  bool isLoaded = false;

  List<Map<String, dynamic>> listObs = [
    {
      "name": "ปัสสาวะ",
      "note": "เวลาปวดปัสสาวะ มีอาการปวดท้อง",
      "times": ["04:00"]
    },
    {
      "name": "อุจจาระ",
      "note": "สำคัญ ไม่ควรลบ",
      "times": ["04:00"]
    },
    {
      "name": "อาเจียน รุนแรง",
      "note": "ปัสสาวะบ่อย",
      "times": ["04:00"]
    },
    {
      "name": "มีน้ำมูก",
      "note": "อุจจาระ มีมูกเลือด",
      "times": ["04:00"]
    }
  ];

  List<String> time = [
    'ทุกๆ 1 ชม.',
    'ทุกๆ 2 ชม.',
    'ทุกๆ 3 ชม.',
    'ทุกๆ 4 ชม.',
    'กำหนดเอง',
  ];

  List<Map<String, String>> items = [];

  List<String> timeList = List.generate(24, (index) {
    String formattedHour = index.toString().padLeft(2, '0');
    return '$formattedHour:00';
  });

  final List<Map<String, dynamic>> copyLists = [
    {
      "cardDate": "AN: 20250202-123",
      "items": [
        {
          "category": "ปัสสาวะ",
          "description": "ไม่ปัสสาวะเลย",
          "times": ["04:00"]
        },
        {
          "category": "อุจจาระ",
          "description": "ไม่มีอาการท้องเสีย หรือ อุจจาระบ่อย",
          "times": ["04:00"]
        },
        {
          "category": "เพิ่มเติมอื่นๆ",
          "description": "พบว่า มีน้ำตาไหลตลอดเวลา",
          "times": ["04:00"]
        },
        {
          "category": "กินอาหารได้น้อย",
          "description": "กินแค่ 3 กรัม ต่อวัน",
          "times": ["04:00"]
        },
      ],
    },
    {
      "cardDate": "AN: 20250131-123",
      "items": [
        {
          "category": "ปัสสาวะ",
          "description": "เวลาปวดปัสสาวะ มีอาการปวดท้อง",
          "times": ["04:00"]
        },
        {
          "category": "อุจจาระ",
          "description": "สำคัญ ไม่ควรลบ",
          "times": ["04:00"]
        },
        {
          "category": "เพิ่มเติมอื่นๆ",
          "description": "ปัสสาวะบ่อย",
          "times": ["04:00"]
        },
        {
          "category": "มีอาเจียน",
          "description": "อาเจียนติดกัน 4 รอบ",
          "times": ["04:00"]
        },
      ],
    }
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logoward.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    text(context, "จัดการขึ้นวอร์ด",
                        color: const Color.fromARGB(255, 34, 136, 112),
                        fontSize: 16),
                  ],
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 250,
                                    height: 30,
                                    child: TextFormField(
                                      controller: tHnNumber,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.teal),
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
                                    onPressed: () {
                                      String hn = tHnNumber.text.trim();
                                      setState(() {
                                        if (hn.isNotEmpty) {
                                          hnNumber = hn;
                                          isLoaded = true;
                                          lDataCardDrug.clear();
                                          lDataCardFood.clear();
                                        } else {
                                          hnNumber = null;
                                          isLoaded = false;
                                        }
                                      });
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
                              hnNumber: hnNumber!,
                              lUserLogin: lUserLogin,
                              headers: widget.headers,
                              cb: (visit_id_) async {
                                visit_id = visit_id_;
                                lDataCardDrug = await DataCardApi().load(
                                    context,
                                    type: 'ยา',
                                    visitId: visit_id ?? '',
                                    headers_: widget.headers);
                                lDataCardFood = await DataCardApi().load(
                                  context,
                                  type: 'อาหาร',
                                  visitId: visit_id ?? '',
                                  headers_: widget.headers,
                                );

                                setState(() {});
                              })),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //!Drug List
                        DrugListWidget(
                          lDataCard: lDataCardDrug,
                          headers: widget.headers,
                          onDelete: (index) {
                            if (index >= 0 && index < widget.lDataCard.length) {
                              setState(() {
                                widget.lDataCard.removeAt(index);
                              });
                            }
                          },
                          onEdit: (drug) {
                            EditDrugDialog.show(
                                context,
                                drug.item_name ?? '',
                                drug.dose_qty ?? '',
                                drug.drug_type_name ?? '',
                                drug.drug_description ?? '',
                                drug.note_to_team ?? '',
                                drug.doctor_eid ?? ''
                                // drugTimes: ['Morning', 'Afternoon', 'Night'],
                                );
                            print(drug.drug_description);
                          },
                          onAdd: () {
                            CreateDrugDialog.show(context);
                            (context);
                          },
                        ),
                        //!Food List
                        FoodListWidget(
                          lDataCard: lDataCardFood,
                          headers: widget.headers,
                          onDelete: (index) {
                            setState(() {
                              widget.lDataCard.removeAt(index);
                            });
                          },
                          onEdit: (food) {
                            EditFoodDialog.show(
                                context,
                                food.item_name ?? '',
                                food.dose_qty ?? '',
                                food.drug_description ?? '',
                                food.note_to_team ?? '',
                                food.doctor_eid ?? ''
                                // foodTimes: ['Morning', 'Afternoon', 'Night'],
                                );
                          },
                          onAdd: () {
                            CreateFoodDialog.show(context);
                            (context);
                          },
                        ),

                        //!obs List
                        ObsListWidget(
                          listObs: listObs,
                          onEdit: (obs) {
                            EditObsDialog.show(
                              context,
                              obs["name"],
                              obs["note"],
                              List<String>.from(obs["times"]),
                            );
                          },
                          onDelete: (index) {
                            setState(() {
                              listObs.removeAt(index);
                            });
                          },
                          onAdd: () {
                            CreateObsDialog.show(context);
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  actionSlider(
                    context,
                    'ยืนยันการส่งขึ้นวอร์ด',
                    width: 350.0,
                    height: 30.0,
                    togglecolor: Colors.green,
                    icons: Icons.check,
                    iconColor: Colors.white,
                    asController: ActionSliderController(),
                    action: (controller) {
                      setState(() {});
                    },
                  )
                ],
              ),
            )
          ])),
    );
  }

  void showCopyObsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: copyLists.length,
              itemBuilder: (context, index) {
                String cardDate = copyLists[index]["cardDate"];
                List<dynamic> items = copyLists[index]["items"];

                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color.fromARGB(255, 255, 208, 192),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    text(
                                      context,
                                      cardDate,
                                    ),
                                    IconButton(
                                      iconSize: 25,
                                      color: Colors.redAccent,
                                      icon: Icon(Icons.copy),
                                      onPressed: () {
                                        setState(() {
                                          listObs = List.from(items);
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Column(
                                children: items.map<Widget>((item) {
                                  String category = item["category"];
                                  String description = item["description"];
                                  List<String> causetimes =
                                      List<String>.from(item["times"]);

                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(
                                            context,
                                            category,
                                          ),
                                          SizedBox(height: 4),
                                          text(
                                            context,
                                            description,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children:
                                                causetimes.map<Widget>((time) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 215, 116, 114),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 215, 116, 114),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: text(context, time,
                                                      color: Colors.white),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
      },
    );
  }
}
