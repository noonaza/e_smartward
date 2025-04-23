import 'dart:convert';

import 'package:e_smartward/Model/list_data_obs.dart';
import 'package:e_smartward/widgets/text.copy';
import 'package:flutter/material.dart';

class ObsListWidget extends StatefulWidget {
  final List<ListDataObsDetailModel> lDataObs;
  final Map<String, String> headers;
  final Function(ListDataObsDetailModel obs) onEdit;
  final Function(int index) onDelete;
  final VoidCallback onAdd;
  final VoidCallback onCopy;

  const ObsListWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.onCopy,
    required this.lDataObs,
    required this.headers,
  });

  @override
  _ObsListWidgetState createState() => _ObsListWidgetState();
}

class _ObsListWidgetState extends State<ObsListWidget> {
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
              child: widget.lDataObs.isEmpty
                  ? Center(
                      child: SizedBox(
                      child: text(context, 'No data'),
                    ))
                  : ListView.builder(
                      itemCount: widget.lDataObs.length,
                      itemBuilder: (context, index) {
                        final obs = widget.lDataObs[index];
                        final String ObsName = obs.set_name!;
                        // final String ObsNote = obs.set_name!;
                        final Map<String, dynamic> setValue =
                            jsonDecode(obs.set_value!);

                        final List<String> displayItems = [];

                        if (setValue.containsKey('obs') &&
                            setValue['obs'] != null &&
                            setValue['obs'].toString() != '0') {
                          displayItems.add('obs');
                        }

                        if (setValue.containsKey('col') &&
                            setValue['col'] != null &&
                            setValue['col'].toString() != '0') {
                          displayItems.add('col'); 
                        }
                        return GestureDetector(
                          onTap: () => widget.onEdit(obs),
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
                                    color: Color.fromARGB(255, 255, 208, 192),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          text(context, ObsName,
                                              color: const Color.fromARGB(
                                                  255, 215, 116, 114)),
                                          const SizedBox(height: 4),
                                          Wrap(
                                            children: displayItems
                                                .map<Widget>((time) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 215, 116, 114),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              215,
                                                              116,
                                                              114),
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
                                        color: const Color.fromARGB(
                                            255, 215, 116, 114)),
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
                      // showCopyObsDialog(context);
                    },
                  ),
                  const SizedBox(height: 8), // เพิ่มระยะห่างระหว่างปุ่ม
                  IconButton(
                    icon: const Icon(Icons.add_circle_outlined,
                        size: 35,
                        color: const Color.fromARGB(255, 215, 116, 114)),
                    onPressed: widget.onAdd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void showCopyObsDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           content: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width / 1.2,
  //           height: MediaQuery.of(context).size.height,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: copyLists.length,
  //             itemBuilder: (context, index) {
  //               String cardDate = copyLists[index]["cardDate"];
  //               List<dynamic> items = copyLists[index]["items"];

  //               return Padding(
  //                 padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
  //                 child: SingleChildScrollView(
  //                   child: SizedBox(
  //                     width: MediaQuery.of(context).size.width / 4,
  //                     height: MediaQuery.of(context).size.height,
  //                     child: Card(
  //                       elevation: 5,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(15),
  //                       ),
  //                       color: Color.fromARGB(255, 255, 208, 192),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(12.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             FittedBox(
  //                               alignment: Alignment.bottomRight,
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   text(
  //                                     context,
  //                                     cardDate,
  //                                   ),
  //                                   IconButton(
  //                                     iconSize: 25,
  //                                     color: Colors.redAccent,
  //                                     icon: Icon(Icons.copy),
  //                                     onPressed: () {
  //                                       // setState(() {
  //                                       //   listObs = List.from(items);
  //                                       // });
  //                                       // Navigator.pop(context);
  //                                     },
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(height: 12),
  //                             Column(
  //                               children: items.map<Widget>((item) {
  //                                 String category = item["category"];
  //                                 String description = item["description"];
  //                                 List<String> causetimes =
  //                                     List<String>.from(item["times"]);

  //                                 return Card(
  //                                   elevation: 3,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                   ),
  //                                   color: Color.fromARGB(255, 240, 240, 240),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         text(
  //                                           context,
  //                                           category,
  //                                         ),
  //                                         SizedBox(height: 4),
  //                                         text(
  //                                           context,
  //                                           description,
  //                                         ),
  //                                         SizedBox(height: 8),
  //                                         Row(
  //                                           children:
  //                                               causetimes.map<Widget>((time) {
  //                                             return Padding(
  //                                               padding:
  //                                                   const EdgeInsets.all(4.0),
  //                                               child: Container(
  //                                                 padding: const EdgeInsets
  //                                                     .symmetric(
  //                                                     horizontal: 12,
  //                                                     vertical: 8),
  //                                                 decoration: BoxDecoration(
  //                                                   color: Color.fromARGB(
  //                                                       255, 215, 116, 114),
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           20),
  //                                                   border: Border.all(
  //                                                     color: Color.fromARGB(
  //                                                         255, 215, 116, 114),
  //                                                     width: 2,
  //                                                   ),
  //                                                 ),
  //                                                 child: text(context, time,
  //                                                     color: Colors.white),
  //                                               ),
  //                                             );
  //                                           }).toList(),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 );
  //                               }).toList(),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ));
  //     },
  //   );
  // }
}
