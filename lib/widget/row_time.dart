// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import '../Model/list_data_obs.dart';

// ignore: must_be_immutable
class RowTime extends StatefulWidget {
  String drug_instruction;
  final Color chipColor;
  final List<ListDataObsDetailModel> lSettingTime;

  RowTime({
    super.key,
    required this.drug_instruction,
    required this.lSettingTime,
    required this.chipColor,
  });

  @override
  State<RowTime> createState() => _RowTimeState();
}

class _RowTimeState extends State<RowTime> {
  String? m;
  String? l;
  String? a;
  String? d;

  @override
  void initState() {
    super.initState();

    String? Time(String key) {
      final item = widget.lSettingTime.firstWhere((e) => e.set_key == key);
      return widget.drug_instruction.contains(item.set_name!)
          ? item.set_value!.split(': ').last.replaceAll('}', '')
          : null;
    }

    m = Time('m');
    l = Time('l');
    a = Time('a');
    d = Time('d');
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        if (m != null)
          Chip(
            label: text(context, m!, color: Colors.white),
            backgroundColor: widget.chipColor,
          ),
        if (l != null)
          Chip(
            label: text(context, l!, color: Colors.white),
            backgroundColor: widget.chipColor,
          ),
        if (a != null)
          Chip(
            label: text(context, a!, color: Colors.white),
            backgroundColor: widget.chipColor,
          ),
        if (d != null)
          Chip(
            label: text(context, d!, color: Colors.white),
            backgroundColor: widget.chipColor,
          ),
      ],
    );
  }
}
