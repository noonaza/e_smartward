import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class FoodListWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  final Map<String, String> headers;
  final Function(ListDataCardModel food) onEdit;
  final void Function(int index) onDelete;
  final VoidCallback onAdd;
  final List<ListDataObsDetailModel> lSettingTime;

  const FoodListWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.headers,
    required this.lDataCard,
    required this.lSettingTime,
  });

  @override
  _FoodListWidgetState createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget> {
  List<String> parseTakeTime(String raw) {
    final cleaned = raw.replaceAll(RegExp(r"[\[\]']"), '');
    return cleaned.split(',').map((e) => e.trim()).toList();
  }

  final tooltipController = JustTheController();

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
                                              "วิธีให้ :  ${widget.lDataCard[index].dose_qty} ${widget.lDataCard[index].unit_name ?? "-"}",
                                              color: const Color.fromARGB(
                                                  255, 185, 120, 15)),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: food.take_time !=
                                                          null &&
                                                      food.take_time!.isNotEmpty
                                                  ? food.take_time!
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
                                                        text(context,
                                                            "แพทย์ที่ทำการสั่ง: ${food.doctor_eid ?? "-"}",
                                                            color: Colors.teal),
                                                        text(context,
                                                            "หมายเหตุอื่นๆ: ${food.remark ?? "-"}",
                                                            color: Colors.teal),
                                                      ],
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      tooltipController
                                                          .showTooltip(); // แสดง tooltip เมื่อแตะ
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/vf1.png',
                                                      width: 23,
                                                    ),
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
            if (widget.lDataCard.any((e) => e.id == null))
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
