import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TabContainer(
      controller: _tabController,
      tabEdge: TabEdge.top,
      tabsStart: 0.1,
      tabsEnd: 0.9,
      tabMaxLength: 100,
      borderRadius: BorderRadius.circular(10),
      tabBorderRadius: BorderRadius.circular(10),
      childPadding: const EdgeInsets.all(20.0),
      selectedTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15.0,
      ),
      unselectedTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13.0,
      ),
      colors: [
        Colors.red,
        Colors.green,
        Colors.blue,
      ],
      tabs: [
        Text('Tab 1'),
        Text('Tab 2'),
        Text('Tab 3'),
      ],
      children: [
        Container(
          child: Text('Child 1'),
        ),
        Container(
          child: Text('Child 2'),
        ),
        Container(
          child: Text('Child 3'),
        ),
      ],
    ));
  }
}

 // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 8, right: 4),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Expanded(
                      //             child: TextButton(
                      //               style: TextButton.styleFrom(
                      //                 backgroundColor: iMenu == 1
                      //                     ? Color.fromARGB(255, 243, 214, 126)
                      //                     : Color.fromARGB(255, 243, 214, 126),
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.only(
                      //                       topLeft: Radius.circular(15),
                      //                       topRight: Radius.circular(15)),
                      //                 ),
                      //                 minimumSize: Size(150, 40),
                      //               ),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Image.asset(
                      //                     "assets/images/menu2.png",
                      //                     width: 25,
                      //                     height: 25,
                      //                   ),
                      //                   SizedBox(width: 4),
                      //                   text(
                      //                     context,
                      //                     'สังเกตอาการ',
                      //                     fontWeight:
                      //                         iMenu == 1 ? FontWeight.bold : null,
                      //                     color: iMenu == 1
                      //                         ? Colors.blue[900]
                      //                         : Colors.black,
                      //                   ),
                      //                 ],
                      //               ),
                      //               onPressed: () {
                      //                 setState(() {
                      //                   iMenu = 1;
                      //                 });
                      //               },
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 2,
                      //           ),
                      //           Expanded(
                      //             child: TextButton(
                      //               style: TextButton.styleFrom(
                      //                 backgroundColor: iMenu == 2
                      //                     ? Color.fromARGB(255, 161, 223, 240)
                      //                     : Color.fromARGB(255, 161, 223, 240),
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.only(
                      //                       topLeft: Radius.circular(15),
                      //                       topRight: Radius.circular(15)),
                      //                 ),
                      //                 minimumSize: Size(150, 40),
                      //               ),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Image.asset(
                      //                     "assets/images/menu2.png",
                      //                     width: 25,
                      //                     height: 25,
                      //                   ),
                      //                   SizedBox(width: 4),
                      //                   text(context, 'ยากิน',
                      //                       fontWeight: iMenu == 2
                      //                           ? FontWeight.bold
                      //                           : null,
                      //                       color: iMenu == 2
                      //                           ? Colors.blue[900]
                      //                           : Colors.black),
                      //                 ],
                      //               ),
                      //               onPressed: () {
                      //                 iMenu = 2;
                      //                 setState(() {});
                      //               },
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 2,
                      //           ),
                      //           Expanded(
                      //             child: TextButton(
                      //               style: TextButton.styleFrom(
                      //                 backgroundColor: iMenu == 3
                      //                     ? Color.fromARGB(255, 229, 215, 243)
                      //                     : Color.fromARGB(255, 229, 215, 243),
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.only(
                      //                       topLeft: Radius.circular(15),
                      //                       topRight: Radius.circular(15)),
                      //                 ),
                      //                 minimumSize: Size(150, 40),
                      //               ),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Image.asset(
                      //                     "assets/images/menu3.png",
                      //                     width: 25,
                      //                     height: 25,
                      //                   ),
                      //                   SizedBox(width: 4),
                      //                   text(
                      //                     context,
                      //                     'ยาหยอดหู,ตา',
                      //                     fontWeight:
                      //                         iMenu == 3 ? FontWeight.bold : null,
                      //                     color: iMenu == 3
                      //                         ? Colors.blue[900]
                      //                         : Colors.black,
                      //                   ),
                      //                 ],
                      //               ),
                      //               onPressed: () {
                      //                 iMenu = 3;
                      //                 setState(() {});
                      //               },
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 2,
                      //           ),
                      //           Expanded(
                      //             child: TextButton(
                      //               style: TextButton.styleFrom(
                      //                 backgroundColor: iMenu == 4
                      //                     ? Color.fromARGB(255, 114, 214, 208)
                      //                     : Color.fromARGB(255, 114, 214, 208),
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.only(
                      //                       topLeft: Radius.circular(15),
                      //                       topRight: Radius.circular(15)),
                      //                 ),
                      //                 minimumSize: Size(150, 40),
                      //               ),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Image.asset(
                      //                     "assets/images/menu4.png",
                      //                     width: 25,
                      //                     height: 25,
                      //                   ),
                      //                   SizedBox(width: 4),
                      //                   text(context, 'ยาฉีด',
                      //                       fontWeight: iMenu == 4
                      //                           ? FontWeight.bold
                      //                           : null,
                      //                       color: iMenu == 4
                      //                           ? Colors.blue[900]
                      //                           : Colors.black),
                      //                 ],
                      //               ),
                      //               onPressed: () {
                      //                 iMenu = 4;
                      //                 setState(() {});
                      //               },
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     if (iMenu == 1)
                      //       SingleChildScrollView(
                      //         scrollDirection: Axis.horizontal,
                      //         child: Row(
                      //           children: [
                      //             Padding(
                      //               padding:
                      //                   const EdgeInsets.only(right: 8, left: 8),
                      //               child: SizedBox(
                      //                 width: MediaQuery.of(context).size.width /
                      //                     1.02,
                      //                 height: MediaQuery.of(context).size.height,
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     color: const Color.fromARGB(
                      //                         255, 243, 214, 126),
                      //                     borderRadius: BorderRadius.only(
                      //                         bottomLeft: Radius.circular(15),
                      //                         bottomRight: Radius.circular(15)),
                      //                   ),
                      //                   child: Center(
                      //                     child: Text(
                      //                       "เนื้อหาสำหรับ สังเกตอาการ",
                      //                       style: TextStyle(
                      //                           fontSize: 18,
                      //                           color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     if (iMenu == 2)
                      //       SingleChildScrollView(
                      //         scrollDirection: Axis.horizontal,
                      //         child: Row(
                      //           children: [
                      //             Padding(
                      //               padding:
                      //                   const EdgeInsets.only(right: 8, left: 8),
                      //               child: SizedBox(
                      //                 width: MediaQuery.of(context).size.width /
                      //                     1.02,
                      //                 height: MediaQuery.of(context).size.height,
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     color:
                      //                         Color.fromARGB(255, 161, 223, 240),
                      //                     borderRadius: BorderRadius.only(
                      //                         bottomLeft: Radius.circular(15),
                      //                         bottomRight: Radius.circular(15)),
                      //                   ),
                      //                   child: Center(
                      //                     child: Text(
                      //                       "เนื้อหาสำหรับ สังเกตอาการ",
                      //                       style: TextStyle(
                      //                           fontSize: 18,
                      //                           color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     if (iMenu == 3)
                      //       SingleChildScrollView(
                      //         scrollDirection: Axis.horizontal,
                      //         child: Row(
                      //           children: [
                      //             Padding(
                      //               padding:
                      //                   const EdgeInsets.only(right: 8, left: 8),
                      //               child: SizedBox(
                      //                 width: MediaQuery.of(context).size.width /
                      //                     1.02,
                      //                 height: MediaQuery.of(context).size.height,
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     color:
                      //                         Color.fromARGB(255, 229, 215, 243),
                      //                     borderRadius: BorderRadius.only(
                      //                         bottomLeft: Radius.circular(15),
                      //                         bottomRight: Radius.circular(15)),
                      //                   ),
                      //                   child: Center(
                      //                     child: Text(
                      //                       "เนื้อหาสำหรับ สังเกตอาการ",
                      //                       style: TextStyle(
                      //                           fontSize: 18,
                      //                           color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     if (iMenu == 4)
                      //       SingleChildScrollView(
                      //         scrollDirection: Axis.horizontal,
                      //         child: Row(
                      //           children: [
                      //             Padding(
                      //               padding:
                      //                   const EdgeInsets.only(right: 8, left: 8),
                      //               child: SizedBox(
                      //                 width: MediaQuery.of(context).size.width /
                      //                     1.02,
                      //                 height: MediaQuery.of(context).size.height,
                      //                 child: Container(
                      //                   decoration: BoxDecoration(
                      //                     color:
                      //                         Color.fromARGB(255, 114, 214, 208),
                      //                     borderRadius: BorderRadius.only(
                      //                         bottomLeft: Radius.circular(15),
                      //                         bottomRight: Radius.circular(15)),
                      //                   ),
                      //                   child: Center(
                      //                     child: Text(
                      //                       "เนื้อหาสำหรับ สังเกตอาการ",
                      //                       style: TextStyle(
                      //                           fontSize: 18,
                      //                           color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //   ],
                      // )
