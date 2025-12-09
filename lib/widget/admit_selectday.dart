// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:e_smartward/widget/text.dart';
import 'package:e_smartward/widget/textfield.dart';

enum ScheduleMode { weeklyOnce, dailyCustom, monthlyCustom, all }

class ScheduleResult {
  final ScheduleMode mode;

  final Set<String> weekdayNames;
  final String? dailyNote;
  final DateTime? monthlyDate;
  final Set<int> monthlyDays;
  final DateTime? dailyDate;
  final String modeLabel;

  const ScheduleResult({
    required this.mode,
    required this.modeLabel,
    this.weekdayNames = const {},
    this.dailyNote,
    this.monthlyDate,
    this.dailyDate,
    this.monthlyDays = const {},
  });
}

class SchedulePicker extends StatefulWidget {
  const SchedulePicker({
    super.key,
    this.initialMode = ScheduleMode.weeklyOnce,
    this.initialWeeklySelectedNames = const {'จันทร์', 'อังคาร'},
    this.initialDailyNote,
    this.initialMonthlyDate,
    final DateTime? initialDailyDate,
    this.showNoSchedule = false,
    this.onNoSchedule,
    this.dailyDate,
    this.initialMonthlyDays = const <int>{},
    this.onChanged,
    this.allowAll = true,
  });

  final ScheduleMode initialMode;
  final Set<String> initialWeeklySelectedNames;
  final String? initialDailyNote;
  final DateTime? initialMonthlyDate;
  final String? dailyDate;
  final Set<int> initialMonthlyDays;
  final ValueChanged<ScheduleResult>? onChanged;
  final bool showNoSchedule;
  final VoidCallback? onNoSchedule;
  final bool allowAll;

  @override
  State<SchedulePicker> createState() => _SchedulePickerState();
}

class _SchedulePickerState extends State<SchedulePicker> {
  ScheduleMode _mode = ScheduleMode.weeklyOnce;
  bool _noSchedule = false;

  static const List<String> _thaiDayNames = <String>[
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์'
  ];
  DateTime? _dailyDate;
  final TextEditingController _dailyDateCtrl = TextEditingController();

  Future<void> _pickDailyDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dailyDate ?? DateTime.now(),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked != null) {
      setState(() {
        _dailyDate = picked;
        _dailyDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _emit();
    }
  }

  final Set<int> _selectedMonthDays = <int>{};

  late Set<String> _selectedNames;
  final TextEditingController _dailyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 1) ตั้งค่าโหมดและวันสัปดาห์เริ่มต้น
    _mode = widget.initialMode;
    if (!widget.allowAll && _mode == ScheduleMode.all) {
      _mode = ScheduleMode.weeklyOnce;
    }
    _selectedNames = {...widget.initialWeeklySelectedNames};

    _dailyCtrl.text = widget.initialDailyNote ?? '';

    if (widget.initialMonthlyDate != null) {}

    if (widget.initialMonthlyDays.isNotEmpty) {
      _selectedMonthDays
        ..clear()
        ..addAll(widget.initialMonthlyDays);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _emit();
    });
  }

  Map<ScheduleMode, String> kModeLabels = {
    ScheduleMode.weeklyOnce: 'สัปดาห์ละครั้ง',
    ScheduleMode.dailyCustom: 'กำหนดรายวัน',
    ScheduleMode.monthlyCustom: 'กำหนดรายเดือน',
    ScheduleMode.all: 'ไม่กำหนด',
  };

  @override
  void didUpdateWidget(covariant SchedulePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMode != widget.initialMode) {
      setState(() {
        _mode = widget.initialMode;
        if (!widget.allowAll && _mode == ScheduleMode.all) {
          _mode = ScheduleMode.weeklyOnce;
        }
        _noSchedule = (_mode == ScheduleMode.all);
      });
    }
  }

  @override
  void dispose() {
    _dailyCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged?.call(
      ScheduleResult(
        mode: _mode,
        modeLabel: kModeLabels[_mode]!,
        weekdayNames: _noSchedule ? {} : {..._selectedNames},
        dailyNote: _noSchedule
            ? null
            : (_dailyCtrl.text.trim().isEmpty ? null : _dailyCtrl.text.trim()),
        monthlyDays: _noSchedule || _mode != ScheduleMode.monthlyCustom
            ? {}
            : {..._selectedMonthDays},
        dailyDate: _noSchedule ? null : _dailyDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Theme.of(context); // ไม่ได้ใช้งาน ลบทิ้งได้

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _modeBtn(kModeLabels[ScheduleMode.weeklyOnce]!,
                  ScheduleMode.weeklyOnce),
              _modeBtn(kModeLabels[ScheduleMode.dailyCustom]!,
                  ScheduleMode.dailyCustom),
              _modeBtn(kModeLabels[ScheduleMode.monthlyCustom]!,
                  ScheduleMode.monthlyCustom),
              if (widget.allowAll)
                _modeBtn(kModeLabels[ScheduleMode.all]!, ScheduleMode.all),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: () {
            switch (_mode) {
              case ScheduleMode.weeklyOnce:
                return _InfoBox(
                  key: const ValueKey('weekly'),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 5,
                    children: _thaiDayNames.map((name) {
                      final on = _selectedNames.contains(name);
                      return FilterChip(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: on ? Colors.white : Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        selected: on,
                        showCheckmark: false,
                        selectedColor: const Color(0xFF22A699),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: on
                                ? const Color(0xFF22A699)
                                : Colors.teal.shade200,
                          ),
                        ),
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              _selectedNames.add(name);
                            } else {
                              _selectedNames.remove(name);
                            }
                          });
                          _emit();
                        },
                      );
                    }).toList(),
                  ),
                );

              case ScheduleMode.dailyCustom:
                return _InfoBox(
                  key: const ValueKey('dailyCustom'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ช่องกรอกจำนวนวัน (ของเดิม)
                      textField1(
                        'กรอกจำนวนวัน',
                        controller: _dailyCtrl,
                        onChanged: (_) => _emit(),
                      ),
                      const SizedBox(height: 10),

                      textFieldCalendar(
                        'เลือกวันที่เริ่มต้น',
                        controller: _dailyDateCtrl,
                        readOnly: true,
                        onTap: _pickDailyDate,
                        trailingIcon: const Icon(Icons.calendar_month,
                            color: Color(0xFF22A699)),
                        onTrailingTap: _pickDailyDate,
                        showClear: true,
                        onClear: () {
                          _dailyDate = null;
                          _emit();
                        },
                      )
                    ],
                  ),
                );

              case ScheduleMode.monthlyCustom:
                return _InfoBox(
                  key: const ValueKey('monthly'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(context, 'ไม่กำหนด', color: Colors.teal),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(31, (i) {
                          final day = i + 1; // 1..31
                          final on = _selectedMonthDays.contains(day);
                          return FilterChip(
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: on ? Colors.white : Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            selected: on,
                            showCheckmark: false,
                            selectedColor: const Color(0xFF22A699),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: on
                                    ? const Color(0xFF22A699)
                                    : Colors.teal.shade200,
                              ),
                            ),
                            onSelected: (v) {
                              setState(() {
                                if (v) {
                                  _selectedMonthDays.add(day);
                                } else {
                                  _selectedMonthDays.remove(day);
                                }
                              });
                              _emit();
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                );
              case ScheduleMode.all:
                return const SizedBox.shrink();
            }
          }(),
        ),
      ],
    );
  }

  Widget _modeBtn(String label, ScheduleMode mode) {
    final bool isActive = (_mode == mode);
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: text(
          context,
          label,
          color: isActive ? Colors.white : Colors.teal.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isActive,
      backgroundColor: Colors.teal.shade50,
      selectedColor: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isActive ? Colors.teal : Colors.teal.shade200,
          width: 1.0,
        ),
      ),
      onSelected: (_) {
        if (!widget.allowAll && mode == ScheduleMode.all) return;
        setState(() {
          _mode = mode;

          if (mode == ScheduleMode.all) {
            _noSchedule = true; // 👈 เข้าสถานะไม่กำหนด
            _selectedNames.clear();
            _selectedMonthDays.clear();
            _dailyCtrl.clear();
            _dailyDate = null;
            widget.onNoSchedule?.call();
          } else {
            _noSchedule = false;
          }
        });
        _emit();
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    Key? key,
    required this.child,
    this.icon,
  }) : super(key: key);
  final Widget child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D8F1)),
      ),
      child: child,
    );
  }
}

