// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/create_transection_model.dart';
import 'package:e_smartward/dialog/edit_Food_dialog.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/Model/list_data_roundward_model.dart';
import 'package:e_smartward/Model/list_group_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_roundward_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/roundward_api.dart';
import 'package:e_smartward/dialog/edit_drug_dialog.dart';
import 'package:e_smartward/dialog/edit_obs_dialog.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/data_note_model.dart';
import '../api/note_api.dart';

// ignore: must_be_immutable
class CardRoundwardDrug extends StatefulWidget {
  final List<ListRoundwardModel> lDataCard;
  final Map<String, String> headers;
  final Function(ListRoundwardModel drug) onEdit;
  final void Function(int index) onDelete;
  final VoidCallback onAdd;
  final List<ListDataObsDetailModel> lSettingTime;
  DataNoteModel? dataNote;

  final ListPetModel? petAdmit;
  final ListAnModel? selectedAn;
  final ListGroupModel? selectedGroup;
  final ListGroupModel? mGroup;
  final ListAnModel? mListAn;
  List<ListUserModel> lUserLogin;

  CardRoundwardDrug({
    super.key,
    required this.lDataCard,
    required this.headers,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.lSettingTime,
    this.mGroup,
    this.mListAn,
    this.petAdmit,
    this.selectedAn,
    this.selectedGroup,
    required this.lUserLogin,
    this.dataNote,
  });
  @override
  State<CardRoundwardDrug> createState() => _CardRoundwardDrugState();
}

List<FileModel> localFiles = [];

List<Map<String, dynamic>> generateTimeSlots() {
  List<String> allHours = List.generate(
    24,
    (index) => '${index.toString().padLeft(2, '0')}:00',
  );

  return allHours.map((time) {
    return {
      'time': time,
    };
  }).toList();
}

extension IterableFirstWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E e) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}

class _CardRoundwardDrugState extends State<CardRoundwardDrug> {
  List<Map<String, dynamic>> timeSlots = generateTimeSlots();

  final tooltipController = JustTheController();
  List<ListRoundwardModel> lDataRoundward = [];

