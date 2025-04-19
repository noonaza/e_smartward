import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

class TimeSelection extends StatefulWidget {
  final List<String> time;
  final List<String> timeList;

  const TimeSelection({required this.time, required this.timeList});

  @override
  _TimeSelectionWidgetState createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelection> {
  List<bool> selectedTimeList = [];
  List<bool> selected = [];
  int? selectedTimeIndex;

  @override
  void initState() {
    super.initState();
    selectedTimeList = List.generate(widget.timeList.length, (index) => false);
    selected = List.generate(widget.time.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ListView.builder สำหรับ Time
        SizedBox(
          height: 30, // ปรับความสูงของ ListView.builder ตามที่ต้องการ
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.time.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTimeList =
                          List.generate(widget.timeList.length, (i) => false);
                      selectedTimeIndex = index;
                      selected =
                          List.generate(widget.time.length, (i) => i == index);

                      if (index == 0) {
                        selectedTimeList[0] = true;
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selected[index] ? Colors.grey : Colors.white,
                    side: BorderSide(
                        color: selected[index] ? Colors.grey : Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: text(context, widget.time[index], color: Colors.black),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 15),

        SizedBox(
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 5,
              ),
              itemCount: widget.timeList.length,
              itemBuilder: (context, index) {
                return IntrinsicWidth(
                  child: ElevatedButton(
                    onPressed: () {
                      int interval = 1;
                      if (selectedTimeIndex == 1) {
                        interval = 2;
                      } else if (selectedTimeIndex == 2) {
                        interval = 3;
                      } else if (selectedTimeIndex == 3) {
                        interval = 4;
                      }

                      setState(() {
                        selectedTimeList =
                            List.generate(widget.timeList.length, (i) => false);

                        if (selectedTimeIndex! >= 1 &&
                            selectedTimeIndex! <= 3) {
                          for (int i = index;
                              i < widget.timeList.length;
                              i += interval) {
                            selectedTimeList[i] = true;
                          }
                        } else {
                          selectedTimeList[index] = !selectedTimeList[index];
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedTimeList[index] ? Colors.grey : Colors.white,
                      side: BorderSide(
                          color: selectedTimeList[index]
                              ? Colors.grey
                              : Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: FittedBox(
                      child: text(context, widget.timeList[index],
                          color: Color.fromARGB(255, 10, 85, 77)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
