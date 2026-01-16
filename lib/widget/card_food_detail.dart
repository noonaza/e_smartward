import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../Model/doctor_model.dart';
import '../api/admit_api.dart';

class FoodListWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  final Map<String, String> headers;
  final Function(ListDataCardModel food) onEdit;
  final void Function(int index) onDelete;
  final VoidCallback onAdd;
  final List<ListDataObsDetailModel> lSettingTime;
  final VoidCallback onConfirmed;

  const FoodListWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.headers,
    required this.lDataCard,
    required this.lSettingTime,
    required this.onConfirmed,
  });

  @override
  FoodListWidgetState createState() => FoodListWidgetState();
}

class FoodListWidgetState extends State<FoodListWidget> {
  List<String> parseTakeTime(String raw) {
    final cleaned = raw.replaceAll(RegExp(r"[\[\]']"), '');
    return cleaned.split(',').map((e) => e.trim()).toList();
  }

  List<DoctorModel> ListDoctors = [];

  // bool get isHideBtn {
  //   return widget.lDataCard
  //       .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);
  // }

  bool isConfirmed = false;

  void setConfirmed() {
    setState(() {
      isConfirmed = true;
    });
  }

  String labelFromTypeSlot(String? t) {
    switch (t) {
      case 'weekly_once':
        return 'กำหนดรายสัปดาห์';
      case 'daily_custom':
        return 'กำหนดรายวัน';
      case 'monthly_custom':
        return 'กำหนดรายเดือน';
      case 'all':
      default:
        return 'ไม่กำหนด';
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
      case 'all':
      default:
        return 'ไม่กำหนด';
    }
  }

