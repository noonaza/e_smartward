// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/dialog/chat_dialog.dart';
import 'package:flutter/material.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/api/manage_food_api.dart';
import 'package:e_smartward/widget/text.dart';
import '../Model/list_food_model.dart';
import '../Model/list_user_model.dart';
import 'show_dialog.dart';
import 'switch_widget.dart';

// ignore: must_be_immutable
class ManageFoodWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  List<ListUserModel> lUserLogin;
  final Map<String, String> headers;
  final String? groupId;
  final String? siteCode;
  final String? wardCode;
  final bool isWardMode;

  ManageFoodWidget({
    super.key,
    required this.lDataCard,
    required this.lUserLogin,
    required this.headers,
    this.groupId,
    this.siteCode,
    this.wardCode,
    required this.isWardMode,
  });

  @override
  _ManageFoodWidgetState createState() => _ManageFoodWidgetState();
}

class _ManageFoodWidgetState extends State<ManageFoodWidget> {
  List<ListFoodModel> lFoodList = [];
  List<String> timeSlots = [];
  String? selectedSlot;
  Set<String> activeSlots = {};
  bool isLoading = false;
  Timer? _debounce;
  List<ListPetModel> lPetAdmit = [];

  final Map<String, List<ListFoodModel>> slotCache = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final slots = await ManageFoodApi().loadFoodSlot(
        context,
        headers_: widget.headers,
        groupId: widget.isWardMode ? null : widget.groupId!,
        siteCode: widget.isWardMode ? widget.siteCode : null,
        wardCode: widget.isWardMode ? widget.wardCode : null,
        type: widget.isWardMode ? 'WARD' : 'GROUP-BED',
      );

      final slotToUse = selectedSlot ?? getTimeSlot(slots);

      if (slotCache.containsKey(slotToUse)) {
        final cachedList = slotCache[slotToUse]!;
        final filteredList =
            cachedList.where((item) => item.stock_out != 1).toList();

        setState(() {
          timeSlots = slots;
          lFoodList = filteredList;
          activeSlots = activeSlot(filteredList);
        });
        return;
      }

      final foodItems = await ManageFoodApi().loadListFoodSlot(
        context,
        headers_: widget.headers,
        slot: slotToUse,
        groupId: widget.groupId ?? '',
        siteCode: widget.siteCode ?? '',
        ward: widget.wardCode ?? '',
        type: widget.isWardMode ? 'WARD' : 'GROUP-BED',
      );

      final listFood = foodItems
          .map((item) => ListFoodModel(
                id: item['id'],
                item_name: item['item_name'],
                smw_admit_id: item['smw_admit_id'],
                item_qty: item['item_qty']?.toString(),
                unit_name: item['unit_name'],
                remark: item['remark'],
                dose_qty: item['dose_qty'],
                stock_out: int.tryParse(item['stock_out']?.toString() ?? '0'),
                time_slot: item['time_slot'],
                hn_number: item['hn_number'],
                an_number: item['an_number'],
                take_time: item['take_time'],
                status: item['status'],
                visit_number: item['visit_number'],
                pre_pare_status: item['pre_pare_status'],
                date_slot: item['date_slot'],
                pet_name: item['pet_name'],
                bed_number: item['bed_number'],
              ))
          .toList();

      final filteredListFood =
          listFood.where((item) => item.stock_out != 1).toList();
      slotCache[slotToUse] = listFood;

