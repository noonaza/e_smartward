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
          width: 120.0,
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

class SwitchStatus extends StatelessWidget {
  final int switchStatus;
  final ValueChanged<int> onChanged;

  const SwitchStatus({
    super.key,
    required this.switchStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = switchStatus == 1;

    return GestureDetector(
      onTap: () {
        onChanged(isActive ? 0 : 1);
      },
      child: Container(
        width: 90.0,
        height: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 21, 122, 89)
              : const Color.fromARGB(255, 173, 100, 100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment:
                  isActive ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: AnimatedAlign(
                alignment:
                    isActive ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Text(
                  isActive ? 'จัดแล้ว' : 'ยังไม่จัด',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchNoteStatus extends StatefulWidget {
  final int switchStatus;
  final ValueChanged<int> onChanged;

  const SwitchNoteStatus({
    super.key,
    required this.switchStatus,
    required this.onChanged,
  });

  @override
  State<SwitchNoteStatus> createState() => _SwitchNoteStatusState();
}

class _SwitchNoteStatusState extends State<SwitchNoteStatus> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.switchStatus == 1;
  }

  void toggleSwitch() {
    setState(() {
      isActive = !isActive;
    });
    widget.onChanged(isActive ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: Container(
        width: 90.0,
        height: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 21, 122, 89)
              : const Color.fromARGB(255, 173, 100, 100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment:
                  isActive ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: AnimatedAlign(
                alignment:
                    isActive ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Text(
                  isActive ? 'ให้แล้ว' : 'รอ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
