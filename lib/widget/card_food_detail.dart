
import 'package:e_smartward/Model/list_data_card.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

class FoodListWidget extends StatefulWidget {
  final List<ListDataCardModel> lDataCard;
  final Map<String, String> headers;
  final Function(ListDataCardModel food) onEdit;
  final Function(int index) onDelete;
  final VoidCallback onAdd;

  const FoodListWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.headers,
    required this.lDataCard,
  });

  @override
  _FoodListWidgetState createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget> {

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
                  ? Center(child: SizedBox())
                  :
              ListView.builder(
                itemCount: widget.lDataCard.length,
                itemBuilder: (context, index) {
                  final food = widget.lDataCard[index];
                  final String? foodName = food.item_name;
                  final String? foodDose = food.dose_qty;
                  final String foodUnitName = food.dose_unit_name ?? "-";
                  // final String? foodCondition = food.drug_description;
                  final String? foodtype = food.drug_type_name;
                  final List<String> foodtime =
                      (food.order_time ?? '').split(',');

                  return GestureDetector(
                    onTap: () => widget.onEdit(food),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: const Color.fromARGB(255, 236, 222, 164),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(context, "ชื่ออาหาร : $foodName",
                                        color: const Color.fromARGB(
                                            255, 185, 120, 15)),
                                    const SizedBox(height: 4),
                                    text(context,
                                        "วิธีให้ :  $foodDose  $foodUnitName",
                                        color: const Color.fromARGB(
                                            255, 185, 120, 15)),
                                    const SizedBox(height: 4),
                                    // text(context, "สรรพคุณ : $foodCondition",
                                    //     color: const Color.fromARGB(
                                    //         255, 185, 120, 15)),
                                    const SizedBox(height: 4),
                                    text(context, "ประเภท : $foodtype",
                                        color: const Color.fromARGB(
                                            255, 185, 120, 15)),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      children: foodtime.map<Widget>((time) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 185, 120, 15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 185, 120, 15),
                                                width: 2,
                                              ),
                                            ),
                                            child: text(context, time,
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8.0,
                            top: 10.0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel,
                                  size: 20,
                                  color:
                                      const Color.fromARGB(255, 185, 120, 15)),
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