// --------- HELPERS (serialize) ----------
String typeSlotFromMode(ScheduleMode m) {
  switch (m) {
    case ScheduleMode.weeklyOnce:
      return 'weekly';
    case ScheduleMode.dailyCustom:
      return 'daily';
    case ScheduleMode.monthlyCustom:
      return 'monthly';
    case ScheduleMode.all:
      return 'all';
  }
}

String encodeWeeklyDays(Set<String> days) {
  const mapThaiToEng = {
    'จันทร์': 'Mon',
    'อังคาร': 'Tue',
    'พุธ': 'Wed',
    'พฤหัสบดี': 'Thu',
    'ศุกร์': 'Fri',
    'เสาร์': 'Sat',
    'อาทิตย์': 'Sun',
  };
  const orderedThaiDays = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์'
  ];
  final sorted = orderedThaiDays.where(days.contains).toList();
  final engDays = sorted.map((d) => mapThaiToEng[d]!).toList();
  return "[${engDays.map((d) => "'$d'").join(',')}]";
}

String encodeWeeklyDayNumbers(Set<String> days) {
  const mapDayToNum = {
    'จันทร์': 1,
    'อังคาร': 2,
    'พุธ': 3,
    'พฤหัสบดี': 4,
    'ศุกร์': 5,
    'เสาร์': 6,
    'อาทิตย์': 7
  };
  final ordered = const [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์'
  ].where(days.contains).map((d) => mapDayToNum[d]!).toList();
  return "[${ordered.join(',')}]";
}

String buildSetSlot(ScheduleResult? s, {bool weeklyAsNumber = false}) {
  if (s == null) return '';
  switch (s.mode) {
    case ScheduleMode.weeklyOnce:
      return weeklyAsNumber
          ? encodeWeeklyDayNumbers(s.weekdayNames)
          : encodeWeeklyDays(s.weekdayNames);

    case ScheduleMode.dailyCustom:
      return (s.dailyNote ?? '').trim();

    case ScheduleMode.monthlyCustom:
      final days = s.monthlyDays.toList()..sort();
      if (days.isEmpty) return '';
      return "[${days.map((d) => "'$d'").join(',')}]";

    case ScheduleMode.all:
      return '';
  }
}