  bool get _hasAnyId => widget.lDataCard
      .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);

  bool get _hideAddButton => isConfirmed || _hasAnyId;

  final tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 40), () async {
      ListDoctors =
          await AdmitApi().loadDataDoctor(context, headers_: widget.headers);
    });
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
                color: Color.fromARGB(255, 250, 247, 232),
                borderRadius: BorderRadius.circular(20),
              ),
              child: widget.lDataCard.isEmpty
                  ? Center(
                      child: SizedBox(
                      child: text(context, 'No data'),
                    ))
                  : ListView.builder(
                      itemCount: widget.lDataCard.length,
                      itemBuilder: (context, index) {
                        final food = widget.lDataCard[index];
                        final isDisabled = widget.lDataCard[index].id != null;
                        final tooltipController = JustTheController();

                        // ignore: unnecessary_type_check
                        final String typeSlot = (food is ListDataCardModel)
                            ? (food.type_slot ?? 'ALL')
                            : ((food).type_slot ?? 'ALL');
                        final scheduleLabel =
                            (food.schedule_mode_label != null &&
                                    food.schedule_mode_label!.trim().isNotEmpty)
                                ? food.schedule_mode_label!
                                : _labelFromTypeSlotStd(typeSlot);

                        return GestureDetector(
                          onTap: isDisabled ? null : () => widget.onEdit(food),
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
                                        255, 236, 222, 164),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(context,
                                              "ชื่ออาหาร : ${widget.lDataCard[index].item_name}",
                                              color: const Color.fromARGB(
                                                  255, 185, 120, 15)),
                                          const SizedBox(height: 4),
                                          text(context,
                                              "วิธีให้ : ${widget.lDataCard[index].id == null ? widget.lDataCard[index].dose_qty ?? '-' : widget.lDataCard[index].dose_qty_name ?? '-'} ${widget.lDataCard[index].unit_name ?? '-'}",
                                              color: const Color.fromARGB(
                                                  255, 185, 120, 15)),
                                          const SizedBox(height: 4),
                                          text(context,
                                              "วิธีเตรียม :  ${widget.lDataCard[index].meal_take ?? '-'}",
                                              color: const Color.fromARGB(
                                                  255, 185, 120, 15)),
                                          const SizedBox(height: 4),
                                          text(
                                            context,
                                            "กำหนด : $scheduleLabel",
                                            color: Color.fromARGB(
                                                255, 185, 120, 15),
                                          ),
                                          const SizedBox(height: 4),
                                          food.set_slot != null &&
                                                  food.set_slot!.isNotEmpty &&
                                                  food.set_slot!
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', '')
                                                      .replaceAll("'", '')
                                                      .split(',')
                                                      .any((e) =>
                                                          e.trim().isNotEmpty)
                                              ? SizedBox(
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: food.set_slot!
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceAll("'", '')
                                                        .split(',')
                                                        .where((day) => day
                                                            .trim()
                                                            .isNotEmpty)
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
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    185,
                                                                    120,
                                                                    15),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: text(
                                                                context,
                                                                color: Colors
                                                                    .white,
                                                                day.trim(),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(height: 4),
                                          food.time_slot?.toString().contains(
                                                      "เมื่อมีอาการ") ==
                                                  true
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    text(
                                                      context,
                                                      'ให้เฉพาะเวลา : ${food.time_slot}',
                                                      color: Color.fromARGB(
                                                          255, 185, 120, 15),
                                                    ),
                                                    const SizedBox(height: 4),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(height: 4),
                                          food.take_time != null &&
                                                  food.take_time!.isNotEmpty &&
                                                  !(food.time_slot?.contains(
                                                          "เมื่อมีอาการ") ??
                                                      false)
                                              ? SizedBox(
                                                  width: double.infinity,
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: food.take_time!
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
                                                                      185,
                                                                      120,
                                                                      15),
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
                                          const SizedBox(height: 4),
                                          food.use_now != null &&
                                                  food.use_now!.isNotEmpty &&
                                                  !(food.use_now?.contains(
                                                          "ให้อาหารทันที") ??
                                                      false)
                                              ? SizedBox(
                                                  width: double.infinity,
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    children: food.use_now!
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceAll("'", '')
                                                        .split(',')
                                                        .where((time) =>
                                                            time.trim() !=
                                                                '0' &&
                                                            time
                                                                .trim()
                                                                .isNotEmpty)
                                                        .map((time) {
                                                      final displayText =
                                                          time.trim() == '1'
                                                              ? 'ให้อาหารทันที'
                                                              : time.trim();
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 0),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                185, 120, 15),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: text(
                                                            context,
                                                            color: Colors.white,
                                                            displayText,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(height: 4),
                                          text(
                                            context,
                                            "วันที่สั่งอาหาร : ${((widget.lDataCard[index].order_date == null || widget.lDataCard[index].order_date!.isEmpty) ? widget.lDataCard[index].start_date_imed : widget.lDataCard[index].order_date)}",
                                            color: Color.fromARGB(
                                                255, 185, 120, 15),
                                          ),
                                          const SizedBox(height: 4),
                                          text(
                                            context,
                                            "วันที่เริ่มให้อาหาร: ${((widget.lDataCard[index].start_date_use == null || widget.lDataCard[index].start_date_use!.isEmpty) ? widget.lDataCard[index].start_date_use : widget.lDataCard[index].start_date_use)}",
                                            color: Color.fromARGB(
                                                255, 185, 120, 15),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                JustTheTooltip(
                                                  controller: tooltipController,
                                                  preferredDirection:
                                                      AxisDirection.up,
                                                  tailLength: 10,
                                                  tailBaseWidth: 10,
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 238, 227, 182),
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        text(context,
                                                            "ชื่ออาหาร: ${food.item_name}",
                                                            color: Colors.teal),
                                                        text(context,
                                                            "สรรพคุณ: ${food.drug_instruction ?? "-"}",
                                                            color: Colors.teal),
                                                        // text(context,
                                                        //     "แพทย์ที่ทำการสั่ง: ${Func.fullName(ListDoctors: ListDoctors, empId: food.doctor_eid)}",
                                                        // color: Colors.teal),
                                                        text(context,
                                                            "หมายเหตุอื่นๆ: ${food.remark ?? "-"}",
                                                            color: Colors.teal),
                                                      ],
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      tooltipController
                                                          .showTooltip();
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/vf1.png',
                                                      width: 23,
                                                    ),
                                                  ),
                                                ),
                                                if (
                                                    // (food.doctor_eid == null ||
                                                    //       food.doctor_eid!
                                                    //           .isEmpty) ||
                                                    (food.unit_name == null ||
                                                            food.unit_name!
                                                                .isEmpty) ||
                                                        ((food.dose_qty == null ||
                                                                food.dose_qty
                                                                    .toString()
                                                                    .isEmpty) &&
                                                            (food.dose_qty_name ==
                                                                    null ||
                                                                food.dose_qty_name!
                                                                    .isEmpty)) ||
                                                        (food.item_name == null ||
                                                            food.item_name!
                                                                .isEmpty) ||
                                                        ((food.take_time == null ||
                                                                food.take_time!
                                                                    .isEmpty) &&
                                                            !(food.time_slot
                                                                    ?.toString()
                                                                    .contains(
                                                                        "เมื่อมีอาการ") ??
                                                                false)))
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 6.0),
                                                    child: Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      color: Colors.orange,
                                                      size: 25,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8.0,
                                  top: 10.0,
                                  child: SizedBox(
                                    child: widget.lDataCard[index].id != null
                                        ? null
                                        : IconButton(
                                            icon: const Icon(Icons.cancel,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 185, 120, 15)),
                                            onPressed: () =>
                                                widget.onDelete(index),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (!_hideAddButton)
              Positioned(
                right: 8.0,
                bottom: 8.0,
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outlined,
                      size: 35, color: Color.fromARGB(255, 184, 119, 15)),
                  onPressed: widget.onAdd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