      setState(() {
        timeSlots = slots;
        lFoodList = filteredListFood;
        activeSlots = activeSlot(lFoodList);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getTimeSlot(List<String> slots) {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    String? closestSlot;
    int? minDiff;

    for (final slot in slots) {
      final parts = slot.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final slotMinutes = hour * 60 + minute;

      final diff = (slotMinutes - nowMinutes).abs();
      if (minDiff == null || diff < minDiff) {
        minDiff = diff;
        closestSlot = slot;
      }
    }

    return closestSlot ?? '';
  }

  Set<String> activeSlot(List<ListFoodModel> foods) {
    return foods
        .map((e) => e.take_time)
        .where((e) => e != null)
        .expand((e) {
          if (e is String) {
            return [e.trim()];
          } else if (e is List) {
            // ignore: cast_from_null_always_fails
            return (e as List).map((x) => x.toString().trim());
          }
          return [];
        })
        .toSet()
        .cast<String>();
  }

  void onSelectSlot(String slot) {
    if (selectedSlot == slot) return;

    setState(() {
      selectedSlot = slot;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ListFoodModel> listFood = lFoodList;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = timeSlots[index];
                  final isSelected = slot == selectedSlot;
                  final isActive = activeSlots.contains(slot.trim());

                  return GestureDetector(
                    onTap: () {
                      onSelectSlot(slot);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.teal[700]
                            : isActive
                                ? Colors.teal[700]
                                : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Center(
                        child: text(
                          context,
                          slot,
                          color: (isSelected || isActive)
                              ? Colors.white
                              : Colors.teal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: listFood.isEmpty
                  ? Center(child: SizedBox(child: text(context, 'No data')))
                  : ListView.builder(
                      itemCount: listFood.length,
                      itemBuilder: (context, index) {
                        final food = listFood[index];
                        final isDisabled = lFoodList[index].stock_out == 1;

                        return GestureDetector(
                          onTap: isDisabled ? null : () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4, right: 4, top: 1),
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
                                    color: isDisabled
                                        ? Colors.grey[350]
                                        : const Color.fromARGB(
                                            255, 154, 212, 212),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/petname.png',
                                                width: 17,
                                                height: 17,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              text(
                                                context,
                                                "ชื่อสัตว์เลี้ยง : ${food.pet_name}",
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 26, 90, 76),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.note_alt,
                                                    color: Colors.teal,
                                                    size: 28),
                                                onPressed: () {
                                                  final admitId = food
                                                          .visit_number
                                                          ?.toString() ??
                                                      '';
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (_) => ChatDialog(
                                                      headers: widget.headers,
                                                      visitId: admitId,
                                                      lUserLogin:
                                                          widget.lUserLogin,
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: text(
                                                  context,
                                                  "HN : ${food.hn_number}",
                                                  color: const Color.fromARGB(
                                                      255, 26, 90, 76),
                                                ),
                                              ),
                                              text(
                                                context,
                                                "AN : ${food.an_number}",
                                                color: const Color.fromARGB(
                                                    255, 26, 90, 76),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: text(
                                                  context,
                                                  "ชื่ออาหาร : ${food.item_name}",
                                                  color: const Color.fromARGB(
                                                      255, 26, 90, 76),
                                                ),
                                              ),
                                              text(
                                                context,
                                                "เตียง : ${food.bed_number}",
                                                color: const Color.fromARGB(
                                                    255, 26, 90, 76),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          text(
                                            context,
                                            "วิธีเตรียมอาหาร : ${food.remark}",
                                            color: const Color.fromARGB(
                                                255, 26, 90, 76),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: text(
                                                  context,
                                                  "วิธีให้ : ${food.dose_qty ?? 'ไม่ได้ระบุจำนวน /'} ${food.unit_name ?? 'ไม่ได้ระบุหน่วย'}",
                                                  color: const Color.fromARGB(
                                                      255, 26, 90, 76),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor: Colors.teal,
                                                    value: lFoodList[index]
                                                            .stock_out ==
                                                        1, //>> ถ้า stock_out = 1 คือ หมด <<//

                                                    onChanged: lFoodList[index]
                                                                .stock_out ==
                                                            1
                                                        ? null
                                                        : (value) async {
                                                            final TextEditingController
                                                                confirmController =
                                                                TextEditingController();
                                                            bool
                                                                isConfirmMatched =
                                                                false;

                                                            await AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .question,
                                                              dismissOnTouchOutside:
                                                                  false,
                                                              dismissOnBackKeyPress:
                                                                  false,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              animType: AnimType
                                                                  .scale,
                                                              body:
                                                                  StatefulBuilder(
                                                                builder: (context,
                                                                    setDialogState) {
                                                                  return Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      text(
                                                                        context,
                                                                        fontSize:
                                                                            14,
                                                                        value ==
                                                                                true
                                                                            ? 'คุณต้องการระบุว่าอาหารนี้หมดใช่หรือไม่?'
                                                                            : 'คุณต้องการยกเลิกสถานะอาหารหมดใช่หรือไม่?',
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              16),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              confirmController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                'พิมพ์คำว่า "Confirm" เพื่อยืนยัน',
                                                                            labelStyle:
                                                                                TextStyle(fontSize: 12),
                                                                          ),
                                                                          onChanged:
                                                                              (text) {
                                                                            isConfirmMatched =
                                                                                text.trim().toLowerCase() == 'confirm';
                                                                            setDialogState(() {});
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              16),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            dialog().DialogButton(
                                                                              context: context,
                                                                              label: 'ยกเลิก',
                                                                              color: Colors.teal,
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                            ),
                                                                            dialog().DialogButton(
                                                                              context: context,
                                                                              label: 'ยืนยัน',
                                                                              color: isConfirmMatched ? Colors.teal : Colors.grey,
                                                                              onPressed: isConfirmMatched
                                                                                  ? () async {
                                                                                      final ListFoodModel mFood = lFoodList[index];
                                                                                      final ListUserModel mUser = widget.lUserLogin.first;

                                                                                      await ManageFoodApi().CreateFood(
                                                                                        context,
                                                                                        headers_: widget.headers,
                                                                                        mFood_: mFood..stock_out = 1,
                                                                                        mUser: mUser,
                                                                                      );
                                                                                      Navigator.of(context).pop();
                                                                                      slotCache.remove(selectedSlot ?? getTimeSlot(timeSlots));
                                                                                      await loadData();
                                                                                    }
                                                                                  : null,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ).show();
                                                          },
                                                  ),
                                                  text(
                                                    context,
                                                    "อาหารหมด",
                                                    color: const Color.fromARGB(
                                                        255, 26, 90, 76),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Opacity(
                                              //   opacity: isDisabled ? 0.5 : 1.0,
                                              //   child: SizedBox(
                                              //     height: 30,
                                              //     child: Builder(
                                              //       builder: (context) {
                                              //         final List<String>
                                              //             takeTimeList =
                                              //             food.take_time
                                              //                     is String
                                              //                 ? [
                                              //                     food.take_time
                                              //                         .toString()
                                              //                   ]
                                              //                 : (food.take_time
                                              //                         as List)
                                              //                     .map((e) => e
                                              //                         .toString()
                                              //                         .trim())
                                              //                     .toList();

                                              //         final now =
                                              //             DateTime.now();
                                              //         final currentTime =
                                              //             '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                                              //         return ListView.builder(
                                              //           scrollDirection:
                                              //               Axis.horizontal,
                                              //           itemCount:
                                              //               timeSlots.length,
                                              //           itemBuilder:
                                              //               (context, index) {
                                              //             final slot =
                                              //                 timeSlots[index]
                                              //                     .trim();
                                              //             final bool
                                              //                 isInTakeTime =
                                              //                 takeTimeList
                                              //                     .contains(
                                              //                         slot);
                                              //             final bool
                                              //                 isCurrentTime =
                                              //                 currentTime ==
                                              //                     slot;

                                              //             Color bgColor;
                                              //             Color textColor;

                                              //             if (isInTakeTime &&
                                              //                 isCurrentTime) {
                                              //               bgColor =
                                              //                   Colors.green;
                                              //               textColor =
                                              //                   Colors.white;
                                              //             } else if (isInTakeTime) {
                                              //               bgColor = Colors
                                              //                   .teal[700]!;
                                              //               textColor =
                                              //                   Colors.white;
                                              //             } else {
                                              //               bgColor =
                                              //                   Colors.white;
                                              //               textColor = Colors
                                              //                   .teal[700]!;
                                              //             }

                                              //             return Container(
                                              //               margin:
                                              //                   const EdgeInsets
                                              //                       .symmetric(
                                              //                       horizontal:
                                              //                           4),
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .symmetric(
                                              //                       horizontal:
                                              //                           13,
                                              //                       vertical:
                                              //                           4),
                                              //               decoration:
                                              //                   BoxDecoration(
                                              //                 color: bgColor,
                                              //                 borderRadius:
                                              //                     BorderRadius
                                              //                         .circular(
                                              //                             20),
                                              //                 border: Border.all(
                                              //                     color: Colors
                                              //                         .teal),
                                              //               ),
                                              //               child: Center(
                                              //                 child: text(
                                              //                   context,
                                              //                   slot,
                                              //                   color:
                                              //                       textColor,
                                              //                 ),
                                              //               ),
                                              //             );
                                              //           },
                                              //         );
                                              //       },
                                              //     ),
                                              //   ),
                                              // ),
                                              // const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  AbsorbPointer(
                                                    absorbing: isDisabled,
                                                    child: Opacity(
                                                      opacity: isDisabled
                                                          ? 0.5
                                                          : 1.0,
                                                      child: SwitchStatus(
                                                        switchStatus: (() {
                                                          final rawStatus =
                                                              lFoodList[index]
                                                                  .pre_pare_status;
                                                          final normalized =
                                                              (rawStatus
                                                                      ?.trim()
                                                                      .toLowerCase() ??
                                                                  '');

                                                          return normalized ==
                                                                  'ready'
                                                              ? 1
                                                              : 0;
                                                        })(),
                                                        onChanged:
                                                            (value) async {
                                                          final ListFoodModel
                                                              mFood =
                                                              lFoodList[index];
                                                          final ListUserModel
                                                              mUser = widget
                                                                  .lUserLogin
                                                                  .first;
                                                          final String status =
                                                              value == 1
                                                                  ? 'ready'
                                                                  : 'pending';

                                                          await ManageFoodApi()
                                                              .CreateFood(
                                                            context,
                                                            headers_:
                                                                widget.headers,
                                                            mFood_: mFood
                                                              ..status = status,
                                                            mUser: mUser,
                                                          );

                                                          setState(() {
                                                            lFoodList[index]
                                                                    .pre_pare_status =
                                                                status;
                                                          });

                                                          await loadData();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
