// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/add_order_model.dart';
import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/data_progress_model.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/Model/list_group_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_roundward_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/Model/new_order_model.dart';
import 'package:e_smartward/api/note_api.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/dialog/chat_dialog.dart';
import 'package:e_smartward/dialog/check_drug_order.dart';
import 'package:e_smartward/dialog/check_food_order.dart';
import 'package:e_smartward/dialog/create_drug_dialog.dart';
import 'package:e_smartward/dialog/create_food_dialog.dart';
import 'package:e_smartward/dialog/create_obs_dialog.dart';
import 'package:e_smartward/dialog/progress_note_dialog.dart';
import 'package:e_smartward/widget/card_roundward.dart';
import 'package:e_smartward/widget/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:tab_container/tab_container.dart';

// ignore: must_be_immutable
class RoundWardScreen extends StatefulWidget {
  final List<ListRoundwardModel> lDataCard;
  Map<String, String> headers;
  List<ListUserModel> lUserLogin = [];
  final List<ListPetModel> lPetAdmit;
  final List<ListAnModel> lListAn;
  String? hnNumber;

  RoundWardScreen({
    super.key,
    required this.lDataCard,
    required this.headers,
    required this.lUserLogin,
    required this.lPetAdmit,
    required this.lListAn,
  });

  @override
  _RoundWardScreenState createState() => _RoundWardScreenState();
}

