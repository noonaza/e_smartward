// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/create_transection_model.dart';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/dialog/edit_Food_dialog.dart';
import 'package:e_smartward/dialog/edit_obs_dialog_v2.dart';
import 'package:e_smartward/widget/admit_selectday.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
ScheduleMode _scheduleMode = ScheduleMode.weeklyOnce;
ScheduleResult? _schedule;
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

DateTime? _parseStartDateUse(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  final v = s.trim();

  for (final p in ['yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd HH:mm']) {
    try {
      return DateFormat(p).parseStrict(v);
    } catch (_) {}
  }
  return null;
}

DateTime? _parseOrderDate(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  final v = s.trim();

  for (final p in ['yyyy-MM-dd', 'dd/MM/yyyy']) {
    try {
      return DateFormat(p).parseStrict(v);
    } catch (_) {}
  }
  return null;
}

String labelFromTypeSlot(String? t) {
  switch (t) {
    case 'weekly_once':
      return 'กำหนดรายสัปดาห์';
    case 'daily_custom':
      return 'กำหนดรายวัน';
    case 'monthly_custom':
      return 'กำหนดรายเดือน';
    default:
      return '-';
  }
}

String _labelFromTypeSlotStd(String? t) {
  switch ((t ?? '').toUpperCase()) {
    case 'DAYS':
      return 'กำหนดรายสัปดาห์';
    case 'DATE':
      return 'กำหนดรายวัน';
    case 'D_M':
      return 'กำหนดรายเดือน';
    case 'ALL':
    default:
      return 'ไม่กำหนด';
  }
}

String _typeSlotFromMode(ScheduleMode m) {
  switch (m) {
    case ScheduleMode.weeklyOnce:
      return 'DAYS';
    case ScheduleMode.dailyCustom:
      return 'DATE';
    case ScheduleMode.monthlyCustom:
      return 'D_M';
    case ScheduleMode.all:
      return 'ALL';
  }
}

