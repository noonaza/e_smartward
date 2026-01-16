import 'dart:convert';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/dialog/obs_all_dialog.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

class ObsListWidget extends StatefulWidget {
  final List<ListDataObsDetailModel> lSettingTime;
  final List<GetObsModel> lDataObs;
  final Map<String, String> headers;
  final Function(GetObsModel obs) onEdit;
  final Function(int index) onDelete;
  final VoidCallback onAdd;
  final VoidCallback onCopy;

  const ObsListWidget(
      {super.key,
      required this.onEdit,
      required this.onDelete,
      required this.onAdd,
      required this.onCopy,
      required this.lDataObs,
      required this.headers,
      required this.lSettingTime});

  @override
  _ObsListWidgetState createState() => _ObsListWidgetState();
}

class _ObsListWidgetState extends State<ObsListWidget> {
  bool get isHideBtn {
    return widget.lDataObs
        .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);
  }

  Map<String, dynamic> _safeDecodeSetValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return {};
    try {
      final v = jsonDecode(raw);
      if (v is Map<String, dynamic>) return v;
      if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v));
    } catch (_) {}
    return {};
  }

  /// แปลง set_slot ให้เป็น List<String> รองรับทั้ง
  /// ["Tue","Wed"] และ ['Tue','Wed'] และ list จริง
  List<String> normalizeSetSlot(dynamic raw) {
    if (raw == null) return [];

    if (raw is List) {
      return raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    var s = raw.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return [];

    // ให้ jsonDecode อ่านได้
    s = s.replaceAll("'", '"');

    try {
      final decoded = jsonDecode(s);
      if (decoded is List) {
        return decoded
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (_) {
      // ถ้า decode ไม่ได้ ใช้ split ธรรมดา
    }

    return s
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .split(RegExp(r'\s*,\s*'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// normalize type_slot ให้เป็นค่า std: DAYS / DATE / D_M / ALL
  String _normalizeTypeSlot(String? raw) {
    final s = (raw ?? '').trim().toUpperCase();

    switch (s) {
      case 'WEEKLY_ONCE':
      case 'DAYS':
        return 'DAYS';
      case 'DAILY_CUSTOM':
      case 'DATE':
        return 'DATE';
      case 'MONTHLY_CUSTOM':
      case 'D_M':
        return 'D_M';
      case 'ALL':
      default:
        return 'ALL';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3.1,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: widget.lDataObs.isEmpty
                  ? Center(child: text(context, 'No data'))
                  : ListView.builder(
                      itemCount: widget.lDataObs.length,
                      itemBuilder: (context, index) {
                        final obs = widget.lDataObs[index];
                        final isDisabled = widget.lDataObs[index].id != null;

                        final Map<String, dynamic> setValue =
                            _safeDecodeSetValue(obs.set_value);

                        List<String> parseToList(dynamic v) {
                          if (v == null) return [];
                          if (v is List) {
                            return v
                                .map((e) => e.toString().trim())
                                .where((e) => e.isNotEmpty)
                                .toList();
                          }
                          if (v is String) {
                            final s = v.trim();
                            try {
                              final decoded = jsonDecode(s);
                              if (decoded is List) {
                                return decoded
                                    .map((e) => e.toString().trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList();
                              }
                            } catch (_) {}
                            return s
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .replaceAll("'", '')
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();
                          }
                          return [];
                        }

                        final List<String> levels =
                            parseToList(setValue['level']);
                        final List<String> cols = parseToList(setValue['col']);

                        final List<String> displayItems = [];
                        if (setValue['detail']?.toString() != '0') {
                          displayItems.add('detail');
                        }
                        if (setValue['level']?.toString() != '0') {
                          displayItems.add('level');
                        }
                        if (setValue['col']?.toString() != '0') {
                          displayItems.add('col');
                        }
                        final detail = setValue['detail']?.toString() ?? '-';

                        String displayObsName(dynamic obs) {
                          if (obs is ListDataCardModel) {
                            final code = (obs.item_code ?? '').trim();
                            if (code.isNotEmpty) return code;

                            final name = (obs.item_name ?? '').trim();
                            if (name.isNotEmpty) return name;

                            try {
                              final m =
                                  jsonDecode(obs.drug_instruction ?? '{}');
                              final detail =
                                  (m['detail'] ?? '').toString().trim();
                              if (detail.isNotEmpty) return detail;
                            } catch (_) {}
                            return 'กำหนดเอง';
                          }

                          if (obs is GetObsModel) {
                            final group = ((obs.item_code ??
                                        obs.set_name ??
                                        obs.set_name) ??
                                    '')
                                .toString()
                                .trim();
                            if (group.isNotEmpty) return group;

                            final name = (obs.set_name ?? '').trim();
                            if (name.isNotEmpty) return name;

                            try {
                              final m = jsonDecode(obs.set_value ?? '{}');
                              final detail =
                                  (m['detail'] ?? '').toString().trim();
                              if (detail.isNotEmpty) return detail;
                            } catch (_) {}
                            return 'กำหนดเอง';
                          }

                          return 'กำหนดเอง';
                        }

                        final String rawTypeSlot =
                            (obs.type_slot ?? '').toString().trim();
                        final String normTypeSlot =
                            _normalizeTypeSlot(rawTypeSlot);
                        final days = normalizeSetSlot(obs.set_slot);

                        final String scheduleLabel = (obs.schedule_mode_label !=
                                    null &&
                                obs.schedule_mode_label!.trim().isNotEmpty &&
                                obs.schedule_mode_label != 'ไม่กำหนด')
                            ? obs.schedule_mode_label!
                            : _labelFromTypeSlotStd(normTypeSlot);

                        // ------------------------------------------------

                        return GestureDetector(
                          onTap: isDisabled ? null : () => widget.onEdit(obs),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 1),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: const Color.fromARGB(
                                        255, 255, 208, 192),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(
                                            context,
                                            displayObsName(obs),
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 212, 97, 95),
                                          ),
                                          const SizedBox(height: 4),
                                          text(context, "คำสั่งพิเศษ : $detail",
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          const SizedBox(height: 4),
                                          text(context,
                                              "หมายเหตุ : ${obs.remark ?? '-'}",
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          const SizedBox(height: 4),
                                          const SizedBox(height: 4),
                                          text(
                                            context,
                                            "กำหนด : $scheduleLabel",
                                            color: const Color.fromARGB(
                                                255, 215, 116, 114),
                                          ),
                                          const SizedBox(height: 4),
                                          days.isNotEmpty
                                              ? SizedBox(
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: days
                                                        .map(
                                                          (day) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 0),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        175,
                                                                        94,
                                                                        93),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: text(
                                                                context,
                                                                day,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          if (levels.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: levels.map((lv) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 18,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24), // เม็ดแคปซูล
                                                    border: Border.all(
                                                        color:
                                                            Colors.red.shade400,
                                                        width: 1.6),
                                                  ),
                                                  child: Text(
                                                    lv,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          Colors.pink.shade400,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                          const SizedBox(height: 4),
                                          obs.time_slot?.toString().contains(
                                                      "เมื่อมีอาการ") ==
                                                  true
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    text(
                                                      context,
                                                      'ให้เฉพาะเวลา : ${obs.time_slot}',
                                                      color: Color.fromARGB(
                                                          255, 185, 120, 15),
                                                    ),
                                                    const SizedBox(height: 4),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          if (cols.isNotEmpty) ...[
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: cols.map((col) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 202, 64, 61),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              215,
                                                              116,
                                                              114),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: text(
                                                    context,
                                                    col,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                          const SizedBox(height: 4),
                                          obs.take_time != null &&
                                                  obs.take_time!
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', '')
                                                      .replaceAll("'", '')
                                                      .split(',')
                                                      .where((e) =>
                                                          e.trim().isNotEmpty)
                                                      .isNotEmpty &&
                                                  !(obs.time_slot?.contains(
                                                          "เมื่อมีอาการ") ??
                                                      false)
                                              ? SizedBox(
                                                  width: double.infinity,
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: obs.take_time!
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceAll("'", '')
                                                        .split(',')
                                                        .map((time) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 0),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        6),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      215,
                                                                      116,
                                                                      114),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: text(
                                                                  context,
                                                                  color: Colors
                                                                      .white,
                                                                  time.trim(),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isHideBtn)
                                  Positioned(
                                    right: 8.0,
                                    top: 10.0,
                                    child: IconButton(
                                      icon: const Icon(Icons.cancel,
                                          size: 20,
                                          color: Color.fromARGB(
                                              255, 215, 116, 114)),
                                      onPressed: () => widget.onDelete(index),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (!isHideBtn)
              Positioned(
                right: 8.0,
                bottom: 8.0,
                child: IconButton(
                    icon: const Icon(Icons.add_circle_outlined,
                        size: 35, color: Color.fromARGB(255, 215, 116, 114)),
                    onPressed: () async {
                      final pickedList = await showDialog<List<GetObsModel>>(
                        context: context,
                        builder: (context) => ObsAllDialogV2(
                          headers: widget.headers,
                        ),
                      );

                      if (pickedList != null && pickedList.isNotEmpty) {
                        setState(() {
                          for (final newObs in pickedList) {
                            final sv = _safeDecodeSetValue(newObs.set_value);
                            final newDetail = (sv['detail'] ?? '').toString();
                            final exists = widget.lDataObs.any((e) {
                              final esv = _safeDecodeSetValue(e.set_value);
                              final eDetail = (esv['detail'] ?? '').toString();
                              return (e.set_name ?? '') ==
                                      (newObs.set_name ?? '') &&
                                  eDetail == newDetail;
                            });
                            if (!exists) widget.lDataObs.add(newObs);
                          }
                        });
                      }
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
