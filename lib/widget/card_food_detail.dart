import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../Model/doctor_model.dart';
import '../api/admit_api.dart';
import '../util/tlconstant.dart';

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

  bool get isHideBtn {
    return widget.lDataCard
        .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);
  }

  bool isConfirmed = false;

  void setConfirmed() {
    setState(() {
      isConfirmed = true;
    });
  }

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
           
            if (!isConfirmed &&
                (widget.lDataCard.isEmpty ||
                    widget.lDataCard.any((e) => e.id == null)))
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
