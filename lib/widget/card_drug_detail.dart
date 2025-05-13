import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class DrugListWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  final Map<String, String> headers;
  final Function(ListDataCardModel drug) onEdit;
  final void Function(int index) onDelete;
  final VoidCallback onAdd;
  final List<ListDataObsDetailModel> lSettingTime;

  const DrugListWidget({
    super.key,
    required this.lDataCard,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.headers,
    required this.lSettingTime,
  });
  @override
  State<DrugListWidget> createState() => _DrugListWidgetState();
}

class _DrugListWidgetState extends State<DrugListWidget> {
  List<String> parseTakeTime(String raw) {
    final cleaned = raw.replaceAll(RegExp(r"[\[\]']"), '');
    return cleaned.split(',').map((e) => e.trim()).toList();
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

                        print(widget.lDataCard);

                        return GestureDetector(
                          onTap: isDisabled ? null : () => widget.onEdit(drug),
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
                                          text(context,
                                              "วิธีให้ : ${widget.lDataCard[index].dose_qty} ${widget.lDataCard[index].unit_name ?? "-"}",
                                              color: Colors.blue),
                                          const SizedBox(height: 4),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: drug.meal_timing !=
                                                        null &&
                                                    drug.meal_timing!.isNotEmpty
                                                ? drug.meal_timing!
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
                                                                      20,
                                                                      95,
                                                                      156),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: text(
                                                              context,
                                                              color:
                                                                  Colors.white,
                                                              time.trim(),
                                                            ),
                                                          ),
                                                        ))
                                                    .toList()
                                                : [
                                                    text(context,
                                                        'ไม่ระบุเวลาการให้อาหาร')
                                                  ],
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: drug.take_time !=
                                                          null &&
                                                      drug.take_time!.isNotEmpty
                                                  ? drug.take_time!
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.blue,
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
                                                      .toList()
                                                  : [SizedBox()],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                JustTheTooltip(
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
                                                          "สรรพคุณ: ${drug.drug_instruction ?? "-"}",
                                                          color: Colors.teal,
                                                        ),
                                                        text(
                                                          context,
                                                          "แพทย์ที่ทำการสั่งยา: ${drug.doctor_eid ?? "-"}",
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
                                                  child: Image.asset(
                                                    'assets/images/vd1.png',
                                                    width: 23,
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
            if (widget.lDataCard.any((e) => e.id == null))
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
    );
  }
}
