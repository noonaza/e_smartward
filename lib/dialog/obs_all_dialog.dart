import 'dart:convert';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/dialog/create_obs_dialog_v2.dart';

import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ObsAllDialogV2 extends StatefulWidget {
  final Map<String, String> headers;

  const ObsAllDialogV2({
    Key? key,
    required this.headers,
  }) : super(key: key);

  @override
  State<ObsAllDialogV2> createState() => _ObsPickerMultiDialogState();

  static void show(
    BuildContext context, {
    required String screen,
    required Map<String, String> headers,
    required Function(GetObsModel) onAddObs,
    double? width,
    List<ListUserModel>? lUserLogin,
    List<ListPetModel>? lPetAdmit,
    List<ListAnModel>? lListAn,
    required Function() rwAddObs_,
    String? drugTypeName,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dialogWidth;

    if (screenWidth >= 1024) {
      dialogWidth = screenWidth * 0.5; // Desktop
    } else if (screenWidth >= 600) {
      dialogWidth = screenWidth * 0.9; // Tablet
    } else {
      dialogWidth = screenWidth * 0.9; // Mobile
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      width: dialogWidth,
      dismissOnTouchOutside: false,
      customHeader: Stack(
        children: [
          Image.asset(
            'assets/gif/index3.gif',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      body: CreateObsDialogV2(
        screen: screen,
        headers: headers,
        onAddObs: onAddObs,
        drugTypeName: drugTypeName,
        lUserLogin: lUserLogin,
        lPetAdmit: lPetAdmit,
        lListAn: lListAn,
        rwAddObs: rwAddObs_,
      ),
    ).show();
  }
}

class _ObsPickerMultiDialogState extends State<ObsAllDialogV2> {
  final Map<String, bool> _checkMap = {};
  final Map<String, ValueNotifier<bool>> _checkVN = {};
  final ValueNotifier<bool> _selectAllVN = ValueNotifier<bool>(false);
  final ValueNotifier<int> _version = ValueNotifier<int>(0);
  List<GetObsModel> lDataCardObs = [];

  Map<String, dynamic> _safeDecodeSetValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return {};
    try {
      final v = jsonDecode(raw);
      if (v is Map<String, dynamic>) return v;
      if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v));
    } catch (_) {}
    return {};
  }

  String _keyOf({
    required String setName,
    required String detail,
    required String level,
    required String col,
    required String takeTime,
    required String timeSlot,
  }) =>
      '$setName|$detail|$level|$col|$takeTime|$timeSlot';

  bool _areAllChecked() =>
      _checkMap.isNotEmpty && _checkMap.values.every((v) => v == true);

  void _applySelectAll(bool val) {
    for (final k in _checkMap.keys) {
      _checkMap[k] = val;
      _checkVN[k]?.value = val;
    }
    _selectAllVN.value = val;
    _version.value++;
  }

  void _recomputeSelectAllFlag() {
    _selectAllVN.value = _areAllChecked();
  }

  @override
  void dispose() {
    for (final vn in _checkVN.values) {
      vn.dispose();
    }
    _selectAllVN.dispose();
    _version.dispose();
    super.dispose();
  }

  void _openCreateDialog() {
    final parentContext = context; 

    CreateObsDialogV2.show(
      context,
      screen: 'admit',
      headers: widget.headers,
      rwAddObs_: () {},
      onAddObs: (GetObsModel obs) {
        Future.microtask(() {
          Navigator.of(parentContext).pop(<GetObsModel>[obs]);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(
            context,
            'เลือกรายการ',
            color: Colors.teal,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          TextButton(
            onPressed: () {
              final newVal = !_areAllChecked();
              _applySelectAll(newVal);
            },
            child: ValueListenableBuilder<bool>(
              valueListenable: _selectAllVN,
              builder: (_, all, __) => text(
                context,
                all ? 'ยกเลิกเลือกทั้งหมด' : 'เลือกทั้งหมด',
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 560,
        height: 560,
        child: FutureBuilder<List<GetObsModel>>(
          future: AdmitApi().GetObsAll(context, headers_: widget.headers),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return const Center(child: Text('ไม่พบข้อมูล'));
            }

            final Map<String, List<Map<String, String>>> grouped = {};
            for (final item in list) {
              final name = (item.set_name ?? '').trim();
              if (name.isEmpty) continue;

              final sv = _safeDecodeSetValue(item.set_value);
              final detail = (sv['detail'] ?? '').toString().trim();
              final level = (sv['level'] ?? '').toString().trim();
              final col = (sv['col'] ?? '').toString().trim();
              final takeTime = (item.take_time ?? '').toString();
              final timeSlot = (item.time_slot ?? '').toString();

              (grouped[name] ??= []).add({
                'detail': detail,
                'level': level,
                'col': col,
                'take_time': takeTime,
                'time_slot': timeSlot,
              });
            }

            final entries = grouped.entries.map((e) {
              final seen = <String>{};
              final uniq = <Map<String, String>>[];
              for (final m in e.value) {
                final key = '${m['detail']}|${m['level']}|${m['col']}';
                if (seen.add(key)) uniq.add(m);
              }
              return MapEntry(e.key, uniq);
            }).toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            if (_checkMap.isEmpty) {
              for (final entry in entries) {
                for (final m in entry.value) {
                  final key = _keyOf(
                    setName: entry.key,
                    detail: m['detail'] ?? '',
                    level: m['level'] ?? '',
                    col: m['col'] ?? '',
                    takeTime: m['take_time'] ?? '',
                    timeSlot: m['time_slot'] ?? '',
                  );
                  _checkMap.putIfAbsent(key, () => false);
                  _checkVN.putIfAbsent(key, () => ValueNotifier<bool>(false));
                }
              }
              final wantAll = _selectAllVN.value;
              for (final k in _checkMap.keys) {
                _checkMap[k] = wantAll;
                _checkVN[k]?.value = wantAll;
              }
            }

            return ListView.separated(
              itemCount: entries.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == entries.length) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: text(
                        context,
                        'อื่นๆ (สร้างใหม่)',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.teal[700],
                      ),
                      subtitle: const Text('เพิ่มสังเกตอาการแบบกำหนดเอง'),
                      trailing: FilledButton.tonalIcon(
                        icon: const Icon(Icons.add),
                        label: const Text('สร้างใหม่'),
                        onPressed: _openCreateDialog,
                      ),
                      onTap: _openCreateDialog,
                    ),
                  );
                }

                // แสดงแต่ละกลุ่ม
                final entry = entries[index];
                final setName = entry.key;
                final items = entry.value;

                bool allCheckedThisGroup() {
                  for (final m in items) {
                    final k = _keyOf(
                      setName: setName,
                      detail: m['detail'] ?? '',
                      level: m['level'] ?? '',
                      col: m['col'] ?? '',
                      takeTime: m['take_time'] ?? '',
                      timeSlot: m['time_slot'] ?? '',
                    );
                    if (!(_checkMap[k] ?? false)) return false;
                  }
                  return true;
                }

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/obs001.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              text(
                                context,
                                setName,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.teal[700],
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final newVal = !allCheckedThisGroup();
                            for (final m in items) {
                              final k = _keyOf(
                                setName: setName,
                                detail: m['detail'] ?? '',
                                level: m['level'] ?? '',
                                col: m['col'] ?? '',
                                takeTime: m['take_time'] ?? '',
                                timeSlot: m['time_slot'] ?? '',
                              );
                              _checkMap[k] = newVal;
                              _checkVN[k]?.value = newVal;
                            }
                            _recomputeSelectAllFlag();
                            _version.value++;
                          },
                          child: ValueListenableBuilder<int>(
                            valueListenable: _version,
                            builder: (_, __, ___) {
                              final all = allCheckedThisGroup();
                              return text(
                                context,
                                all ? 'ยกเลิกเลือกกลุ่มนี้' : 'เลือกกลุ่มนี้',
                                color: Colors.teal[300],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    children: [
                      const Divider(height: 1),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          indent: 12,
                          endIndent: 12,
                        ),
                        itemBuilder: (_, i) {
                          final m = items[i];
                          final detail = (m['detail'] ?? '').toString();
                          final level = (m['level'] ?? '').toString();
                          final col = (m['col'] ?? '').toString();
                          final takeTime = (m['take_time'] ?? '').toString();
                          final timeSlot = (m['time_slot'] ?? '').toString();

                          final key = _keyOf(
                            setName: setName,
                            detail: detail,
                            level: level,
                            col: col,
                            takeTime: takeTime,
                            timeSlot: timeSlot,
                          );

                          return ValueListenableBuilder<bool>(
                            valueListenable: _checkVN[key]!,
                            builder: (_, checked, __) {
                              return CheckboxListTile(
                                dense: true,
                                value: checked,
                                onChanged: (val) {
                                  if (val == null) return;
                                  _checkMap[key] = val;
                                  _checkVN[key]!.value = val;
                                  _recomputeSelectAllFlag();
                                  _version.value++;
                                },
                                title: text(
                                  context,
                                  detail.isEmpty ? '-' : detail,
                                ),
                                // subtitle: Text(
                                //   'Level: $level, Col: $col, Time: $takeTime',
                                //   style: const TextStyle(fontSize: 12),
                                // ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('ยกเลิก'),
        ),
        ValueListenableBuilder<int>(
          valueListenable: _version,
          builder: (_, __, ___) {
            final selectedCount = _checkMap.values.where((v) => v).length;
            return FilledButton(
              onPressed: selectedCount == 0
                  ? null
                  : () {
                      final result = <GetObsModel>[];
                      for (final entry in _checkMap.entries) {
                        if (!entry.value) continue;

                        final parts = entry.key.split('|');
                        if (parts.length < 6) continue;

                        final setName = parts[0];
                        final detail = parts[1];
                        final level = parts[2];
                        final col = parts[3];
                        final take = parts[4];
                        final slot = parts[5];

                        result.add(
                          GetObsModel(
                            set_name: setName,
                            set_value: jsonEncode({
                              'detail': detail,
                              'level': level,
                              'col': col,
                            }),
                            take_time: take,
                            time_slot: slot,
                            remark: '-',
                          ),
                        );
                      }
                      Navigator.pop(context, result);
                    },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'เพิ่มรายการ${selectedCount > 0 ? " ($selectedCount)" : ""}',
              ),
            );
          },
        ),
      ],
    );
  }
}