  Color getColorByType(String type) {
    switch (type) {
      case 'Drug':
        return const Color.fromARGB(255, 61, 116, 161);
      case 'Food':
        return Colors.green;
      case 'Observe':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  String getStatusText(String? status, String type) {
    switch (status?.toLowerCase()) {
      case 'success':
        return 'ให้แล้ว';
      case 'out':
        return type == 'Drug' ? 'ยาหมด' : 'อาหารหมด';
      case 'pass':
        return type == 'Drug' ? 'งดยา' : 'งดอาหาร';
      default:
        return status ?? '-';
    }
  }

  String getStatusIcon(String? status, {String? type}) {
    switch (status?.toLowerCase()) {
      case 'success':
        return 'assets/icons/success.png';
      case 'pass':
        return 'assets/icons/pass.png';
      case 'out':
        return 'assets/icons/out.png';

      default:
        if (type == 'Observe') {
          return 'assets/images/iobs01.png';
        } else {
          return '';
        }
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // loadFiles().then((_) {});

    lDataRoundward = widget.lDataCard;
  }

  Future<void> loadData() async {
    if (widget.mListAn == null || widget.mGroup == null) return;

    final result = await RoundWardApi().loadDataRoundWard(
      context,
      headers_: widget.headers,
      mListAn_: widget.mListAn!,
      mGroup_: widget.mGroup!,
    );

    setState(() {
      lDataRoundward = result;
    });
  }

  List<FileModel> localFiles = [];

  Future<void> openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'ไม่สามารถเปิดลิงก์: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    const double slotHeight = 50;
    const int totalSlot = 24;
    const double headerHeight = 180;
    const double cardTotalHeight = headerHeight + (slotHeight * totalSlot);
    final type = widget.mGroup?.type_card ?? '';

    final List<String> timeLabels = List.generate(
      totalSlot,
      (index) => '${index.toString().padLeft(2, '0')}:00',
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: cardTotalHeight,
                  child: Column(
                    children: [
                      const SizedBox(height: headerHeight),
                      ...List.generate(timeLabels.length, (index) {
                        return SizedBox(
                          height: slotHeight,
                          width: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                timeLabels[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 25, 109, 177),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ...lDataRoundward.map((drug) {
                  return GestureDetector(
                    onTap: () => ShowDialog(
                      context,
                      type,
                      drug,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: 260,
                        height: cardTotalHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 217, 244, 251),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: headerHeight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (type == 'Drug') ...[
                                        Text("ยา : ${drug.item_name ?? '-'}",
                                            style: const TextStyle(
                                                color: Colors.blue)),
                                        const SizedBox(height: 4),
                                        text(context,
                                            "วิธีให้ ครั้งละ : ${drug.dose_qty_name ?? '-'} ${drug.unit_stock ?? '-'}",
                                            color: Colors.blue),
                                        const SizedBox(height: 4),
                                        if (drug.data_trans != null &&
                                            drug.data_trans!.isNotEmpty) ...[
                                          text(context,
                                              "คงเหลือ ณ ปัจจุบัน ${drug.total_useable ?? '-'} ชิ้น",
                                              color: Colors.blue)
                                        ]
                                      ] else if (type == 'Food') ...[
                                        text(
                                          context,
                                          "อาหาร : ${drug.item_name ?? '-'}",
                                          color:
                                              Color.fromARGB(255, 196, 133, 50),
                                        ),
                                        const SizedBox(height: 4),
                                        text(
                                          context,
                                          "วิธีให้ ครั้งละ : ${drug.dose_qty_name ?? '-'} ${drug.unit_stock ?? '-'}",
                                          color:
                                              Color.fromARGB(255, 196, 133, 50),
                                        ),
                                        if (drug.data_trans != null &&
                                            drug.data_trans!.isNotEmpty) ...[
                                          text(
                                            context,
                                            "คงเหลือ ณ ปัจจุบัน ${drug.total_useable ?? '-'} ครั้ง",
                                            color: Color.fromARGB(
                                                255, 196, 133, 50),
                                          )
                                        ]
                                      ] else if (type == 'Observe') ...[
                                        text(
                                          context,
                                          "สังเกตอาการ : ${drug.item_name ?? '-'}",
                                          color:
                                              Color.fromARGB(255, 231, 91, 208),
                                        ),
                                        const SizedBox(height: 4),
                                        text(
                                          context,
                                          "หมายเหตุ : ${drug.drug_description ?? '-'}",
                                          color:
                                              Color.fromARGB(255, 231, 91, 208),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              ...List.generate(timeLabels.length, (index) {
                                final slotTime = timeLabels[index];
                                ListDataRoundwardModel? tran;

                                try {
                                  tran = drug.data_trans?.firstWhere(
                                    (e) =>
                                        (e.slot ?? '').padLeft(5, '0') ==
                                        slotTime,
                                  );
                                } catch (e) {
                                  tran = null;
                                }

                                final matched = tran != null;
                                final hasStatus = tran?.status != null &&
                                    tran!.status!.isNotEmpty;

                                final rawTakeTimes = drug.take_time
                                    ?.replaceAll(RegExp(r"[^\d:,]"), "");
                                final takeTimeList =
                                    (rawTakeTimes?.split(",") ?? [])
                                        .map((e) => e.trim())
                                        .toList();
                                final shouldShowClock =
                                    takeTimeList.contains(slotTime);

                                final iconPath = hasStatus
                                    ? getStatusIcon(tran.status, type: type)
                                    : 'assets/icons/clock1.png';

                                final shouldShowRow =
                                    matched || shouldShowClock;

                                return SizedBox(
                                  height: slotHeight,
                                  child: Center(
                                    child: shouldShowRow
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 8),
                                              JustTheTooltip(
                                                isModal: true,
                                                backgroundColor: Colors.white,
                                                tailLength: 30,
                                                preferredDirection:
                                                    AxisDirection.up,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (type == 'Observe') ...[
                                                      const SizedBox(
                                                          height: 10),
                                                      text(
                                                        context,
                                                        '  รูปภาพที่แนบ:',
                                                      ),
                                                      const SizedBox(height: 6),
                                                      FutureBuilder<
                                                          List<FileModel>>(
                                                        future: NoteApi()
                                                            .loadFile(
                                                              context,
                                                              orderId:
                                                                  tran?.smw_transaction_order_id ??
                                                                      0,
                                                              headers_: widget
                                                                  .headers,
                                                            )
                                                            .then((files) =>
                                                                files
                                                                    .map((f) =>
                                                                        FileModel(
                                                                          path: f.path_file ??
                                                                              '',
                                                                          remark:
                                                                              f.remark ?? '',
                                                                        ))
                                                                    .toList()),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: SizedBox(
                                                                height: 24,
                                                                width: 24,
                                                                child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2),
                                                              ),
                                                            );
                                                          }

                                                          final relatedImages =
                                                              snapshot.data ??
                                                                  [];

                                                          if (relatedImages
                                                              .isEmpty) {
                                                            return const Text(
                                                              'ไม่มีรูปภาพ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            );
                                                          }

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        8.0),
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children:
                                                                    relatedImages
                                                                        .map(
                                                                            (file) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap: () =>
                                                                          openInBrowser(
                                                                              file.path),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                500,
                                                                            height:
                                                                                500,
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              child: Image.network(
                                                                                file.path,
                                                                                fit: BoxFit.cover,
                                                                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 4),
                                                                          if (file
                                                                              .remark
                                                                              .isNotEmpty)
                                                                            Text(
                                                                              'หมายเหตุ : ${file.remark}',
                                                                              style: const TextStyle(fontSize: 12),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ] else ...[
                                                      Text(
                                                        'เวลา: ${tran?.slot ?? slotTime}',
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'สถานะ: ${getStatusText(tran?.status, type)}',
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      if (tran?.comment !=
                                                              null &&
                                                          tran!.comment!
                                                              .isNotEmpty)
                                                        Text(
                                                          'หมายเหตุ: ${tran.comment ?? ''}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                    ],
                                                  ],
                                                ),
                                                child: Image.asset(
                                                  iconPath,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              text(
                                                context,
                                                type == 'Observe'
                                                    ? tran?.slot ?? slotTime
                                                    : '${tran?.slot ?? slotTime}${(tran?.status != null && tran!.status!.isNotEmpty) ? ' ${getStatusText(tran.status, type)}' : ''}',
                                                color: tran?.status == 'success'
                                                    ? Colors.green
                                                    : tran?.status == 'pass'
                                                        ? const Color.fromARGB(
                                                            255, 184, 112, 5)
                                                        : tran?.status == 'out'
                                                            ? Colors.red
                                                            : tran?.status ==
                                                                    'Complete'
                                                                ? Colors
                                                                    .pink[900]
                                                                : Colors.grey,
                                              ),
                                              SizedBox(width: 4),
                                              if (type == 'Observe' &&
                                                  (tran?.comment ?? '')
                                                      .trim()
                                                      .isNotEmpty)
                                                InkWell(
                                                  onTap: () {
                                                    AwesomeDialog(
                                                      customHeader: Image.asset(
                                                        'assets/gif/note.gif',
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                      context: context,
                                                      dialogType:
                                                          DialogType.info,
                                                      animType: AnimType.scale,
                                                      headerAnimationLoop:
                                                          false,
                                                      title: 'รายละเอียด',
                                                      body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Text(
                                                            (tran?.comment ??
                                                                    '')
                                                                .trim(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        ),
                                                      ),
                                                      btnOkOnPress: () {},
                                                      btnOkText: 'ปิด',
                                                    ).show();
                                                  },
                                                  child: text(
                                                    context,
                                                    (tran!.comment!.length <=
                                                            15)
                                                        ? tran.comment!
                                                        : '${tran.comment!.substring(0, 15)}...',
                                                    color: Colors.teal[900],
                                                  ),
                                                ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void ShowDialog(
      BuildContext context, String type, ListRoundwardModel detail) {
    switch (type) {
      case 'Drug':
        showDrug(context, detail);
        break;
      case 'Food':
        showFood(context, detail);
        break;
      case 'Observe':
        showObserve(context, detail);
        break;
      default:
        showDefault(context, detail);
    }
  }

  void showDrug(BuildContext context, ListRoundwardModel drug) {
    final ListDataCardModel drug_ = ListDataCardModel(
      item_name: drug.item_name,
      dose_qty: drug.dose_qty,
      //  double.tryParse(drug.dose_qty ?? '0'),
      item_qty: drug.item_qty,
      unit_name: drug.unit_name,
      unit_stock: drug.unit_stock,
      drug_type_name: drug.drug_type_name,
      drug_description: drug.drug_description,
      remark: drug.remark,
      doctor_eid: drug.doctor_eid,
      meal_timing: drug.meal_timing,
      take_time: drug.take_time,
      time_slot: drug.time_slot,
      order_item_id: drug.order_item_id,
    );

    Future.delayed(Duration.zero, () async {
      await EditDrugDialog.show(
        context,
        drug_,
        0,
        (updatedDrug, index) {},
        widget.headers,
        screen: 'roundward',
        lUserLogin: widget.lUserLogin,
        lPetAdmit: [widget.petAdmit!],
        lListAn: [widget.selectedAn!],
        drugTypeName: widget.selectedGroup?.type_name ?? '',
        mData: drug,
        group: widget.selectedGroup,
        onRefresh: (updatedData, hasNew) {
          setState(() {
            lDataRoundward = updatedData;
          });
        },
      );
    });
  }

  void showObserve(BuildContext context, ListRoundwardModel observe) {
    final tempSetValue = jsonEncode({
      "obs": 1,
      "col": 0,
      "time_slot": observe.time_slot ?? "เมื่อมีอาการ",
      "delete": 0,
    });

    final ListDataObsDetailModel obsDetail = ListDataObsDetailModel(
      set_name: observe.item_name,
      set_value: tempSetValue,
      remark: observe.remark,
      take_time: observe.take_time,
      drug_type_name: observe.drug_type_name,
      time_slot: observe.time_slot,
    );

    Future.delayed(Duration.zero, () async {
      EditObsDialog.showObs(
        context,
        obsDetail,
        0,
        (updatedObs, index) {},
        widget.headers,
        screen: 'roundward',
        lUserLogin: widget.lUserLogin,
        lPetAdmit: [widget.petAdmit!],
        lListAn: [widget.selectedAn!],
        drugTypeName: widget.selectedGroup?.type_name ?? '',
        mData: observe,
        group: widget.selectedGroup,
        onRefresh: (updatedData, hasNew) {
          setState(() {
            lDataRoundward = updatedData;
          });
        },
      );
    });
  }

  void showDefault(BuildContext context, ListRoundwardModel drug) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ข้อมูลทั่วไป"),
        content: Text("ชื่อ: ${drug.item_name ?? '-'}"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ปิด")),
        ],
      ),
    );
  }

  void showFood(BuildContext context, ListRoundwardModel food) {
    final ListDataCardModel food_ = ListDataCardModel(
      item_name: food.item_name,
      dose_qty: food.dose_qty,
      // double.tryParse(food.dose_qty ?? '0'),
      item_qty: food.item_qty,
      unit_name: food.unit_name,
      unit_stock: food.unit_stock,
      drug_type_name: food.drug_type_name,
      drug_description: food.drug_description,
      remark: food.remark,
      doctor_eid: food.doctor_eid,
      meal_timing: food.meal_timing,
      take_time: food.take_time,
      time_slot: food.time_slot,
      order_item_id: food.order_item_id,
    );

    Future.delayed(Duration.zero, () async {
      await EditFoodDialog.showEditFoodDialog(
        context,
        food_,
        0,
        (updatedDrug, index) {},
        widget.headers,
        screen: 'roundward',
        lUserLogin: widget.lUserLogin,
        lPetAdmit: [widget.petAdmit!],
        lListAn: [widget.selectedAn!],
        drugTypeName: widget.selectedGroup?.type_name ?? '',
        mData: food,
        group: widget.selectedGroup,
        onRefresh: (updatedData, hasNew) {
          setState(() {
            lDataRoundward = updatedData;
          });
        },
      );
    });
  }
}

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แสดงรูปภาพ')),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100),
          ),
        ),
      ),
    );
  }
}