class _RoundWardScreenState extends State<RoundWardScreen>
    with TickerProviderStateMixin {
  String? selectedGroupId;
  String? selectedSite;
  String? selectedHn;
  String? selectedWard;
  TabController? _tabController;
  bool showCard = false;
  late TextTheme textTheme;
  ListPetModel? mPetAdmit_;
  List<ListPetModel> lPetAdmit = [];
  List<ListDataObsDetailModel> lSettingTime = [];
  List<ListGroupModel> lGroupTabs = [];
  List<DataProgressModel> lProgressNote = [];
  bool isLoading = false;
  String? errorMessage;
  bool isWardMode = false;
  List<ListAnModel> lListAn = [];
  String? selectedAnNumber;
  bool showTab = false;
  bool isLoadingProgressNote = false;
  bool showNote = false;
  bool showAn = false;
  bool hasNewOrders = false;
  DateTime _selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  String searchPet = '';
  bool _isLoadingNewOrder = false;

  int iMenu = 1;
  bool isLoadingTab = false;
  List<ListDataCardModel> lDataCardDrug = [];
  List<DataAddOrderModel> lDataOrder_ = [];
  List<AddOrderModel> AddOrder_ = [];
  Map<String, List<ListRoundwardModel>> groupedCardData = {};
  ListAnModel? selectedAnModel;

  TextSpan textSpan(
    String text, {
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 14,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedSite = widget.lUserLogin.first.site_code;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = lPetAdmit.where((pet) {
      final hn = (pet.hn ?? '').toLowerCase();
      final name = (pet.pet_name ?? '').toLowerCase();
      final query = searchPet.toLowerCase();
      return hn.contains(query) || name.contains(query);
    }).toList();
    String? userDefaultSiteCode = widget.lUserLogin.first.site_code;
    final listToShow = searchPet.trim().isEmpty ? lPetAdmit : filteredList;
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
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Header
                        Header.title(
                          title: '',
                          context: context,
                          onHover: (value) {},
                          onTap: () {},
                          isBack: true,
                          headers: widget.headers,
                          lUserLogin: widget.lUserLogin,
                        ),

                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/note.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 5),
                                text(context, "Progress Note",
                                    color:
                                        const Color.fromARGB(255, 34, 136, 112),
                                    fontSize: 16),
                              ],
                            ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 4),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        text(
                                          context,
                                          'Site : ',
                                          color: Colors.teal,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 200,
                                          height: 30,
                                          child: SiteDropdown(
                                            headers_: widget.headers,
                                            initialSiteCode:
                                                userDefaultSiteCode,
                                            onSelected: (siteCodeName) {
                                              setState(() {
                                                selectedSite = siteCodeName;
                                                selectedWard = null;
                                                showCard = false;
                                                errorMessage = null;

                                                lPetAdmit = [];
                                                selectedHn = null;
                                                selectedAnModel = null;
                                                selectedAnNumber = null;
                                                lListAn = [];
                                                showAn = false;
                                                showTab = false;
                                                groupedCardData.clear();
                                                _tabController?.dispose();
                                                _tabController = null;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        text(
                                          context,
                                          'Ward : ',
                                          color: Colors.teal,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 300,
                                          height: 30,
                                          child: WardDropdown(
                                            key: ValueKey(selectedSite),
                                            headers_: widget.headers,
                                            selectedSiteCode: selectedSite,
                                            onSelected: (ward) {
                                              setState(() {
                                                selectedWard = ward;
                                                showCard = false;
                                                errorMessage = null;

                                                lPetAdmit = [];
                                                selectedHn = null;
                                                selectedAnModel = null;
                                                selectedAnNumber = null;
                                                lListAn = [];
                                                showAn = false;
                                                showTab = false;
                                                groupedCardData.clear();
                                                _tabController?.dispose();
                                                _tabController = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
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
                                            final result =
                                                await NoteApi().loadListAdmit(
                                              context,
                                              headers_: widget.headers,
                                              groupId: null,
                                              siteCode: selectedSite ?? '',
                                              ward: selectedWard ?? '',
                                              type: 'WARD',
                                            );
                                            setState(() {
                                              showTab = false;
                                              lPetAdmit = result;
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
                                        const SizedBox(width: 10),
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
                                    if (errorMessage != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
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
                        if (showCard && lPetAdmit.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: searchController,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'ค้นหาจาก HN หรือชื่อสัตว์เลี้ยง',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.teal),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.teal, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.teal, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchPet = value;
                                    lGroupTabs = [];
                                    lListAn = [];
                                    //  = null;
                                    // visit_id = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 230,
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : !showCard
                                    ? const SizedBox.shrink()
                                    : listToShow.isEmpty
                                        ? const Center(
                                            child: Text('ไม่พบข้อมูล'))
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: listToShow.length,
                                            itemBuilder: (context, index) {
                                              final pet = listToShow[index];
                                              String hn = pet.hn ?? '';
                                              String name = pet.pet_name ?? '';
                                              String site =
                                                  pet.base_site_branch_id ?? '';
                                              String ward = pet.ward ?? '';
                                              String bed = pet.bed_number ?? '';
                                              String doctor = pet.doctor ?? '';
                                              String date =
                                                  pet.admit_date ?? '';

                                              String formattedText =
                                                  'HN: $hn\nName: $name\nSite: $site\nWard: $ward\nเตียง: $bed\nชื่อแพทย์: $doctor\nวันที่เข้ารักษา: $date';

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    SizedBox(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          final hn = pet.hn;

                                                          if (hn == null ||
                                                              hn.isEmpty) {
                                                            return;
                                                          }

                                                          setState(() {
                                                            selectedHn = hn;
                                                            selectedAnModel =
                                                                null;
                                                            selectedAnNumber =
                                                                null;
                                                            lListAn = [];
                                                            lGroupTabs = [];
                                                            _tabController
                                                                ?.dispose();
                                                            _tabController =
                                                                null;
                                                            showAn = true;
                                                            showTab = false;
                                                            groupedCardData
                                                                .clear();
                                                          });

                                                          final data =
                                                              await RoundWardApi()
                                                                  .loadListAn(
                                                            context,
                                                            headers_:
                                                                widget.headers,
                                                            mPetAdmit_: pet,
                                                          );

                                                          if (!mounted) return;

                                                          setState(() {
                                                            lListAn = data;
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              selectedHn ==
                                                                      pet.hn
                                                                  ? Colors
                                                                      .teal[100]
                                                                  : Colors
                                                                      .white,
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .teal,
                                                                  width: 2),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      30),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 100.0),
                                                          child: text(context,
                                                              formattedText,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              color:
                                                                  Colors.teal),
                                                        ),
                                                      ),
                                                    ),

                                                    Positioned(
                                                        right: 5,
                                                        top: 30,
                                                        child: IconButton(
                                                            icon: const Icon(
                                                                Icons.note_alt,
                                                                color:
                                                                    Colors.teal,
                                                                size: 28),
                                                            onPressed: () {
                                                              final admitId =
                                                                  pet.visit_id;
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder: (_) =>
                                                                    ChatDialog(
                                                                  headers: widget
                                                                      .headers,
                                                                  visitId:
                                                                      admitId ??
                                                                          '',
                                                                  lUserLogin: widget
                                                                      .lUserLogin,
                                                                ),
                                                              );
                                                            })),

                                                    Positioned(
  left: 8,
  child: FutureBuilder<ImageInfo>(
    future: _getImageInfo(pet.image),
    builder: (context, snapshot) {
      ImageProvider imageProvider;

      if (snapshot.hasData) {
        final size = snapshot.data!.image;
        if (size.width == 80 && size.height == 80) {
          // ถ้าขนาด 80*80 → ใช้ default
          imageProvider = const AssetImage('assets/images/petnull.png');
        } else {
          imageProvider = NetworkImage(pet.image!.trim());
        }
      } else {
        // โหลดไม่ทันหรือ error → แสดง default
        imageProvider = const AssetImage('assets/images/petnull.png');
      }

      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.teal, width: 2),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider,
          ),
        ),
      );
    },
  ),
)



//
// ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                          ),
                        ),

                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 25,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : !showAn
                                        ? const SizedBox.shrink()
                                        : lListAn.isEmpty
                                            ? const Text(
                                                'ไม่มี AN สำหรับสัตว์นี้')
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            lListAn.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final anItem =
                                                              lListAn[index];
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (selectedAnNumber ==
                                                                    anItem
                                                                        .an_number) {
                                                                  return;
                                                                }

                                                                setState(() {
                                                                  selectedAnNumber =
                                                                      anItem
                                                                          .an_number;
                                                                  selectedAnModel =
                                                                      anItem;

                                                                  mPetAdmit_ =
                                                                      lPetAdmit
                                                                          .firstWhere(
                                                                    (pet) =>
                                                                        pet.an ==
                                                                        anItem
                                                                            .an_number,
                                                                    orElse: () =>
                                                                        ListPetModel(),
                                                                  );
                                                                  isLoadingTab =
                                                                      true;
                                                                  lGroupTabs =
                                                                      [];
                                                                  _tabController
                                                                      ?.dispose();
                                                                  _tabController =
                                                                      null;
                                                                  showTab =
                                                                      false;
                                                                });

                                                                final groupTabs =
                                                                    await RoundWardApi()
                                                                        .loadHeadGroup(
                                                                  context,
                                                                  headers_: widget
                                                                      .headers,
                                                                );

                                                                // final newOrders =
                                                                //     await RoundWardApi()
                                                                //         .loadNewOrder(
                                                                //   context,
                                                                //   mPetAdmit_:
                                                                //       mPetAdmit_!,
                                                                //   headers_: widget
                                                                //       .headers,
                                                                // );
                                                                // setState(() {
                                                                //   hasNewOrders =
                                                                //       newOrders
                                                                //           .isNotEmpty;
                                                                // });

                                                                // if (!mounted) {
                                                                //   return;
                                                                // }

                                                                if (groupTabs
                                                                    .isNotEmpty) {
                                                                  final Map<
                                                                          String,
                                                                          List<
                                                                              ListRoundwardModel>>
                                                                      tempGroupedData =
                                                                      {};

                                                                  for (var group
                                                                      in groupTabs) {
                                                                    List<ListRoundwardModel>
                                                                        data =
                                                                        await RoundWardApi()
                                                                            .loadDataRoundWard(
                                                                      context,
                                                                      headers_:
                                                                          widget
                                                                              .headers,
                                                                      mListAn_:
                                                                          anItem,
                                                                      mGroup_:
                                                                          group,
                                                                    );
                                                                    tempGroupedData[
                                                                        group.type_name ??
                                                                            "-"] = data;
                                                                  }
                                                                  final newOrders =
                                                                      await RoundWardApi()
                                                                          .loadNewOrder(
                                                                    context,
                                                                    mPetAdmit_:
                                                                        mPetAdmit_!,
                                                                    headers_: widget
                                                                        .headers,
                                                                  );
                                                                  setState(() {
                                                                    hasNewOrders =
                                                                        newOrders
                                                                            .isNotEmpty;
                                                                  });

                                                                  if (!mounted) {
                                                                    return;
                                                                  }

                                                                  setState(() {
                                                                    lGroupTabs =
                                                                        groupTabs;

                                                                    groupedCardData =
                                                                        tempGroupedData;
                                                                    _tabController =
                                                                        TabController(
                                                                      vsync:
                                                                          this,
                                                                      length: groupTabs
                                                                          .length,
                                                                    );
                                                                    showTab =
                                                                        true;
                                                                    isLoadingTab =
                                                                        false;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    isLoadingTab =
                                                                        false;
                                                                  });
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor: selectedAnNumber ==
                                                                        anItem
                                                                            .an_number
                                                                    ? Colors.teal[
                                                                        100]
                                                                    : Colors
                                                                        .white,
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .teal,
                                                                  width: 1.5,
                                                                ),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                              child: text(
                                                                context,
                                                                anItem.an_number ??
                                                                    '',
                                                                color: Colors
                                                                    .teal[700],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    if (selectedAnModel != null)
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .menu_book_rounded,
                                                          size: 35,
                                                          color:
                                                              selectedAnModel ==
                                                                      null
                                                                  ? Colors.grey
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      77,
                                                                      156,
                                                                      216),
                                                        ),
                                                        onPressed: () async {
                                                          final dialog =
                                                              AwesomeDialog(
                                                            context: context,
                                                            customHeader:
                                                                Image.asset(
                                                              "assets/gif/load.gif",
                                                              width: 200,
                                                              height: 100,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            dialogType:
                                                                DialogType
                                                                    .noHeader,
                                                            animType:
                                                                AnimType.scale,
                                                            dismissOnTouchOutside:
                                                                false,
                                                            dismissOnBackKeyPress:
                                                                false,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                            body: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  "กำลังโหลดข้อมูล Progress Note กรุณารอสักครู่...",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                              ],
                                                            ),
                                                          );

                                                          dialog.show();

                                                          final matchedPet =
                                                              lPetAdmit
                                                                  .firstWhere(
                                                            (pet) =>
                                                                pet.an ==
                                                                selectedAnModel
                                                                    ?.an_number,
                                                            orElse: () =>
                                                                ListPetModel(),
                                                          );

                                                          final progressList =
                                                              await RoundWardApi()
                                                                  .loadProgress(
                                                            context,
                                                            headers_:
                                                                widget.headers,
                                                            mPetAdmit_:
                                                                matchedPet,
                                                          );

                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }

                                                          setState(() {
                                                            lProgressNote =
                                                                progressList;
                                                            showNote = true;
                                                          });

                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();

                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return ProgressNoteDialog(
                                                                lProgressNote:
                                                                    lProgressNote,
                                                                onClose: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      )
                                                  ],
                                                ),
                                              ),
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: isLoadingTab
                              ? const Center(child: CircularProgressIndicator())
                              : !showTab
                                  ? const Center(child: Text('No data'))
                                  : (_tabController == null ||
                                          lGroupTabs.isEmpty)
                                      ? const Center(child: Text('No data'))
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TabContainer(
                                              controller: _tabController!,
                                              tabEdge: TabEdge.top,
                                              tabsStart: 0.0,
                                              tabsEnd: 1.0,
                                              tabMaxLength: 120,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              tabBorderRadius:
                                                  BorderRadius.circular(10),
                                              childPadding:
                                                  const EdgeInsets.all(20.0),
                                              selectedTextStyle:
                                                  const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),
                                              unselectedTextStyle:
                                                  const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 13.0,
                                              ),
                                              colors: [
                                                Colors.pink.shade100,
                                                const Color.fromARGB(
                                                    255, 144, 214, 247),
                                                const Color.fromARGB(
                                                    255, 255, 237, 148),
                                                const Color.fromARGB(
                                                    255, 210, 181, 245),
                                                const Color.fromARGB(
                                                    255, 160, 230, 172),
                                                const Color.fromARGB(
                                                    255, 255, 197, 157),
                                                const Color.fromARGB(
                                                    255, 232, 197, 255),
                                              ],
                                              tabs: lGroupTabs.map<Widget>((g) {
                                                final typeName =
                                                    g.type_name ?? '-';
                                                String imagePath;

                                                switch (typeName) {
                                                  case 'ยาฉีด':
                                                    imagePath =
                                                        'assets/images/1.png';
                                                    break;
                                                  case 'ยาใช้ภายนอก':
                                                    imagePath =
                                                        'assets/images/2.png';
                                                    break;
                                                  case 'ยาน้ำ':
                                                    imagePath =
                                                        'assets/images/3.png';
                                                    break;
                                                  case 'ยาเม็ด':
                                                    imagePath =
                                                        'assets/images/4.png';
                                                    break;
                                                  case 'ยาหยอด':
                                                    imagePath =
                                                        'assets/images/5.png';
                                                    break;
                                                  case 'อาหาร':
                                                    imagePath =
                                                        'assets/images/6.png';
                                                    break;
                                                  case 'OBS':
                                                    imagePath =
                                                        'assets/images/7.png';
                                                    break;
                                                  default:
                                                    imagePath =
                                                        'assets/images/food.png';
                                                }

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      imagePath,
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: text(
                                                        context,
                                                        typeName,
                                                        fontSize: 12,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                              children:
                                                  lGroupTabs.map<Widget>((g) {
                                                final typeName =
                                                    g.type_name ?? '-';
                                                final rawData =
                                                    groupedCardData[typeName] ??
                                                        [];

                                                return SizedBox(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: Stack(
                                                    children: [
                                                      rawData.isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No data'))
                                                          : Column(
                                                              children: [
                                                                SizedBox(
                                                                  child:
                                                                      InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      DateTime?
                                                                          pickedDate =
                                                                          await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate:
                                                                            _selectedDate,
                                                                        firstDate:
                                                                            DateTime(2020),
                                                                        lastDate:
                                                                            DateTime(2100),
                                                                      );

                                                                      if (pickedDate !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          _selectedDate =
                                                                              pickedDate;
                                                                          groupedCardData
                                                                              .clear();
                                                                        });

                                                                        await Future.delayed(const Duration(
                                                                            milliseconds:
                                                                                100));

                                                                        for (var group
                                                                            in lGroupTabs) {
                                                                          List<ListRoundwardModel>
                                                                              data_ =
                                                                              await RoundWardApi().loadDataRoundWard(
                                                                            context,
                                                                            headers_:
                                                                                widget.headers,
                                                                            mListAn_:
                                                                                selectedAnModel!,
                                                                            mGroup_:
                                                                                group,
                                                                            selectedDate:
                                                                                _selectedDate,
                                                                          );

                                                                          groupedCardData[group.type_name ?? '-'] =
                                                                              data_;
                                                                        }

                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.remove_red_eye,
                                                                              size: 20,
                                                                              color: Colors.black),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          text(
                                                                            context,
                                                                            'ดูข้อมูล ณ วันที่: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SingleChildScrollView(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            16),
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: CardRoundwardDrug(
                                                                          lDataCard:
                                                                              rawData,
                                                                          lSettingTime:
                                                                              lSettingTime,
                                                                          headers:
                                                                              widget.headers,
                                                                          lUserLogin:
                                                                              widget.lUserLogin,
                                                                          petAdmit:
                                                                              mPetAdmit_,
                                                                          selectedAn:
                                                                              selectedAnModel,
                                                                          selectedGroup:
                                                                              g,
                                                                          mListAn:
                                                                              selectedAnModel,
                                                                          mGroup:
                                                                              g,
                                                                          onDelete:
                                                                              (index) {},
                                                                          onEdit:
                                                                              (drug) {},
                                                                          onAdd:
                                                                              () {},
                                                                        )),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                      Positioned(
                                                        right: 16,
                                                        bottom: 16,
                                                        child: SpeedDial(
                                                          child: Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .teal,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.pets,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                              if (hasNewOrders)
                                                                Positioned(
                                                                  top: -8,
                                                                  right: -8,
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/gif/round3.gif',
                                                                    width: 25,
                                                                    height: 30,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          elevation: 0,
                                                          overlayColor: Colors
                                                              .transparent,
                                                          overlayOpacity: 0.0,
                                                          children: [
                                                            SpeedDialChild(
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/add_cat.png',
                                                                width: 28,
                                                                height: 28,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.pink
                                                                      .shade100,
                                                              label:
                                                                  'เพิ่มรายการ',
                                                              onTap: () {
                                                                final currentTab =
                                                                    lGroupTabs[
                                                                        _tabController!
                                                                            .index];
                                                                final typeName =
                                                                    currentTab
                                                                            .type_name
                                                                            ?.trim() ??
                                                                        '';

                                                                if (typeName
                                                                    .contains(
                                                                        'ยา')) {
                                                                  //!!!
                                                                  final group =
                                                                      currentTab;
                                                                  CreateDrugDialog
                                                                      .show(
                                                                    context,
                                                                    screen:
                                                                        'roundward',
                                                                    headers: widget
                                                                        .headers,
                                                                    lUserLogin:
                                                                        widget
                                                                            .lUserLogin,
                                                                    lPetAdmit: [
                                                                      mPetAdmit_!
                                                                    ],
                                                                    lListAn: [
                                                                      selectedAnModel!
                                                                    ],
                                                                    drugTypeName:
                                                                        group
                                                                            .type_name,
                                                                    onAddDrug_:
                                                                        (newDrug) {},
                                                                    rwAddDrug_:
                                                                        () async {
                                                                      groupedCardData
                                                                          .clear();
                                                                      setState(
                                                                          () {});
                                                                      Future.delayed(Duration(
                                                                          milliseconds:
                                                                              100));
                                                                      for (var group
                                                                          in lGroupTabs) {
                                                                        List<ListRoundwardModel>
                                                                            data_ =
                                                                            await RoundWardApi().loadDataRoundWard(
                                                                          context,
                                                                          headers_:
                                                                              widget.headers,
                                                                          mListAn_:
                                                                              selectedAnModel!,
                                                                          mGroup_:
                                                                              group,
                                                                        );
                                                                        groupedCardData[group.type_name ??
                                                                                '-'] =
                                                                            data_;
                                                                      }

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  );
                                                                } else if (typeName
                                                                    .contains(
                                                                        'อาหาร')) {
                                                                  final group =
                                                                      currentTab;
                                                                  CreateFoodDialog
                                                                      .show(
                                                                    context,
                                                                    screen:
                                                                        'roundward',
                                                                    headers: widget
                                                                        .headers,
                                                                    lUserLogin:
                                                                        widget
                                                                            .lUserLogin,
                                                                    lPetAdmit: [
                                                                      mPetAdmit_!
                                                                    ],
                                                                    lListAn: [
                                                                      selectedAnModel!
                                                                    ],
                                                                    drugTypeName:
                                                                        group
                                                                            .type_name,
                                                                    onAddFood:
                                                                        (newFood) async {},
                                                                    rwAddFood_:
                                                                        () async {
                                                                      groupedCardData
                                                                          .clear();
                                                                      setState(
                                                                          () {});
                                                                      Future.delayed(Duration(
                                                                          milliseconds:
                                                                              100));
                                                                      for (var group
                                                                          in lGroupTabs) {
                                                                        List<ListRoundwardModel>
                                                                            data_ =
                                                                            await RoundWardApi().loadDataRoundWard(
                                                                          context,
                                                                          headers_:
                                                                              widget.headers,
                                                                          mListAn_:
                                                                              selectedAnModel!,
                                                                          mGroup_:
                                                                              group,
                                                                        );
                                                                        groupedCardData[group.type_name ??
                                                                                '-'] =
                                                                            data_;
                                                                      }

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  );
                                                                } else if (typeName
                                                                    .contains(
                                                                        'OBS')) {
                                                                  final group =
                                                                      currentTab;

                                                                  CreateObsDialog
                                                                      .show(
                                                                    context,
                                                                    screen:
                                                                        'roundward',
                                                                    headers: widget
                                                                        .headers,
                                                                    lUserLogin:
                                                                        widget
                                                                            .lUserLogin,
                                                                    lPetAdmit: [
                                                                      mPetAdmit_!
                                                                    ],
                                                                    lListAn: [
                                                                      selectedAnModel!
                                                                    ],
                                                                    drugTypeName:
                                                                        group
                                                                            .type_name,
                                                                    onAddObs:
                                                                        (newObs) {},
                                                                    rwAddObs_:
                                                                        () async {
                                                                      groupedCardData
                                                                          .clear();
                                                                      setState(
                                                                          () {});
                                                                      Future.delayed(Duration(
                                                                          milliseconds:
                                                                              100));
                                                                      for (var group
                                                                          in lGroupTabs) {
                                                                        List<ListRoundwardModel>
                                                                            data_ =
                                                                            await RoundWardApi().loadDataRoundWard(
                                                                          context,
                                                                          headers_:
                                                                              widget.headers,
                                                                          mListAn_:
                                                                              selectedAnModel!,
                                                                          mGroup_:
                                                                              group,
                                                                        );
                                                                        groupedCardData[group.type_name ??
                                                                                '-'] =
                                                                            data_;
                                                                      }

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            SpeedDialChild(
                                                                child: Stack(
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/icons/add_cat.png',
                                                                      width: 28,
                                                                      height:
                                                                          28,
                                                                    ),
                                                                    if (hasNewOrders)
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        top: 0,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              8,
                                                                          height:
                                                                              8,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .lightBlue
                                                                        .shade100,
                                                                label:
                                                                    'รายการใหม่',
                                                                onTap:
                                                                    () async {
                                                                  if (_isLoadingNewOrder)
                                                                    return;
                                                                  _isLoadingNewOrder =
                                                                      true;

                                                                  try {
                                                                    final currentTab =
                                                                        lGroupTabs[
                                                                            _tabController!.index];
                                                                    if (mPetAdmit_?.visit_id !=
                                                                            null &&
                                                                        selectedAnModel !=
                                                                            null) {
                                                                      await showNewOrderDialog(
                                                                        context,
                                                                        mPetAdmit_!,
                                                                        widget
                                                                            .headers,
                                                                        selectedAnModel!,
                                                                        widget
                                                                            .lUserLogin
                                                                            .first,
                                                                        selectedAnModel!,
                                                                        currentTab,
                                                                        (updatedData,
                                                                            hasNew) async {
                                                                          groupedCardData
                                                                              .clear();
                                                                          setState(
                                                                              () {});

                                                                          for (final group
                                                                              in lGroupTabs) {
                                                                            final data =
                                                                                await RoundWardApi().loadDataRoundWard(
                                                                              context,
                                                                              headers_: widget.headers,
                                                                              mListAn_: selectedAnModel!,
                                                                              mGroup_: group,
                                                                            );
                                                                            groupedCardData[group.type_name ?? '-'] =
                                                                                data;
                                                                          }

                                                                          if (mounted)
                                                                            setState(() {});
                                                                        },
                                                                      );
                                                                    }
                                                                  } finally {
                                                                    _isLoadingNewOrder =
                                                                        false;
                                                                  }
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> showNewOrderDialog(
    BuildContext context,
    ListPetModel mPetAdmit_,
    Map<String, String> headers_,
    ListAnModel mListAn_,
    ListUserModel userLogin,
    ListAnModel selectedAnModel,
    ListGroupModel selectedGroup,
    void Function(List<ListRoundwardModel> updatedData, bool hasNew) onRefresh,
  ) async {
    List<NewOrderModel> orders = [];
    bool isLoading = true;
    String? loadError;

    bool requestedOnce = false;
    bool busy = false;

    Future<void> refreshOrders(StateSetter setState) async {
      if (busy) return;
      busy = true;
      try {
        setState(() {
          isLoading = true;
          loadError = null;
        });

        final reloaded = await RoundWardApi().loadNewOrder(
          context,
          mPetAdmit_: mPetAdmit_,
          headers_: headers_,
        );

        setState(() {
          orders = reloaded;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          loadError = 'เกิดข้อผิดพลาดในการโหลดข้อมูล';
          isLoading = false;
        });
      } finally {
        busy = false;
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!requestedOnce) {
              requestedOnce = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                refreshOrders(setState);
              });
            }

            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF00B4D8), Color(0xFF48CAE4)],
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.playlist_add_check_circle_outlined,
                                color: Colors.white, size: 26),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'รายการใหม่ จาก Imedx',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 460,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: () {
                            if (isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (loadError != null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(loadError!,
                                      style:
                                          const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => refreshOrders(setState),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('ลองอีกครั้ง'),
                                  ),
                                ],
                              );
                            }
                            if (orders.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'ไม่พบข้อมูล',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => refreshOrders(setState),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('รีเฟรช'),
                                  ),
                                ],
                              );
                            }

                            return Scrollbar(
                              thumbVisibility: true,
                              child: ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final item = orders[index];
                                  final isFood =
                                      item.drug_type_name == '[PF]อาหารสัตว์';
                                  final isDrug = !isFood;

                                  return Card(
                                    elevation: 2,
                                    color: isDrug
                                        ? Colors.blue.shade50
                                        : Colors.orange.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.item_name ?? "-",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              OutlinedButton.icon(
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.teal[800],
                                                  side: const BorderSide(
                                                      color: Colors.teal,
                                                      width: 1.8),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                icon: const Icon(
                                                    Icons.add_circle_outline),
                                                label: const Text(
                                                    'เพิ่มรายการใหม่เข้า'),
                                                onPressed: () {
                                                  openDrug() {
                                                    CheckDrugOrderDialog.show(
                                                      context,
                                                      AddOrder(item),
                                                      0,
                                                      (newDrug, _) async {
                                                        newDrug.order_eid =
                                                            item.order_eid;
                                                        newDrug.order_date =
                                                            item.order_date;
                                                        newDrug.order_time =
                                                            item.order_time;

                                                        await RoundWardApi()
                                                            .AddOrder(
                                                          context,
                                                          headers_: headers_,
                                                          mUser: userLogin,
                                                          mPetAdmit_:
                                                              mPetAdmit_,
                                                          mListAn_: mListAn_,
                                                          lDataOrder_: [
                                                            newDrug
                                                          ],
                                                        );
                                                      },
                                                      headers_,
                                                      screen: 'imedx',
                                                      mUser: userLogin,
                                                      mPetAdmit: mPetAdmit_,
                                                      mListAn: mListAn_,
                                                      onConfirmed: () async {
                                                        setState(() {
                                                          orders.removeWhere((e) =>
                                                              e.order_item_id ==
                                                              item.order_item_id);
                                                        });
                                                      },
                                                    );
                                                  }

                                                  openFood() {
                                                    CheckFoodOrderDialog.show(
                                                      context,
                                                      AddOrder(item),
                                                      0,
                                                      (newFood, _) async {
                                                        newFood.order_eid =
                                                            item.order_eid;
                                                        newFood.order_date =
                                                            item.order_date;
                                                        newFood.order_time =
                                                            item.order_time;

                                                        await RoundWardApi()
                                                            .AddOrder(
                                                          context,
                                                          headers_: headers_,
                                                          mUser: userLogin,
                                                          mPetAdmit_:
                                                              mPetAdmit_,
                                                          mListAn_: mListAn_,
                                                          lDataOrder_: [
                                                            newFood
                                                          ],
                                                        );
                                                      },
                                                      headers_,
                                                      screen: 'imedx',
                                                      mUser: userLogin,
                                                      mPetAdmit: mPetAdmit_,
                                                      mListAn: mListAn_,
                                                      onConfirmed: () async {
                                                        setState(() {
                                                          orders.removeWhere((e) =>
                                                              e.order_item_id ==
                                                              item.order_item_id);
                                                        });
                                                      },
                                                    );
                                                  }

                                                  if (isDrug) {
                                                    openDrug();
                                                  } else {
                                                    openFood();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              text(context,
                                                  'จำนวน : ${item.item_qty ?? "-"} ${item.unit_name ?? "-"}'),
                                              const SizedBox(height: 4),
                                              if (isDrug)
                                                text(context,
                                                    'ขนาดยา : ${item.dose_qty ?? "-"} ${item.dose_unit_name ?? "-"}'),
                                              const SizedBox(height: 4),
                                              text(context,
                                                  'ประเภท : ${item.drug_type_name ?? "-"}'),
                                              if ((item.note_to_team
                                                      ?.isNotEmpty ??
                                                  false)) ...[
                                                const SizedBox(height: 4),
                                                text(context,
                                                    'หมายเหตุ : ${item.note_to_team}'),
                                              ],
                                              const SizedBox(height: 4),
                                              text(context,
                                                  'วิธีให้ : ${item.drug_instruction ?? "-"}'),
                                              const SizedBox(height: 4),
                                              if (isDrug)
                                                text(context,
                                                    'วันที่สั่งยา : ${item.order_date ?? "-"} ${item.order_time ?? "-"}'),
                                              if (isFood)
                                                text(context,
                                                    'วันที่สั่งอาหาร : ${item.order_date ?? "-"} ${item.order_time ?? "-"}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }(),
                        ),
                      ),

                      const Divider(height: 1),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                        child: Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => refreshOrders(setState),
                              icon: const Icon(Icons.refresh),
                              label: const Text('รีเฟรช'),
                            ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                      child: CircularProgressIndicator()),
                                );

                                final updatedData =
                                    await RoundWardApi().loadDataRoundWard(
                                  context,
                                  headers_: headers_,
                                  mListAn_: selectedAnModel,
                                  mGroup_: selectedGroup,
                                );

                                final hasNew = orders.isNotEmpty;

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Navigator.of(context).pop(true);

                                onRefresh(updatedData, hasNew);
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('ปิด'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  DataAddOrderModel AddOrder(NewOrderModel e) {
    return DataAddOrderModel(
      item_name: e.item_name,
      type_card: e.item_type_name,
      item_qty: e.item_qty?.toString(),
      unit_name: e.unit_name,
      dose_qty: e.dose_qty,
      drug_instruction: e.drug_instruction,
      take_time: '[]',
      meal_timing: '',
      start_date_use: e.start_date_use,
      end_date_use: e.end_date_use,
      stock_out: 0,
      remark: '',
      order_item_id: e.order_item_id?.toString(),
      doctor_eid: e.doctor_eid,
      item_code: e.item_code,
      note_to_team: e.note_to_team,
      caution: e.caution,
      drug_description: e.drug_description,
      order_eid: e.order_eid,
      order_date: e.order_date,
      order_time: e.order_time,
      drug_type_name: e.drug_type_name,
      unit_stock: '',
      status: 'Order',
    );
  }

  Future<void> refreshGroupedData() async {
    groupedCardData.clear();
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 100));

    for (var group in lGroupTabs) {
      final data_ = await RoundWardApi().loadDataRoundWard(
        context,
        headers_: widget.headers,
        mListAn_: selectedAnModel!,
        mGroup_: group,
      );
      groupedCardData[group.type_name ?? '-'] = data_;
    }

    setState(() {});
  }

  bool _isProbablyPhoto(String? raw) {
    if (raw == null) return false;
    final u = raw.trim();
    if (u.isEmpty || u.toLowerCase() == 'null') return false;

    final s = u.toLowerCase();
    const badHints = [
      'noimage',
      'no-image',
      'placeholder',
      'default',
      'avatar',
      'user.png',
      'profile.png',
      'blank.png'
    ];
    for (final h in badHints) {
      if (s.contains(h)) return false;
    }

    final looksLikeImage = RegExp(r'\.(jpg|jpeg|png)(\?.*)?$').hasMatch(s);
    if (!looksLikeImage) return false;

    return true;
  }
// ฟังก์ชันเช็คขนาดรูป
Future<ImageInfo> _getImageInfo(String? url) async {
  if (url == null || url.trim().isEmpty || url.toLowerCase() == 'null') {
    throw Exception("No image");
  }

  final completer = Completer<ImageInfo>();
  final imageProvider = NetworkImage(url.trim());

  imageProvider.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }, onError: (dynamic _, __) {
      completer.completeError("Load error");
    }),
  );

  return completer.future;
}
}
