// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/widget/card_pet.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widgets/text.copy';

// ignore: must_be_immutable
class RoundWardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  Map<String, String> headers;
  List<ListUserModel> lUserLogin = [];
  String? hnNumber;
  RoundWardScreen({
    super.key,
    required this.lDataCard,
    required this.headers,
    required this.lUserLogin,
  });

  @override
  _RoundWardScreenState createState() => _RoundWardScreenState();
}

class _RoundWardScreenState extends State<RoundWardScreen> {
  // ignore: deprecated_member_use

  late TextTheme textTheme;
  List<ListUserModel> lUserLogin = [];
  int iMenu = 1;
  List<String> listCard = [
    'AN-2025-03-03',
    'AN-2025-03-04',
    'AN-2025-03-05',
    'AN-2025-03-06',
    'AN-2025-03-08',
  ];

  List<String> items = [
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-02 ,Name : คุณพิรัช ใจสะอาด (SA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
    'HN : SV240912088-01 ,Name : Sala/คุณสเตฟราน ทานทอง (CA),Site : R9   Word : SCU ,เตียง : G-Nurse-M-23',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
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
                      'assets/images/ward3.png',
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 10),
                    text(context, "Round Ward",
                        color: const Color.fromARGB(255, 34, 136, 112),
                        fontSize: 16),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 45,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 130, 216, 216),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 4),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              text(
                                context,
                                'Site : ',
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: 250,
                                height: 30,
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              text(
                                context,
                                'Ward : ',
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: 250,
                                height: 30,
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {},
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                // Row(
                //   children: [
                //     Expanded(
                //       child: CardPet(
                //         lUserLogin: lUserLogin,
                //         headers: widget.headers,
                //         cb: () async {},
                //         hnNumber: '',
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listCard.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 110, 231, 233),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, listCard[index],
                                    color: Colors.teal[700]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 10, bottom: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: iMenu == 1
                                        ? Color.fromARGB(255, 243, 214, 126)
                                        : Color.fromARGB(255, 243, 214, 126),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                    ),
                                    minimumSize: Size(150, 40),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/menu2.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 4),
                                      text(
                                        context,
                                        'สังเกตอาการ',
                                        fontWeight:
                                            iMenu == 1 ? FontWeight.bold : null,
                                        color: iMenu == 1
                                            ? Colors.blue[900]
                                            : Colors.black,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      iMenu = 1;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: iMenu == 2
                                        ? Color.fromARGB(255, 161, 223, 240)
                                        : Color.fromARGB(255, 161, 223, 240),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                    ),
                                    minimumSize: Size(150, 40),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/menu2.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 4),
                                      text(context, 'ยากิน',
                                          fontWeight: iMenu == 2
                                              ? FontWeight.bold
                                              : null,
                                          color: iMenu == 2
                                              ? Colors.blue[900]
                                              : Colors.black),
                                    ],
                                  ),
                                  onPressed: () {
                                    iMenu = 2;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: iMenu == 3
                                        ? Color.fromARGB(255, 229, 215, 243)
                                        : Color.fromARGB(255, 229, 215, 243),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                    ),
                                    minimumSize: Size(150, 40),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/menu3.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 4),
                                      text(
                                        context,
                                        'ยาหยอดหู,ตา',
                                        fontWeight:
                                            iMenu == 3 ? FontWeight.bold : null,
                                        color: iMenu == 3
                                            ? Colors.blue[900]
                                            : Colors.black,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    iMenu = 3;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: iMenu == 4
                                        ? Color.fromARGB(255, 114, 214, 208)
                                        : Color.fromARGB(255, 114, 214, 208),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                    ),
                                    minimumSize: Size(150, 40),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/menu4.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      SizedBox(width: 4),
                                      text(context, 'ยาฉีด',
                                          fontWeight: iMenu == 4
                                              ? FontWeight.bold
                                              : null,
                                          color: iMenu == 4
                                              ? Colors.blue[900]
                                              : Colors.black),
                                    ],
                                  ),
                                  onPressed: () {
                                    iMenu = 4;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (iMenu == 1)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        1.02,
                                    height: MediaQuery.of(context).size.height,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 243, 214, 126),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "เนื้อหาสำหรับ สังเกตอาการ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (iMenu == 2)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        1.02,
                                    height: MediaQuery.of(context).size.height,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 161, 223, 240),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "เนื้อหาสำหรับ สังเกตอาการ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (iMenu == 3)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        1.02,
                                    height: MediaQuery.of(context).size.height,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 229, 215, 243),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "เนื้อหาสำหรับ สังเกตอาการ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (iMenu == 4)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        1.02,
                                    height: MediaQuery.of(context).size.height,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 114, 214, 208),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "เนื้อหาสำหรับ สังเกตอาการ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ))
              ])))
            ])));
  }
}
