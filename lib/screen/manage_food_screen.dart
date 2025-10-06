// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/manage_food_widget.dart';
import 'package:e_smartward/widget/switch_widget.dart';
import 'package:e_smartward/widget/text.dart';
import '../Model/list_data_card_model.dart';
import '../widget/dropdown.dart';

class ManageFoodScreen extends StatefulWidget {
  final Map<String, String> headers;
  List<ListUserModel> lUserLogin;

  ManageFoodScreen({
    super.key,
    required this.headers,
    required this.lUserLogin,
  });

  @override
  State<ManageFoodScreen> createState() => _ManageFoodScreenState();
}

class _ManageFoodScreenState extends State<ManageFoodScreen> {
  String? selectedGroupId;
  String? userDefaultSiteCode;
  String? selectedSite;
  String? selectedWard;
  bool showCard = false;
  bool isLoading = false;
  String? errorMessage;
  bool isWardMode = false;
  List<ListDataCardModel> lDataCard = [];

  @override
  void initState() {
    super.initState();
    selectedSite = widget.lUserLogin.first.site_code;
    selectedSite = userDefaultSiteCode;
  }

  @override
  Widget build(BuildContext context) {
    String? userDefaultSiteCode = widget.lUserLogin.first.site_code;
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
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/cook.png',
                              width: 35,
                              height: 35,
                            ),
                            const SizedBox(width: 5),
                            text(
                              context,
                              "จัดอาหาร",
                              color: const Color.fromARGB(255, 34, 136, 112),
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      SwitchCard(
                        Switch: true,
                        onChanged: (value) {
                          setState(() {
                            isWardMode = value;
                            showCard = false;
                            errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Visibility(
                              visible: !isWardMode,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  text(
                                    context,
                                    'Bed Group : ',
                                    color: Colors.teal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 250,
                                    height: 30,
                                    child: GroupDropdown(
                                      headers_: widget.headers,
                                      onSelected: (groupId) {
                                        setState(() {
                                          selectedGroupId = groupId;
                                          showCard = false;
                                          errorMessage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isWardMode,
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  text(
                                    context,
                                    'Site : ',
                                    color: Colors.teal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 30,
                                    child: SiteDropdown(
                                      initialSiteCode: userDefaultSiteCode,
                                      headers_: widget.headers,
                                      onSelected: (siteCodeName) {
                                        setState(() {
                                          selectedSite = siteCodeName;
                                          selectedWard = null;
                                          showCard = false;
                                          errorMessage = null;
                                        });
                                      },
                                    ),
                                  ),
                                  text(
                                    context,
                                    'Ward : ',
                                    color: Colors.teal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 320,
                                    height: 30,
                                    child: WardDropdown(
                                      key: ValueKey(selectedSite),
                                      headers_: widget.headers,
                                      selectedSiteCode: selectedSite,
                                      onSelected: (wardCodeName) {
                                        setState(() {
                                          selectedWard = wardCodeName;
                                          showCard = false;
                                          errorMessage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (!isWardMode &&
                                              selectedGroupId == null) {
                                            setState(() {
                                              errorMessage = 'กรุณาเลือกเตียง';
                                            });
                                            return;
                                          }
                                          if (isWardMode &&
                                              (selectedSite == null ||
                                                  selectedWard == null)) {
                                            setState(() {
                                              errorMessage =
                                                  'กรุณาเลือก Site และ Ward';
                                            });
                                            return;
                                          }

                                          setState(() {
                                            isLoading = true;
                                            errorMessage = null;
                                          });

                                          setState(() {
                                            showCard = true;
                                            isLoading = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              color: Colors.teal, width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: text(context, 'Load',
                                            fontSize: 12, color: Colors.teal),
                                      ),
                                      if (isLoading)
                                        const SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.teal,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 5, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.date_range_rounded,
                              size: 20,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 5),
                            text(
                              context,
                              'วันที่ : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                              fontWeight: FontWeight.normal,
                              color: Colors.teal,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCard &&
                    ((!isWardMode && selectedGroupId != null) ||
                        (isWardMode &&
                            selectedSite != null &&
                            selectedWard != null)))
                  SizedBox(
                    child: ManageFoodWidget(
                      headers: widget.headers,
                      lDataCard: const [],
                      groupId: !isWardMode ? selectedGroupId! : null,
                      siteCode: isWardMode ? selectedSite : null,
                      wardCode: isWardMode ? selectedWard : null,
                      isWardMode: isWardMode,
                      lUserLogin: widget.lUserLogin,
                    ),
                  ),
              ])))
            ])));
  }
}
