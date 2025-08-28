// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:action_slider/action_slider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/Model/note_detail_model.dart';
import 'package:e_smartward/widget/action_slider.dart';
import 'package:e_smartward/widget/card_note_detail.dart';
import 'package:e_smartward/widget/header.dart';
import 'package:e_smartward/widget/new_card_note.dart';
import 'package:e_smartward/widget/switch_widget.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:e_smartward/widget/textfield.dart';

import '../Model/create_transection_model.dart';
import '../Model/list_pet_model.dart';
import '../api/note_api.dart';
import '../widget/dropdown.dart';

class NoteScreen extends StatefulWidget {
  final Map<String, String> headers;
  List<ListUserModel> lUserLogin;
  final String groupId;
  final String? siteCode;
  final String? wardCode;
  final bool isWardMode;
  final Function()? onRefresh;
  NoteScreen({
    super.key,
    required this.headers,
    required this.lUserLogin,
    required this.groupId,
    this.siteCode,
    this.wardCode,
    required this.isWardMode,
    this.onRefresh,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController? remarkNewNote;
  String? selectedGroupId;
  String? selectedSite;
  List<TextEditingController> remarkControllers = [];
  String? selectedWard;
  bool showCard = false;
  bool isLoading = false;
  String? errorMessage;
  bool isWardMode = false;
  List<ListPetModel> lPetAdmit = [];
  List<NoteDetailModel> lDataNote = [];
  final ActionSliderController actionController = ActionSliderController();
  String? visit_id;

  bool _isSubmitting = false;
  AwesomeDialog? _sendingDialog;
  List<String> setValue = [
    'เดินเล่น',
    'แปรงขน',
  ];
  Map<String, bool> selectedValues = {
    'เดินเล่น': false,
    'แปรงขน': false,
  };
  late ScrollController _scrollController;
  Map<int, Map<String, bool>> selectedValuesMap = {};

  TextEditingController tremark = TextEditingController();
  TextEditingController tTemp = TextEditingController();
  TextEditingController tWeight = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String searchPet = '';

  List<TextEditingController> lremark = [];
  List<TextEditingController> lTemp = [];
  List<TextEditingController> lWeight = [];
  NoteDetailModel? newNote;
  List<TextEditingController> lRemarkController = [];
  bool areAllCheckboxesChecked(NoteDetailModel note) {
    return note.dataNote.every((item) => item.pre_pare_status == '1');
  }

  @override
  void initState() {
    super.initState();
    lRemarkController = List.generate(lDataNote.length, (index) {
      return TextEditingController(text: lDataNote[index].remark ?? '');
    });
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    remarkNewNote?.dispose();
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
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/note01.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 5),
                            text(
                              context,
                              "ให้อาหาร,ยา และสังเกตอาการ",
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                                  const SizedBox(width: 15),
                                  text(
                                    context,
                                    'Ward : ',
                                    color: Colors.teal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                      width: 300,
                                      height: 30,
                                      child: WardDropdown(
                                        headers_: widget.headers,
                                        selectedSiteCode: selectedSite,
                                        onSelected: (ward) {
                                          setState(() {
                                            selectedWard = ward;
                                            showCard = false;
                                            errorMessage = null;
                                          });
                                        },
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
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
                                    final result =
                                        await NoteApi().loadListAdmit(
                                      context,
                                      headers_: widget.headers,
                                      groupId: selectedGroupId ?? '',
                                      siteCode: selectedSite ?? '',
                                      ward: selectedWard ?? '',
                                      type: isWardMode ? 'WARD' : 'GROUP-BED',
                                    );

                                    setState(() {
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
                                      borderRadius: BorderRadius.circular(20),
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
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.teal),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.teal, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.teal, width: 2),
                          ),
                        ),
                        onChanged: (value) => setState(() => searchPet = value),
                      ),
                    ),
                  ),
                ],
                if (showCard &&
                    ((isWardMode &&
                            selectedSite != null &&
                            selectedWard != null) ||
                        (!isWardMode && selectedGroupId != null)))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : listToShow.isEmpty
                              ? const Center(child: Text('ไม่พบข้อมูล'))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listToShow.length,
                                  itemBuilder: (context, index) {
                                    final pet = listToShow[index];
                                    String hn = pet.hn ?? '';
                                    String name = pet.pet_name ?? '';
                                    String site = pet.base_site_branch_id ?? '';
                                    String ward = pet.ward ?? '';
                                    String bed = pet.bed_number ?? '';

                                    String doctor = pet.doctor ?? '';
                                    String date = pet.admit_date ?? '';

                                    String formattedText =
                                        'HN: $hn\nName: $name\nSite: $site\nWard: $ward\nเตียง: $bed\nชื่อแพทย์: $doctor\nวันที่เข้ารักษา: $date';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          SizedBox(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                final visitId =
                                                    lPetAdmit[index].visit_id;
                                                if (visitId == null) return;

                                                setState(() {
                                                  isLoading = true;
                                                  visit_id = visitId;
                                                  lDataNote = [];

                                                  newNote = null;
                                                  remarkNewNote?.dispose();
                                                  remarkNewNote = null;
                                                });

                                                final data = await NoteApi()
                                                    .loadNoteDetail(
                                                  context,
                                                  visitId: visitId,
                                                  headers_: widget.headers,
                                                  date_time: '',
                                                );

                                                setState(() {
                                                  lDataNote = data;

                                                  lRemarkController =
                                                      List.generate(
                                                    lDataNote.length,
                                                    (index) =>
                                                        TextEditingController(
                                                      text: lDataNote[index]
                                                              .remark ??
                                                          '',
                                                    ),
                                                  );

                                                  showCard = true;
                                                  isLoading = false;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: visit_id ==
                                                        lPetAdmit[index]
                                                            .visit_id
                                                    ? Colors.teal[100]
                                                    : Colors.white,
                                                side: const BorderSide(
                                                    color: Colors.teal,
                                                    width: 2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 30),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50.0),
                                                child: text(
                                                    context, formattedText,
                                                    textAlign: TextAlign.start,
                                                    color: Colors.teal),
                                              ),
                                            ),
                                          ),
                                          const Positioned(
                                            left: 8,
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: AssetImage(
                                                  'assets/images/ward.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                if (showCard &&
                    ((isWardMode &&
                            selectedSite != null &&
                            selectedWard != null) ||
                        (!isWardMode && selectedGroupId != null)))
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: (newNote != null ? 1 : 0) + lDataNote.length,
                      itemBuilder: (context, index) {
                        final screenWidth = MediaQuery.of(context).size.width;

                        //>> ===== กรณีเป็นการ์ดใหม่ index == 0 ===== <<//
                        if (newNote != null && index == 0) {
                          remarkNewNote ??= TextEditingController(
                              text: newNote!.remark ?? '');
                          final bool allCardsHaveOrderId =
                              newNote!.dataNote.every(
                            (item) =>
                                item.smw_admit_order_id != null &&
                                item.smw_admit_order_id != 0,
                          );

                          if (newNote!.dataNote.isEmpty) {
                            return Container(
                              key: const ValueKey('new_note_card'),
                              width: screenWidth * 0.50,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 155, 202, 202),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text('ยังไม่มีรายการในบันทึกใหม่'),
                              ),
                            );
                          }

                          return Container(
                            key: const ValueKey('new_note_card'),
                            width: screenWidth * 0.50,
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 155, 202, 202),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        newNote = null;
                                        remarkNewNote?.dispose();
                                        remarkNewNote = null;
                                      });
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: text(
                                    context,
                                    "วันที่: ${newNote!.create_date?.isNotEmpty == true ? newNote!.create_date : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: newNote?.dataNote.length,
                                    itemBuilder: (context, subIndex) {
                                      final card = newNote!.dataNote[subIndex];
                                      final matchedPet = lPetAdmit.firstWhere(
                                        (pet) =>
                                            pet.id == newNote!.smw_admit_id,
                                        orElse: () => lPetAdmit.first,
                                      );
                                      return NewNoteCardWidget(
                                        onRemove: () {
                                          setState(() {
                                            newNote!.dataNote
                                                .removeWhere((e) => e == card);
                                          });
                                        },
                                        visit: visit_id!,
                                        dataNote: card,
                                        foodName: card.item_name ?? '-',
                                        method: card.drug_instruction ?? '-',
                                        time: card.time_slot ?? '-',
                                        amountStatus: card.meal_timing ?? '-',
                                        isDone: card.status == '1',
                                        isChecked: card.pre_pare_status == '1',
                                        typeCard: card.type_card ?? '',
                                        onCheckboxChanged: (val) {
                                          setState(() {
                                            card.pre_pare_status =
                                                (val ?? false) ? '1' : '0';
                                          });
                                        },
                                        onToggle: () {
                                          setState(() {
                                            card.status = (card.status == '1')
                                                ? '0'
                                                : '1';
                                          });
                                        },
                                        onRefresh: () async {
                                          //XXX3
                                          // final updated = await NoteApi()
                                          //     .loadNoteDetail(
                                          //   context,
                                          //   visitId: visit_id!,
                                          //   headers_: widget.headers,
                                          //   date_time: '',
                                          // );
                                          // setState(() {
                                          //   lDataNote = updated;
                                          // });
                                        },
                                        lUserLogin: widget.lUserLogin,
                                        headers: widget.headers,
                                        note: newNote!,
                                        isDisabled: false,
                                        lPetAdmit: lPetAdmit,
                                        petAdmit: matchedPet,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15),
                                textFieldNote(
                                  context,
                                  "หมายเหตุ",
                                  controller: remarkNewNote!,
                                  readOnly: false,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.save,
                                        size: 18, color: Colors.teal),
                                    const SizedBox(width: 6),
                                    text(
                                      context,
                                      "ผู้บันทึก : ${newNote!.create_by_name ?? 'ยังไม่มีผู้บันทึก'}",
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // if (newNote!.dataNote.any((e) {
                                //   final id = e.smw_transaction_order_id;
                                //   if (id == null) return false;
                                //   final s = id.toString().trim();
                                //   return s.isNotEmpty && s != '0';
                                // }))
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    actionSlider(
                                      context,
                                      'ยืนยันการให้อาหารและยา',
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 30.0,
                                      togglecolor: allCardsHaveOrderId
                                          ? Colors.green
                                          : Colors.grey,
                                      icons: Icons.check,
                                      iconColor: Colors.white,
                                      asController: ActionSliderController(),
                                      action: (controller) async {
                                        if (_isSubmitting) return;
                                        _isSubmitting = true;

                                        // _dismissSendingDialog();

                                        final hasAnyOrderId =
                                            newNote!.dataNote.any((e) {
                                          final id = e.smw_transaction_order_id;
                                          if (id == null) return false;
                                          final s = id.toString().trim();
                                          return s.isNotEmpty && s != '0';
                                        });
                                        if (!hasAnyOrderId) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            title: 'ยังไม่มีข้อมูลจะส่ง',
                                            desc:
                                                'ไม่พบรายการที่บันทึกใหม่ กรุณาบันทึกรายการก่อนยืนยัน',
                                            btnOkOnPress: () {},
                                          ).show();
                                          return;
                                        }

                                        final itemsWithCheckbox = newNote!
                                            .dataNote
                                            .where((item) =>
                                                item.type_card == 'Food' ||
                                                item.type_card == 'Drug')
                                            .toList();

                                        final isAllChecked =
                                            itemsWithCheckbox.every(
                                          (item) => (item.status ?? '')
                                              .trim()
                                              .isNotEmpty,
                                        );

                                        if (!isAllChecked) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            title: 'กรุณาติ๊กสถานะให้ครบ',
                                            desc:
                                                'มีรายการอาหาร/ยาที่ยังไม่เลือกสถานะ',
                                            btnOkOnPress: () {},
                                          ).show();
                                          return;
                                        }

                                        // 2) สร้าง payload
                                        final mNoteData =
                                            CreateTransectionModel(
                                          smw_admit_id:
                                              newNote!.smw_admit_id ?? 0,
                                          slot: newNote!.slot ?? '',
                                          remark: remarkNewNote?.text ?? '',
                                          date_slot: newNote!.date_slot ??
                                              DateFormat('yyyy-MM-dd')
                                                  .format(DateTime.now()),
                                          tl_common_users_id:
                                              widget.lUserLogin.first.id ?? 0,
                                          dataNote:
                                              newNote!.dataNote.map((item) {
                                            final isObserve =
                                                item.type_card == 'Observe';
                                            return DataTransectionModel(
                                              smw_transaction_order_id:
                                                  item.smw_transaction_order_id,
                                              smw_admit_order_id:
                                                  item.smw_admit_order_id ?? 0,
                                              type_card: item.type_card ?? '',
                                              item_name: item.item_name ?? '',
                                              item_qty: item.item_qty ?? 0,
                                              unit_name: item.unit_name ?? '',
                                              dose_qty: item.dose_qty ?? '',
                                              meel_status:
                                                  item.meal_timing ?? '',
                                              drug_instruction:
                                                  item.drug_instruction ?? '',
                                              remark: item.remark ?? '',
                                              item_code: item.item_code ?? '',
                                              note_to_team:
                                                  item.note_to_team ?? '',
                                              caution: item.caution,
                                              drug_description:
                                                  item.drug_description ?? '',
                                              time_slot: item.time_slot ?? '',
                                              pre_pare_status:
                                                  item.pre_pare_status ?? '',
                                              date_slot: item.date_slot ?? '',
                                              slot: item.slot ?? '',
                                              status: isObserve
                                                  ? 'Complete'
                                                  : (item.status ?? ''),
                                              comment: item.comment,
                                              file: item.file ?? [],
                                            );
                                          }).toList(),
                                        );

                                        await NoteApi().CreateTransection(
                                          context,
                                          headers_: widget.headers,
                                          mNoteData: mNoteData,
                                          mPetAdmit_: lPetAdmit.first,
                                          mUser: widget.lUserLogin.first,
                                        );

                                        final updatedNotes =
                                            await NoteApi().loadNoteDetail(
                                          context,
                                          visitId: visit_id!,
                                          headers_: widget.headers,
                                          date_time: '',
                                        );

                                        for (var note in updatedNotes) {
                                          for (var item in note.dataNote) {
                                            final files =
                                                await NoteApi().loadFile(
                                              context,
                                              orderId:
                                                  item.smw_transaction_order_id ??
                                                      0,
                                              headers_: widget.headers,
                                            );
                                            item.file = files
                                                .map((f) => FileModel(
                                                    path: f.path_file ?? '',
                                                    remark: f.remark ?? ''))
                                                .toList();
                                          }
                                        }

                                        setState(() {
                                          lDataNote = updatedNotes;
                                          lRemarkController = List.generate(
                                            updatedNotes.length,
                                            (i) => TextEditingController(
                                                text: updatedNotes[i].remark ??
                                                    ''),
                                          );
                                          newNote = null;
                                          remarkNewNote?.clear();
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }

                        //>> ===== กรณีแสดงการ์ดปกติ ===== <<//
                        final realIndex = newNote != null ? index - 1 : index;
                        final note = lDataNote[realIndex];

                        final bool allCardsHaveOrderId = note.dataNote.every(
                          (item) =>
                              item.smw_admit_order_id != null &&
                              item.smw_admit_order_id != 0,
                        );

                        return Container(
                          width: screenWidth * 0.50,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (newNote == null && index == 0)
                                ? const Color.fromARGB(255, 155, 202, 202)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: text(
                                  context,
                                  (newNote == null && index == 0)
                                      ? "วันที่และเวลาปัจจุบัน : ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}"
                                      : "วันที่: ${note.create_date ?? '-'}",
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: note.dataNote.isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        itemCount: note.dataNote.length,
                                        itemBuilder: (context, subIndex) {
                                          final card = note.dataNote[subIndex];
                                          final matchedPet =
                                              lPetAdmit.firstWhere(
                                            (pet) =>
                                                pet.id == note.smw_admit_id,
                                            orElse: () => lPetAdmit.first,
                                          );

                                          return CardNoteWidget(
                                            dataNote: card,
                                            lPetAdmit: lPetAdmit,
                                            petAdmit: matchedPet,
                                            foodName: card.item_name ?? '-',
                                            method:
                                                card.drug_instruction ?? '-',
                                            time: card.time_slot ?? '-',
                                            amountStatus:
                                                card.meal_timing ?? '-',
                                            isDone: card.status == '1',
                                            isChecked:
                                                card.pre_pare_status == '1',
                                            isDisabled: index != 0,
                                            onRemove: () {
                                              setState(() {
                                                note.dataNote.remove(card);
                                              });
                                            },
                                            cb: (p0) {
                                              note.dataNote[subIndex].comment =
                                                  p0;
                                              setState(() {});
                                            },
                                            typeCard: card.type_card ?? '',
                                            onCheckboxChanged: (val) {
                                              setState(() {
                                                card.pre_pare_status =
                                                    (val ?? false) ? '1' : '0';
                                              });
                                            },
                                            onToggle: () {
                                              setState(() {
                                                card.status =
                                                    (card.status == '1')
                                                        ? '0'
                                                        : '1';
                                              });
                                            },
                                            onRefresh: () async {
                                              final updated = await NoteApi()
                                                  .loadNoteDetail(
                                                context,
                                                visitId: visit_id!,
                                                headers_: widget.headers,
                                                date_time: '',
                                              );
                                              setState(() {
                                                lDataNote = updated;
                                              });
                                            },
                                            lUserLogin: widget.lUserLogin,
                                            headers: widget.headers,
                                            note: note,
                                            visit: visit_id!,
                                          );
                                        },
                                      ),
                              ),
                              const SizedBox(height: 15),
                              textFieldNote(
                                context,
                                "หมายเหตุ",
                                controller: lRemarkController[realIndex],
                                readOnly: index != 0,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.save,
                                      size: 25, color: Colors.black),
                                  const SizedBox(width: 6),
                                  text(
                                    context,
                                    "ผู้บันทึก : ${note.create_by_name ?? 'ยังไม่มีผู้บันทึก'}",
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: SizedBox(
                                  child: lDataNote[realIndex].id != null
                                      ? null
                                      : actionSlider(
                                          context,
                                          'ยืนยันการให้อาหารและยา',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: 30.0,
                                          togglecolor: allCardsHaveOrderId
                                              ? Colors.green
                                              : Colors.grey,
                                          icons: Icons.check,
                                          iconColor: Colors.white,
                                          asController:
                                              ActionSliderController(),
                                          action: (controller) async {
                                            if (note.smw_admit_id == null ||
                                                note.smw_admit_id == 0) {
                                              controller.reset();
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.scale,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                desc:
                                                    'ไม่สามารถยืนยันได้ เนื่องจากยังไม่มี Admit ID',
                                                btnOkOnPress: () {},
                                              ).show();
                                              return;
                                            }

                                            final itemsWithCheckbox = note
                                                .dataNote
                                                .where(
                                                  (item) =>
                                                      item.type_card ==
                                                          'Food' ||
                                                      item.type_card == 'Drug',
                                                )
                                                .toList();

                                            final isAllChecked =
                                                itemsWithCheckbox.every(
                                              (item) => (item.status ?? '')
                                                  .trim()
                                                  .isNotEmpty,
                                            );

                                            // bool isCheckId = true;
                                            // if(itemsWithCheckbox
                                            //     .where((e) =>
                                            //         e.type_card == 'Food' || e.type_card == 'Drug').isNotEmpty)
                                            //         {
                                            //           isCheckId = itemsWithCheckbox
                                            //     .where((e) =>
                                            //         e.smw_transaction_order_id !=
                                            //             null &&
                                            //         e.type_card != 'Observe')
                                            //     .isNotEmpty;
                                            //         }

                                            final isCheckId = itemsWithCheckbox
                                                    .isEmpty ||
                                                itemsWithCheckbox
                                                    .where((e) =>
                                                        e.smw_transaction_order_id !=
                                                        null)
                                                    .isNotEmpty;

                                            if (!isAllChecked || !isCheckId) {
                                              controller.reset();
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.scale,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                desc:
                                                    'กรุณาบันทึกข้อมูลให้ครบทุกรายการก่อนยืนยัน',
                                                btnOkOnPress: () {},
                                              ).show();
                                              return;
                                            }

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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              body: const Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "กำลังส่งข้อมูล กรุณารอสักครู่...",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            );

                                            dialog.show();

                                            final mNoteData =
                                                CreateTransectionModel(
                                              smw_admit_id:
                                                  note.smw_admit_id ?? 0,
                                              slot: note.slot ?? '',
                                              remark:
                                                  lRemarkController[realIndex]
                                                      .text,
                                              date_slot: note.date_slot ??
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now()),
                                              tl_common_users_id:
                                                  widget.lUserLogin.first.id ??
                                                      0,
                                              dataNote:
                                                  note.dataNote.map((item) {
                                                final isObserve =
                                                    item.type_card == 'Observe';
                                                return DataTransectionModel(
                                                  smw_transaction_order_id: item
                                                      .smw_transaction_order_id,
                                                  smw_admit_order_id:
                                                      item.smw_admit_order_id ??
                                                          0,
                                                  type_card:
                                                      item.type_card ?? '',
                                                  item_name:
                                                      item.item_name ?? '',
                                                  item_qty: item.item_qty ?? 0,
                                                  unit_name:
                                                      item.unit_name ?? '',
                                                  dose_qty: item.dose_qty ?? '',
                                                  meel_status:
                                                      item.meal_timing ?? '',
                                                  drug_instruction:
                                                      item.drug_instruction ??
                                                          '',
                                                  remark: item.remark ?? '',
                                                  item_code:
                                                      item.item_code ?? '',
                                                  note_to_team:
                                                      item.note_to_team ?? '',
                                                  caution: item.caution,
                                                  drug_description:
                                                      item.drug_description ??
                                                          '',
                                                  time_slot:
                                                      item.time_slot ?? '',
                                                  pre_pare_status:
                                                      item.pre_pare_status ??
                                                          '',
                                                  date_slot:
                                                      item.date_slot ?? '',
                                                  slot: item.slot ?? '',
                                                  status: isObserve
                                                      ? 'Complete'
                                                      : (item.status ?? ''),
                                                  comment: item.comment,
                                                  file: item.file ?? [],
                                                );
                                              }).toList(),
                                            );

                                            await NoteApi().CreateTransection(
                                              context,
                                              headers_: widget.headers,
                                              mNoteData: mNoteData,
                                              mPetAdmit_: lPetAdmit.first,
                                              mUser: widget.lUserLogin.first,
                                            );

                                            final updatedNotes =
                                                await NoteApi().loadNoteDetail(
                                              context,
                                              visitId: visit_id!,
                                              headers_: widget.headers,
                                              date_time: '',
                                            );

                                            for (var note in updatedNotes) {
                                              for (var item in note.dataNote) {
                                                final files =
                                                    await NoteApi().loadFile(
                                                  context,
                                                  orderId:
                                                      item.smw_transaction_order_id ??
                                                          0,
                                                  headers_: widget.headers,
                                                );
                                                item.file = files
                                                    .map((f) => FileModel(
                                                          path:
                                                              f.path_file ?? '',
                                                          remark:
                                                              f.remark ?? '',
                                                        ))
                                                    .toList();
                                              }
                                            }

                                            lDataNote = [];
                                            setState(() {});
                                            await Future.delayed(const Duration(
                                                milliseconds: 40));
                                            lDataNote = updatedNotes;

                                            lRemarkController = List.generate(
                                              updatedNotes.length,
                                              (index) => TextEditingController(
                                                text: updatedNotes[index]
                                                        .remark ??
                                                    '',
                                              ),
                                            );

                                            setState(() {
                                              dialog.dismiss();
                                            });
                                          },
                                        ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ]))),
              if (showCard &&
                  newNote == null &&
                  ((isWardMode &&
                          selectedSite != null &&
                          selectedWard != null) ||
                      (!isWardMode && selectedGroupId != null)))
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: Colors.teal,
                        iconSize: 35,
                        onPressed: () async {
                          if (visit_id == null) return;

                          final noteDetailList = await NoteApi().loadNoteDetail(
                            context,
                            visitId: visit_id!,
                            headers_: widget.headers,
                            date_time: '',
                          );

                          final oldComments = <String, String>{};
                          for (final note in noteDetailList) {
                            for (final item in note.dataNote) {
                              final key = item.item_code ??
                                  '${item.smw_admit_order_id ?? ''}';
                              if (key.isNotEmpty) {
                                oldComments[key] = item.comment ?? '';
                              }
                            }
                          }

                          final result = await NoteApi().loadObsTransection(
                            context,
                            visitId: visit_id!,
                            headers_: widget.headers,
                          );

                          final newCard = result.firstWhere(
                            (note) => note.id == null,
                            orElse: () => NoteDetailModel(
                              id: null,
                              create_date: DateTime.now().toString(),
                              dataNote: const [],
                            ),
                          );

                          setState(() {
                            lDataNote = noteDetailList;

                            for (final note in lDataNote) {
                              for (final item in note.dataNote) {
                                final key = item.item_code ??
                                    '${item.smw_admit_order_id ?? ''}';
                                if (key.isNotEmpty &&
                                    oldComments.containsKey(key)) {
                                  item.comment = oldComments[key];
                                }
                              }
                            }

                            newNote = newCard;
                          });
                        },
                      ),
                    ],
                  ),
                ),
            ])));
  }

  // void _showSendingDialog() {
  //   _sendingDialog?.dismiss();
  //   _sendingDialog = AwesomeDialog(
  //     context: context,
  //     customHeader: Lottie.asset(
  //       "assets/animations/Send1.json",
  //       repeat: true,
  //       width: 200,
  //       height: 100,
  //       fit: BoxFit.contain,
  //     ),
  //     dialogType: DialogType.noHeader,
  //     animType: AnimType.scale,
  //     dismissOnTouchOutside: false,
  //     dismissOnBackKeyPress: false,
  //     width: MediaQuery.of(context).size.width * 0.3,
  //     body: const Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         SizedBox(height: 10),
  //         Text("กำลังส่งข้อมูล กรุณารอสักครู่...",
  //             textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
  //         SizedBox(height: 10),
  //       ],
  //     ),
  //   )..show();
  // }

  // void _dismissSendingDialog() {
  //   try {
  //     _sendingDialog?.dismiss();
  //   } catch (_) {}
  //   _sendingDialog = null;
  // }
}
