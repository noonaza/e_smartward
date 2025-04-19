import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

class ObsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> listObs;

  final Function(Map<String, dynamic>) onEdit;
  final Function(int index) onDelete;
  final VoidCallback onAdd;
  final VoidCallback onCopy;
  final TextStyle? textStyle;

  ObsListWidget({
    super.key,
    required this.listObs,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    this.textStyle, required this.onCopy,
  });
  final List<Map<String, dynamic>> copyLists = [
    {
      "cardDate": "AN: 20250202-123",
      "items": [
        {
          "category": "ปัสสาวะ",
          "description": "ไม่ปัสสาวะเลย",
          "times": ["04:00"]
        },
        {
          "category": "อุจจาระ",
          "description": "ไม่มีอาการท้องเสีย หรือ อุจจาระบ่อย",
          "times": ["04:00"]
        },
        {
          "category": "เพิ่มเติมอื่นๆ",
          "description": "พบว่า มีน้ำตาไหลตลอดเวลา",
          "times": ["04:00"]
        },
        {
          "category": "กินอาหารได้น้อย",
          "description": "กินแค่ 3 กรัม ต่อวัน",
          "times": ["04:00"]
        },
      ],
    },
    {
      "cardDate": "AN: 20250131-123",
      "items": [
        {
          "category": "ปัสสาวะ",
          "description": "เวลาปวดปัสสาวะ มีอาการปวดท้อง",
          "times": ["04:00"]
        },
        {
          "category": "อุจจาระ",
          "description": "สำคัญ ไม่ควรลบ",
          "times": ["04:00"]
        },
        {
          "category": "เพิ่มเติมอื่นๆ",
          "description": "ปัสสาวะบ่อย",
          "times": ["04:00"]
        },
        {
          "category": "มีอาเจียน",
          "description": "อาเจียนติดกัน 4 รอบ",
          "times": ["04:00"]
        },
      ],
    }
  ];

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
              child: ListView.builder(
                itemCount: listObs.length,
                itemBuilder: (context, index) {
                  final obs = listObs[index];
                  final String ObsName = obs["name"];
                  final String ObsNote = obs["note"];

                  final List<String> ObsTimes = List<String>.from(obs["times"]);

                  return GestureDetector(
                    onTap: () => onEdit(obs),
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
                              color: Color.fromARGB(255, 255, 208, 192),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(context, "อาการ : $ObsName",
                                        color: const Color.fromARGB(
                                            255, 215, 116, 114)),
                                    const SizedBox(height: 4),
                                    text(context, "หมายเหตุ: $ObsNote",
                                        color: const Color.fromARGB(
                                            255, 215, 116, 114)),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      children: ObsTimes.map<Widget>((time) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 215, 116, 114),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 215, 116, 114),
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
                                      const Color.fromARGB(255, 215, 116, 114)),
                              onPressed: () => onDelete(index),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.copy_all,
                      size: 35,
                      color: const Color.fromARGB(255, 215, 116, 114),
                    ),
                    onPressed: () {
                      showCopyObsDialog(context);
                    },
                  ),
                  const SizedBox(height: 8), // เพิ่มระยะห่างระหว่างปุ่ม
                  IconButton(
                    icon: const Icon(Icons.add_circle_outlined,
                        size: 35,
                        color: const Color.fromARGB(255, 215, 116, 114)),
                    onPressed: onAdd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCopyObsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: copyLists.length,
              itemBuilder: (context, index) {
                String cardDate = copyLists[index]["cardDate"];
                List<dynamic> items = copyLists[index]["items"];

                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color.fromARGB(255, 255, 208, 192),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    text(
                                      context,
                                      cardDate,
                                    ),
                                    IconButton(
                                      iconSize: 25,
                                      color: Colors.redAccent,
                                      icon: Icon(Icons.copy),
                                      onPressed: () {
                                        // setState(() {
                                        //   listObs = List.from(items);
                                        // });
                                        // Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Column(
                                children: items.map<Widget>((item) {
                                  String category = item["category"];
                                  String description = item["description"];
                                  List<String> causetimes =
                                      List<String>.from(item["times"]);

                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(
                                            context,
                                            category,
                                          ),
                                          SizedBox(height: 4),
                                          text(
                                            context,
                                            description,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children:
                                                causetimes.map<Widget>((time) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 215, 116, 114),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 215, 116, 114),
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
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
      },
    );
  }
}