List<String> setValue = [
  'วางให้ทาน',
  'ปั่น',
  'แช่น้ำอุ่น',
  'สอดท่อกรองอาหาร',
  'ชั่งน้ำหนักอาหาร',
];
Map<String, bool> selectedValues = {
  'วางให้ทาน': false,
  'ปั่น': false,
  'แช่น้ำอุ่น': false,
  'สอดท่อกรองอาหาร': false,
  'ชั่งน้ำหนักอาหาร': false,
};

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

  Map<String, bool> selectStatus = {
    'ให้อาหารทันที': false,
  };
  List<String> setValueStatus = [
    'ให้อาหารทันที',
  ];

  DateTime _buildStartDateFromSchedule(
    ScheduleResult? s, {
    String? orderDate,
    String? initialStart,
  }) {
    final now = DateTime.now();

    DateTime? init;
    if (initialStart != null && initialStart.isNotEmpty) {
      try {
        init = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(initialStart);
      } catch (_) {}
    }

    DateTime? order;
    if (orderDate != null && orderDate.isNotEmpty) {
      try {
        order = DateFormat('yyyy-MM-dd').parseStrict(orderDate);
      } catch (_) {
        try {
          order = DateFormat('dd/MM/yyyy').parseStrict(orderDate);
        } catch (_) {}
      }
    }

    if (s?.mode == ScheduleMode.dailyCustom && s?.dailyDate != null) {
      final d = s!.dailyDate!;
      return DateTime(d.year, d.month, d.day, now.hour, now.minute, now.second);
    }

    if (order != null) {
      return DateTime(
          order.year, order.month, order.day, now.hour, now.minute, now.second);
    }

    return init ?? now;
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

  void _showScheduleDetail(
    BuildContext context,
    String scheduleLabel,
    String setSlotText,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        const themeColor = Color.fromARGB(255, 196, 133, 50);

        Widget infoRow({
          required IconData icon,
          required String title,
          required String value,
        }) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: themeColor),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style:
                          const TextStyle(color: Colors.black87, height: 1.35),
                      children: [
                        TextSpan(
                          text: "$title\n",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: value.isNotEmpty ? value : "-",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.schedule, color: themeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: text(
                        context,
                        "รายละเอียดกำหนดการ",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      splashRadius: 20,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Content
                infoRow(
                  icon: Icons.tune,
                  title: "กำหนด",
                  value: scheduleLabel,
                ),
                const SizedBox(height: 10),
                infoRow(
                  icon: Icons.event_available,
                  title: "วัน/เวลา",
                  value: setSlotText,
                ),

                const SizedBox(height: 14),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: themeColor,
                          side: const BorderSide(color: themeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("ปิด"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$label $value',
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
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
                ...lDataRoundward.asMap().entries.map((entry) {
                  final index = entry.key;
                  final drug = entry.value;

                  final setSlotText = formatSetSlot(drug.set_slot);

                  final String typeSlot = (drug.type_slot ?? 'ALL');
                  final scheduleLabel = (drug.schedule_mode_label != null &&
                          drug.schedule_mode_label!.trim().isNotEmpty)
                      ? drug.schedule_mode_label!
                      : _labelFromTypeSlotStd(typeSlot);

                  return GestureDetector(
                    onTap: () => ShowDialog(
                      context,
                      type,
                      drug,
                      index,
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
                                        text(
                                          context,
                                          "ควรให้ : ${drug.meal_timing ?? '-'}",
                                          color: Colors.blue,
                                        ),
                                        InkWell(
                                          onTap: () => _showScheduleDetail(
                                            context,
                                            scheduleLabel,
                                            setSlotText,
                                          ),
                                          child: text(
                                            context,
                                            "คลิกดูรายละเอียดการกำหนดเวลา",
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.blue,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (drug.data_trans != null &&
                                            drug.data_trans!.isNotEmpty) ...[
                                          text(context,
                                              "คงเหลือ ณ ปัจจุบัน ${drug.total_useable ?? '-'} ชิ้น",
                                              color: Colors.blue),
                                          const SizedBox(height: 4),
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
                                          "วิธีให้ ครั้งละ : ${drug.dose_qty_name ?? '-'} ${drug.unit_name ?? '-'}",
                                          color:
                                              Color.fromARGB(255, 196, 133, 50),
                                        ),
                                        InkWell(
                                          onTap: () => _showScheduleDetail(
                                            context,
                                            scheduleLabel,
                                            setSlotText,
                                          ),
                                          child: text(
                                            context,
                                            "คลิกดูรายละเอียดการกำหนดเวลา",
                                            color: const Color.fromARGB(
                                                255, 196, 133, 50),
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                const Color.fromARGB(
                                                    255, 196, 133, 50),
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                          ),
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
                                          "หมายเหตุ : ${drug.remark ?? '-'}",
                                          color:
                                              Color.fromARGB(255, 231, 91, 208),
                                        ),
                                        const SizedBox(height: 4),
                                        InkWell(
                                          onTap: () => _showScheduleDetail(
                                            context,
                                            scheduleLabel,
                                            setSlotText,
                                          ),
                                          child: text(
                                            context,
                                            "คลิกดูรายละเอียดการกำหนดเวลา",
                                            color: Color.fromARGB(
                                                255, 231, 91, 208),
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                const Color.fromARGB(
                                                    255, 231, 91, 208),
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                          ),
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
                                                      _infoText(
                                                          '🕒 เวลา:',
                                                          tran?.slot ??
                                                              slotTime),
                                                      _infoText(
                                                          '📌 เวลาที่บันทึก:',
                                                          tran?.create_date ??
                                                              '-'),
                                                      _infoText(
                                                          '👩‍⚕️ ผู้บันทึก:',
                                                          tran?.save_by_name ??
                                                              '-'),
                                                      _infoText(
                                                          '📋 สถานะ:',
                                                          getStatusText(
                                                              tran?.status,
                                                              type)),
                                                      if (tran?.comment !=
                                                              null &&
                                                          tran!.comment!
                                                              .isNotEmpty)
                                                        _infoText(
                                                            '💬 หมายเหตุ:',
                                                            tran.comment ?? ''),
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
                                                      _infoText(
                                                          '🕒 เวลา:',
                                                          tran?.slot ??
                                                              slotTime),
                                                      _infoText(
                                                          '📌 เวลาที่บันทึก:',
                                                          tran?.create_date ??
                                                              '-'),
                                                      _infoText(
                                                          '👩‍⚕️ ผู้บันทึก:',
                                                          tran?.save_by_name ??
                                                              '-'),
                                                      _infoText(
                                                          '📋 สถานะ:',
                                                          getStatusText(
                                                              tran?.status,
                                                              type)),
                                                      if (tran?.comment !=
                                                              null &&
                                                          tran!.comment!
                                                              .isNotEmpty)
                                                        _infoText(
                                                            '💬 หมายเหตุ:',
                                                            tran.comment ?? ''),
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
    BuildContext context,
    String type,
    ListRoundwardModel detail,
    int index,
  ) {
    switch (type) {
      case 'Drug':
        showDrug(context, detail);
        break;
      case 'Food':
        showFood(context, detail);
        break;
      case 'Observe':
        showObserve(context, detail, index);
        break;
      default:
        showDefault(context, detail);
    }
  }

  void showDrug(BuildContext context, ListRoundwardModel drug) {
    String status = (drug.use_now ?? '0');

    final startDt = _parseStartDateUse(drug.start_date_use) ??
        _parseOrderDate(drug.order_date) ??
        DateTime.now();

    final ListDataCardModel drug_ = ListDataCardModel(
      item_name: drug.item_name,
      dose_qty: drug.dose_qty,
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
      start_date_imed: drug.start_date_imed,
      set_slot: drug.set_slot,
      type_slot: drug.type_slot,
      use_now: status,
      start_date_use: drug.start_date_use ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDt),
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

  void showObserve(
    BuildContext context,
    ListRoundwardModel observe,
    int index,
  ) {
    final startDt = _parseStartDateUse(observe.start_date_use) ??
        _parseOrderDate(observe.order_date) ??
        DateTime.now();
    final bool isPRN = (observe.time_slot ?? "เมื่อมีอาการ") == "เมื่อมีอาการ";

    final tempSetValue = jsonEncode({
      "detail": (observe.item_name ?? '').trim(),
      "level": null,
      "obs": 1,
      "col": 0,
      "time_slot": observe.time_slot ?? "เมื่อมีอาการ",
      "delete": 0,
      "type_slot": observe.type_slot,
      "set_slot": observe.set_slot,
    });

    final GetObsModel obsDetail = GetObsModel(
      set_name: widget.selectedGroup?.type_name ??
          observe.drug_type_name ??
          'Observe',
      set_value: tempSetValue,
      remark: observe.remark ?? '',
      take_time: observe.take_time,
      time_slot: observe.time_slot,
      type_slot: isPRN ? 'ALL' : observe.type_slot,
      start_date_use: observe.start_date_use ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDt),
      set_slot: observe.set_slot,
    );

    Future.delayed(Duration.zero, () async {
      EditObsDialogV2.showObs(
        context,
        obsDetail,
        index,
        (updatedObs, i) {},
        widget.headers,
        screen: 'roundward',
        lUserLogin: widget.lUserLogin,
        lPetAdmit: [widget.petAdmit!],
        lListAn: [widget.selectedAn!],
        drugTypeName: widget.selectedGroup?.type_name ?? '',
        mData: observe,
        group: widget.selectedGroup,
        onLocalUpdate: (updatedItem) {
          setState(() {
            if (index >= 0 && index < lDataRoundward.length) {
              lDataRoundward[index] = updatedItem;
            }
          });
        },
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
    final startDt = _parseStartDateUse(food.start_date_use) ??
        _parseOrderDate(food.order_date) ??
        DateTime.now();

    final ListDataCardModel food_ = ListDataCardModel(
      item_name: food.item_name,
      dose_qty: food.dose_qty,
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
      type_slot: food.type_slot,
      set_slot: food.set_slot,
      start_date_use: food.start_date_use ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDt),
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

String formatSetSlot(dynamic setSlot) {
  if (setSlot == null) return '-';

  if (setSlot is List) {
    final items = setSlot
        .map((e) => e.toString().replaceAll("'", "").replaceAll('"', '').trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return items.isEmpty ? '-' : items.join(', ');
  }
  final raw = setSlot.toString();
  final cleaned = raw
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll("'", '')
      .replaceAll('"', '');

  final parts = cleaned
      .split(RegExp(r'[;,]'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  return parts.isEmpty ? '-' : parts.join(', ');
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
