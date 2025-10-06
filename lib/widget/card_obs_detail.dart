import 'dart:convert';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

class ObsListWidget extends StatefulWidget {
  final List<ListDataObsDetailModel> lSettingTime;
  final List<ListDataObsDetailModel> lDataObs;
  final Map<String, String> headers;
  final Function(ListDataObsDetailModel obs) onEdit;
  final Function(int index) onDelete;
  final VoidCallback onAdd;
  final VoidCallback onCopy;

  const ObsListWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.onCopy,
    required this.lDataObs,
    required this.headers,
    required this.lSettingTime,
  });

  @override
  _ObsListWidgetState createState() => _ObsListWidgetState();
}

class _ObsListWidgetState extends State<ObsListWidget> {
  bool get isHideBtn {
    return widget.lDataObs
        .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);
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
                color: Color(0xFFFFE9E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: widget.lDataObs.isEmpty
                  ? Center(child: text(context, 'No data'))
                  : ListView.builder(
                      itemCount: widget.lDataObs.length,
                      itemBuilder: (context, index) {
                        final obs = widget.lDataObs[index];
                        final isDisabled = widget.lDataObs[index].id != null;

                        final cleanedJson = obs.set_value!.replaceAllMapped(
                            RegExp(r'(\w+):'), (match) => '"${match[1]}":');
                        final Map<String, dynamic> setValue =
                            jsonDecode(cleanedJson);

                        List<String> _parseToList(dynamic v) {
                          if (v == null) return [];
                          if (v is List) {
                            return v
                                .map((e) => e.toString().trim())
                                .where((e) => e.isNotEmpty)
                                .toList();
                          }
                          if (v is String) {
                            final s = v.trim();
                            // ลอง decode เป็น JSON array ก่อน
                            try {
                              final decoded = jsonDecode(s);
                              if (decoded is List) {
                                return decoded
                                    .map((e) => e.toString().trim())
                                    .where((e) => e.isNotEmpty)
                                    .toList();
                              }
                            } catch (_) {/* ไม่ใช่ JSON ก็ไปทาง split */}
                            // fallback: ตัด bracket/quote แล้ว split ด้วยคอมมา
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

                        final colVal = setValue['col']?.toString();

                        final List<String> levels =
                            _parseToList(setValue['level']);

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
                                          // text(context, "${obs.set_name}",
                                          //     fontWeight: FontWeight.bold,
                                          //     color: Color.fromARGB(
                                          //         255, 212, 97, 95)),
                                          const SizedBox(height: 4),
                                          text(context,
                                              "คำสั่งพิเศษ : ${obs.set_name}",
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          const SizedBox(height: 4),
                                          text(context,
                                              "หมายเหตุ : ${obs.remark ?? '-'}",
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          const SizedBox(height: 4),
                                          // if (levels.isNotEmpty) ...[
                                          //   const SizedBox(height: 6),
                                          //   Wrap(
                                          //     spacing: 10,
                                          //     runSpacing: 10,
                                          //     children: levels.map((lv) {
                                          //       return Container(
                                          //         padding: const EdgeInsets
                                          //             .symmetric(
                                          //             horizontal: 18,
                                          //             vertical: 8),
                                          //         decoration: BoxDecoration(
                                          //           color:
                                          //               Colors.white, // พื้นขาว
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   24), // เม็ดแคปซูล
                                          //           border: Border.all(
                                          //               color:
                                          //                   Colors.red.shade400,
                                          //               width: 1.6), // ขอบแดง
                                          //         ),
                                          //         child: Text(
                                          //           lv,
                                          //           style: TextStyle(
                                          //             fontWeight:
                                          //                 FontWeight.w700,
                                          //             color: Colors.pink
                                          //                 .shade400, // ตัวอักษรชมพู
                                          //           ),
                                          //         ),
                                          //       );
                                          //     }).toList(),
                                          //   ),
                                          // ],
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
                                          // if (displayItems.isNotEmpty) ...[
                                          //   Wrap(
                                          //     spacing: 8,
                                          //     runSpacing: 8,
                                          //     children: displayItems.map((col) {
                                          //       return Container(
                                          //         padding: const EdgeInsets
                                          //             .symmetric(
                                          //             horizontal: 15,
                                          //             vertical: 5),
                                          //         decoration: BoxDecoration(
                                          //           color: const Color.fromARGB(
                                          //               255, 202, 64, 61),
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   20),
                                          //           border: Border.all(
                                          //             color:
                                          //                 const Color.fromARGB(
                                          //                     255,
                                          //                     215,
                                          //                     116,
                                          //                     114),
                                          //             width: 2,
                                          //           ),
                                          //         ),
                                          //         child: text(
                                          //           context,
                                          //           col, // << โชว์ค่า col เท่านั้น
                                          //           color: Colors.white,
                                          //         ),
                                          //       );
                                          //     }).toList(),
                                          //   ),
                                          // ],
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
                  onPressed: widget.onAdd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
