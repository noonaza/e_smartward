// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:e_smartward/Model/list_data_card_model.dart';
import 'package:e_smartward/api/manage_food_api.dart';
import 'package:e_smartward/widgets/text.copy';
import '../Model/list_food_model.dart';
import '../Model/list_pet_model.dart';
import 'switch_widget.dart';

class ManageFoodWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  final Map<String, String> headers;
  final String groupId;
  final String? siteCode;
  final String? wardCode;
  final bool isWardMode;

  const ManageFoodWidget({
    super.key,
    required this.lDataCard,
    required this.headers,
    required this.groupId,
    this.siteCode,
    this.wardCode,
    required this.isWardMode,
  });

  @override
  _ManageFoodWidgetState createState() => _ManageFoodWidgetState();
}

class _ManageFoodWidgetState extends State<ManageFoodWidget> {
  List<ListFoodModel> lFoodList = [];
  List<ListPetModel> lPetAdmit = [];
  List<String> timeSlots = [];
  String? selectedSlot;
  String? selectedSite;
  String? selectedWard;
  Set<String> activeSlots = {};
  int switchStatusValue = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final slots = await ManageFoodApi().loadFoodSlot(
      context,
      headers_: widget.headers,
      groupId: widget.groupId,
    );

    String getClosestTimeSlot(List<String> timeSlots) {
      final now = TimeOfDay.now();
      final nowMinutes = now.hour * 60 + now.minute;

      String? closestSlot;
      int? minDiff;

      for (final slot in timeSlots) {
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

    final slotToUse = selectedSlot ?? getClosestTimeSlot(slots);

    final foodItems = await ManageFoodApi().loadListFoodSlot(
      context,
      headers_: widget.headers,
      slot: slotToUse,
      groupId: widget.groupId,
      siteCode: widget.siteCode ?? '',
      ward: widget.wardCode ?? '',
      type: widget.isWardMode ? 'WARD' : 'GROUP-BED',
    );

    setState(() {
      timeSlots = slots;
      lFoodList = foodItems.map((item) {
        return ListFoodModel(
          item_name: item['item_name'],
          item_qty: item['item_qty']?.toString(),
          unit_name: item['unit_name'],
          dose_qty: item['dose_qty'],
          stock_out: int.tryParse(item['stock_out']?.toString() ?? '0'),
          time_slot: item['time_slot'],
          hn_number: item['hn_number'],
          an_number: item['an_number'],
          take_time: item['take_time'],
          visit_number: item['visit_number'],
          pet_name: item['pet_name'],
          bed_number: item['bed_number'],
        );
      }).toList();
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
                      setState(() {
                        selectedSlot = slot;
                      });
                      loadData();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.teal
                            : isActive
                                ? Colors.green[200]
                                : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Center(
                        child: text(
                          context,
                          color: isSelected ? Colors.white : Colors.teal,
                          slot,
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
                        bool isChecked = lFoodList[index].stock_out == 0;

                        return GestureDetector(
                          onTap: () {},
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
                                    color: const Color.fromARGB(
                                        255, 154, 212, 212),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                  "Name : ${food.item_name}",
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
                                                    value: isChecked,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isChecked = value!;
                                                        food.stock_out =
                                                            isChecked ? 0 : 1;
                                                        lFoodList[index]
                                                                .stock_out =
                                                            isChecked ? 0 : 1;
                                                      });
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: text(
                                                  context,
                                                  "เวลาให้ : ${food.take_time}",
                                                  color: const Color.fromARGB(
                                                      255, 26, 90, 76),
                                                ),
                                              ),
                                              SwitchStatus(
                                                switchStatus: switchStatusValue,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
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
