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
