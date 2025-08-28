// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:e_smartward/Model/dashboard_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/api/dashboard_api.dart';
import 'package:e_smartward/widget/board_data.dart';
import 'package:e_smartward/widget/board_detail.dart';
import 'package:e_smartward/widget/colors_board.dart';
import 'package:e_smartward/widget/dropdown_db.dart';
import 'package:e_smartward/widget/text.dart';

class DashboardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  final List<String> petNames;

  DashboardScreen({
    super.key,
    required this.lDataCard,
    required this.petNames,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _clockTimer;
  late Timer _refreshTimer;
  DateTime _now = DateTime.now();
  List<PetRow> _rows = [];
  String? selectedSite;
  String? selectedWard;
  bool showCard = false;

  bool get _isReady =>
      (selectedSite?.isNotEmpty ?? false) &&
      (selectedWard?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _refreshTimer.cancel();
    super.dispose();
  }

  Future<void> _reload() async {
    if (!_isReady) {
      if (mounted) setState(() => _rows = []);
      return;
    }

    final list = await DashboardApi().loadDataDashboard(
      context,
      siteCode: selectedSite!,
      ward: selectedWard!,
    );

    final rows = list
        .map((m) => PetRow(
              pet: ListPetModel(
                bed_number: (m.ibed_number)!.isEmpty ? null : (m.ibed_number),
                pet_name:
                    (m.ipet_name)!.isEmpty ? 'ไม่ทราบชื่อ' : (m.ipet_name),
                owner_name: (m.iowner_name),
                hn_number: (m.hn_number),
                pet_type: (m.ipet_type),
              ),
              status: _status(m),
              toDoFood: m.to_do_food ?? 0,
              toDoDrug: m.to_do_drug ?? 0,
              toDoiDrug: m.to_do_idrug ?? 0,
            ))
        .toList();

    if (!mounted) return;
    setState(() => _rows = rows);
  }

  ColorTone _status(DashboardModel m) {
    final s = (m.status_now ?? m.status_now_slot)!.toLowerCase();

    if (s.contains('danger')) {
      return ColorTone.yellow;
    } else if (s.contains('warning')) {
      return ColorTone.blue;
    } else if (s.contains('success')) {
      return ColorTone.green;
    }
    return ColorTone.green;
  }

  String _formatDate(DateTime dt) {
    final d = DateFormat('dd').format(dt);
    final m = DateFormat('MM').format(dt);
    final y = DateFormat('yyyy').format(dt);
    final hm = DateFormat('HH:mm').format(dt);
    return 'วันที่ $d - $m - $y  เวลา $hm น.';
  }

  int _columnsForWidth(double w) {
    if (w >= 2300) return 8;
    if (w >= 1250) return 7;
    if (w >= 1000) return 5;
    if (w >= 800) return 4;
    return 3;
  }

  List<DataCard> _buildCards() {
    List<Widget> images(
      ColorTone t, {
      int toDoFood = 0,
      int toDoDrug = 0,
      int toDoiDrug = 0,
    }) {
      final result = <Widget>[];

      if (toDoFood > 0) {
        String foodIcon = 'assets/images/6.png'; // default

        if (t == ColorTone.blue) {
          foodIcon = 'assets/images/6.png';
        } else if (t == ColorTone.yellow) {
          foodIcon = 'assets/images/oh.png';
        }
        result.add(
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(foodIcon, fit: BoxFit.contain),
          ),
        );
      }

      if (toDoDrug > 0) {
        result.add(
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset('assets/images/drug.png', fit: BoxFit.contain),
          ),
        );
      }

      if (toDoiDrug > 0) {
        result.add(
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset('assets/images/dc.png', fit: BoxFit.contain),
          ),
        );
      }

      return result;
    }

    return _rows.map((r) {
      final name =
          (r.pet.pet_name ?? '').isEmpty ? 'ไม่ทราบชื่อ' : r.pet.pet_name!;
      final owner = (r.pet.owner_name ?? '').isEmpty ? '-' : r.pet.owner_name!;
      final hn = (r.pet.hn_number ?? '').isEmpty ? '-' : r.pet.hn_number!;
      final petType = (r.pet.pet_type)!.isEmpty ? '-' : (r.pet.pet_type);
      final tone = r.status;

      return DataCard(
        petNames: [name],
        petType: petType,
        ownerName: owner,
        hn: hn,
        tone: tone,
        cornerIcons: images(tone,
            toDoFood: r.toDoFood, toDoDrug: r.toDoDrug, toDoiDrug: r.toDoiDrug),
      );
    }).toList();
  }

  String refreshText = "ยังไม่ได้รีเฟรช";

  void _startTimers() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });

    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (!mounted) return;

      if (_isReady && showCard) {
        await _reload();

        setState(() {
          refreshText =
              "รีเฟรชล่าสุด: ${DateFormat('HH:mm:ss').format(DateTime.now())}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    const double sideStripW = 16.0;

    final cols = _columnsForWidth(w);
    final cards = _buildCards();
    final yellow = cards.where((c) => c.tone == ColorTone.yellow).toList();
    final blue = cards.where((c) => c.tone == ColorTone.blue).toList();
    final green = cards.where((c) => c.tone == ColorTone.green).toList();

    const horizontalPad = 12.0;
    const crossSpacing = 12.0;

    final contentW = w - (sideStripW * 1);
    final gridUsableWidth = contentW - (horizontalPad * 2);
    final totalCrossSpacing = crossSpacing * (cols - 1);
    final itemWidth = (gridUsableWidth - totalCrossSpacing) / cols;

    final bigH = w >= 1250 ? 120.0 : 350.0; //! การ์ดสีฟ้าเหลือง
    final smallH = w >= 1250 ? 100.0 : 300.0; //! การ์ดสีเขียว
    final bigAspect = itemWidth / bigH;
    final smallAspect = itemWidth / smallH;

    SliverPadding CardList(List<DataCard> list, double aspect,
        {double top = 0}) {
      final w = MediaQuery.of(context).size.width;
      final cols = _columnsForWidth(w);
      return SliverPadding(
        padding: EdgeInsets.only(top: top, left: 12, right: 12, bottom: 10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            childAspectRatio: aspect * 0.985,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, i) => BoardDetail(data: list[i]),
            childCount: list.length,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_login.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 221, 253, 255).withOpacity(0.9),
                const Color.fromARGB(255, 204, 239, 245).withOpacity(0.9),
                const Color.fromARGB(255, 212, 233, 238).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Container(color: Colors.white.withOpacity(0.7)),
        SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 55, 148, 177),
                      Color.fromARGB(255, 137, 218, 235),
                      Color.fromARGB(255, 174, 219, 228),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/icons/logo01.png',
                          width: 30, height: 30),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Thonglor iCare Dashboard',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: .3),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: SelectWardDialog,
                      child: Text(
                        _isReady
                            ? '${selectedSite!}  -  ${selectedWard!}'
                            : 'กดเพื่อเลือก Site/Ward',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(_now),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    refreshText,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    if (yellow.isNotEmpty) CardList(yellow, bigAspect),
                    if (blue.isNotEmpty) CardList(blue, bigAspect, top: 15),
                    if (green.isNotEmpty) CardList(green, smallAspect, top: 15),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: Image.asset('assets/icons/logo02.png',
                            fit: BoxFit.cover),
                      ),
                      Spacer(),
                      Text(
                        'Confidential Information',
                        style: TextStyle(
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  void SelectWardDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.place, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "เลือก Site และ Ward",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Site
                    Row(
                      children: [
                        text(context, 'Site : ',
                            color: Colors.teal,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: DbSiteDropdown(
                              onSelected: (siteCodeName) {
                                setState(() {
                                  selectedSite = siteCodeName;
                                  selectedWard = null;
                                  showCard = false;
                                });
                                setStateDialog(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        text(context, 'Ward : ',
                            color: Colors.teal,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: DbWardDropdown(
                              selectedSiteCode: selectedSite,
                              onSelected: (ward) {
                                setState(() {
                                  selectedWard = ward;
                                  showCard = false;
                                });
                                setStateDialog(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("ยกเลิก"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text("ยืนยัน"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (_isReady) {
                              setState(() => showCard = true);
                              Navigator.pop(ctx);
                              await _reload();
                            }
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class PetRow {
  final ListPetModel pet;
  final ColorTone status;
  final int toDoFood;
  final int toDoDrug;
  final int toDoiDrug;

  PetRow({
    required this.pet,
    required this.status,
    this.toDoFood = 0,
    required this.toDoDrug,
    this.toDoiDrug = 0,
  });
}
