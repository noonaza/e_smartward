// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import 'package:e_smartward/widget/text.dart';

class SwitchCard extends StatefulWidget {
  final bool Switch;
  final ValueChanged<bool> onChanged;

  const SwitchCard({
    super.key,
    required this.Switch,
    required this.onChanged,
  });

  @override
  State<SwitchCard> createState() => _CustomAdvancedSwitchState();
}

class _CustomAdvancedSwitchState extends State<SwitchCard> {
  late final ValueNotifier<bool> _controller;

  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier<bool>(false);
    _controller.addListener(() {
      widget.onChanged(_controller.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AdvancedSwitch(
          controller: _controller,
          activeColor: Colors.teal,
          inactiveColor: Colors.teal,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          width: 100.0,
          height: 30.0,
          enabled: true,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _controller,
          builder: (context, value, _) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: value ? 25.0 : 33.0,
              right: value ? 20.0 : 0.0,
              child: text(
                context,
                value ? 'Ward' : 'Bed-Group',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }
}

class SwitchStatus extends StatefulWidget {
  final int switchStatus; 
  final ValueChanged<int> onChanged;

  const SwitchStatus({
    super.key,
    required this.switchStatus,
    required this.onChanged,
  });

  @override
  State<SwitchStatus> createState() => _SwitchStatusState();
}

class _SwitchStatusState extends State<SwitchStatus> {
  late final ValueNotifier<bool> _controller;

  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier<bool>(widget.switchStatus == 1);
    _controller.addListener(() {
      widget.onChanged(_controller.value ? 1 : 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AdvancedSwitch(
          controller: _controller,
          activeColor: Color.fromARGB(255, 57, 136, 226),
          inactiveColor: Color.fromARGB(255, 173, 100, 100),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          width: 90.0,
          height: 30.0,
          enabled: true,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _controller,
          builder: (context, value, _) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: value ? 25.0 : 33.0,
              right: value ? 20.0 : 0.0,
              child: text(
                context,
                value ? 'จัดแล้ว' : 'ยังไม่จัด',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }
}
