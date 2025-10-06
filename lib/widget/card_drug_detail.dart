import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../Model/doctor_model.dart';
import '../api/admit_api.dart';

class DrugListWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  final Map<String, String> headers;
  final Function(ListDataCardModel drug) onEdit;
  final void Function(int index) onDelete;
  final VoidCallback onAdd;
  final List<ListDataObsDetailModel> lSettingTime;
  final VoidCallback onConfirmed;

  const DrugListWidget({
    super.key,
    required this.lDataCard,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.headers,
    required this.lSettingTime,
    required this.onConfirmed,
  });
  @override
  State<DrugListWidget> createState() => DrugListWidgetState();
}

class DrugListWidgetState extends State<DrugListWidget> {
  List<String> parseTakeTime(String raw) {
    final cleaned = raw.replaceAll(RegExp(r"[\[\]']"), '');
    return cleaned.split(',').map((e) => e.trim()).toList();
  }

  List<DoctorModel> ListDoctors = [];

  // bool get isHideBtn {
  //   return widget.lDataCard
  //       .every((e) => e.id != null && e.id.toString().trim().isNotEmpty);
  // }

  final tooltipController = JustTheController();

  bool isConfirmed = false;

  void setConfirmed() {
    setState(() {
      isConfirmed = true;
    });
  }

  bool get _hasAnyId => widget.lDataCard
      .any((e) => e.id != null && e.id.toString().trim().isNotEmpty);

  bool get _hideAddButton => isConfirmed || _hasAnyId;

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
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3.1,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFBDE0F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: widget.lDataCard.isEmpty
                    ? Center(
                        child: SizedBox(
                        child: text(context, 'No Data'),
                      ))
                    : ListView.builder(
                        itemCount: widget.lDataCard.length,
                        itemBuilder: (context, index) {
                          final drug = widget.lDataCard[index];
                          final isDisabled = widget.lDataCard[index].id != null;
                          final tooltipController = JustTheController();

                          return GestureDetector(
                            onTap:
                                isDisabled ? null : () => widget.onEdit(drug),
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
                                          255, 217, 244, 251),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            text(context,
                                                "ชื่อยา : ${widget.lDataCard[index].item_name}",
                                                color: Colors.blue),
                                            const SizedBox(height: 4),
                                            text(
                                              context,
                                              "วิธีให้ : ${widget.lDataCard[index].id == null ? widget.lDataCard[index].dose_qty ?? '-' : widget.lDataCard[index].dose_qty_name ?? '-'} ${widget.lDataCard[index].unit_name ?? '-'}",
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(height: 4),
                                            drug.time_slot?.toString().contains(
                                                        "เมื่อมีอาการ") ==
                                                    true
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      text(context,
                                                          'ให้เฉพาะเวลา : ${drug.time_slot}',
                                                          color: Colors.blue),
                                                      const SizedBox(height: 4),
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children:
                                                  drug.meal_timing != null &&
                                                          drug.meal_timing!
                                                              .isNotEmpty
                                                      ? drug.meal_timing!
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', '')
                                                          .replaceAll("'", '')
                                                          .split(',')
                                                          .map(
                                                              (time) => Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            20,
                                                                            95,
                                                                            156),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      child:
                                                                          text(
                                                                        context,
                                                                        color: Colors
                                                                            .white,
                                                                        time.trim(),
                                                                      ),
                                                                    ),
                                                                  ))
                                                          .toList()
                                                      : [SizedBox()],
                                            ),
                                            const SizedBox(height: 4),
                                            drug.take_time != null &&
                                                    drug.take_time!
                                                        .isNotEmpty &&
                                                    !(drug.time_slot?.contains(
                                                            "เมื่อมีอาการ") ??
                                                        false)
                                                ? SizedBox(
                                                    width: double.infinity,
                                                    child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      children: drug.take_time!
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', '')
                                                          .replaceAll("'", '')
                                                          .split(',')
                                                          .map(
                                                              (time) => Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      child:
                                                                          text(
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
                                            text(
                                              context,
                                              "วันที่สั่งยา : ${widget.lDataCard[index].order_date}",
                                              color: Colors.blue,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  JustTheTooltip(
                                                    controller:
                                                        tooltipController,
                                                    preferredDirection:
                                                        AxisDirection.up,
                                                    tailLength: 10,
                                                    tailBaseWidth: 20,
                                                    backgroundColor:
                                                        Colors.blue[100],
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
                                                          text(
                                                            context,
                                                            "ชื่อยา: ${drug.item_name}",
                                                            color: Colors.teal,
                                                          ),
                                                          text(
                                                            context,
                                                            "สรรพคุณ: ${drug.drug_description ?? "-"}",
                                                            color: Colors.teal,
                                                          ),
                                                          text(
                                                            context,
                                                            "แพทย์ที่ทำการสั่งยา: ${Func.fullName(ListDoctors: ListDoctors, empId: drug.doctor_eid)}",
                                                            color: Colors.teal,
                                                          ),
                                                          text(
                                                            context,
                                                            "หมายเหตุอื่นๆ: ${drug.remark ?? "-"}",
                                                            color: Colors.teal,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        tooltipController
                                                            .showTooltip();
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/vd1.png',
                                                        width: 23,
                                                      ),
                                                    ),
                                                  ),
                                                  if ((drug.doctor_eid == null ||
                                                          drug.doctor_eid!
                                                              .isEmpty) ||
                                                      (drug.unit_name == null ||
                                                          drug.unit_name!
                                                              .isEmpty) ||
                                                      ((drug.dose_qty == null ||
                                                              drug.dose_qty
                                                                  .toString()
                                                                  .isEmpty) &&
                                                          (drug.dose_qty_name == null ||
                                                              drug.dose_qty_name!
                                                                  .isEmpty)) ||
                                                      (drug.item_name == null ||
                                                          drug.item_name!
                                                              .isEmpty) ||
                                                      ((drug.take_time == null ||
                                                              drug.take_time!
                                                                  .isEmpty) &&
                                                          !(drug.time_slot
                                                                  ?.toString()
                                                                  .contains("เมื่อมีอาการ") ??
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
                                        child: widget.lDataCard[index].id !=
                                                null
                                            ? null
                                            : IconButton(
                                                icon: const Icon(Icons.cancel,
                                                    size: 20,
                                                    color: Color.fromARGB(
                                                        255, 33, 150, 243)),
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
                        size: 35, color: Colors.blue),
                    onPressed: widget.onAdd,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
