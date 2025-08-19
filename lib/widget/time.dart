import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';

class TimeSelection extends StatefulWidget {
  final List<String> time;
  final List<String> timeList;
  final String? selectedMealTiming;
  final List<String>? initialTakeTimes;
  final String? initialTimeSlot;
  final Function(int? selectedTimeIndex, List<bool> selectedTimeList)?
      onSelectionChanged;

  const TimeSelection({
    super.key,
    required this.time,
    required this.timeList,
    this.selectedMealTiming,
    this.initialTakeTimes,
    this.initialTimeSlot,
    this.onSelectionChanged,
  });

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

    selectedTimeList = List.generate(widget.timeList.length, (_) => false);
    selected = List.generate(widget.time.length, (_) => false);

    if (widget.initialTimeSlot != null) {
      final index = widget.time.indexOf(widget.initialTimeSlot!);
      if (index != -1) {
        selectedTimeIndex = index;
        selected[index] = true;
      }
    }

    if (widget.initialTakeTimes != null) {
      for (int i = 0; i < widget.timeList.length; i++) {
        if (widget.initialTakeTimes!.contains(widget.timeList[i])) {
          selectedTimeList[i] = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.time.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedTimeIndex == index) {
                        selectedTimeIndex = null;
                        selected =
                            List.generate(widget.time.length, (_) => false);
                        selectedTimeList =
                            List.generate(widget.timeList.length, (_) => false);
                      } else {
                        selectedTimeIndex = index;
                        selected = List.generate(
                            widget.time.length, (i) => i == index);
                        selectedTimeList =
                            List.generate(widget.timeList.length, (_) => false);
                      }

                      widget.onSelectionChanged
                          ?.call(selectedTimeIndex, selectedTimeList);
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
        const SizedBox(height: 15),
        Container(
          height: 150,
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
                  onPressed: selectedTimeIndex == null
                      ? null
                      : () {
                          setState(() {
                            int interval = 1;

                            // ตั้งค่าระยะเวลาเป็นช่วง
                            switch (selectedTimeIndex) {
                              case 1:
                                interval = 2;
                                break;
                              case 2:
                                interval = 3;
                                break;
                              case 3:
                                interval = 4;
                                break;
                              case 4:
                                interval = 6;
                                break;
                              case 5:
                                interval = 8;
                                break;
                            }

                            if (selectedTimeIndex != null &&
                                selectedTimeIndex! < 6) {
                              // ช่วงเวลาทุกๆ X ชม.
                              selectedTimeList = List.generate(
                                  widget.timeList.length, (_) => false);
                              int i = index;
                              do {
                                selectedTimeList[i] = true;
                                i = (i + interval) % widget.timeList.length;
                              } while (i != index);
                            } else if (selectedTimeIndex == 6) {
                              // "กำหนดเอง" เลือกอิสระ
                              selectedTimeList[index] =
                                  !selectedTimeList[index];
                            }

                            widget.onSelectionChanged
                                ?.call(selectedTimeIndex, selectedTimeList);
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
                    child: text(
                      context,
                      widget.timeList[index],
                      color: const Color.fromARGB(255, 10, 85, 77),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
