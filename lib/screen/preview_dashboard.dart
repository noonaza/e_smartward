// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:e_smartward/api/dashboard_api.dart';
import 'package:e_smartward/widget/board_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_smartward/widget/board_detail.dart';
import 'package:e_smartward/widget/colors_board.dart';
import 'package:e_smartward/Model/list_pet_model.dart';

enum PetStatus { missedMeal, eating, done }

ColorTone ColorsStatus(PetStatus s) => switch (s) {
      PetStatus.missedMeal => ColorTone.yellow,
      PetStatus.eating => ColorTone.blue,
      PetStatus.done => ColorTone.green,
    };

class PetRow {
  final ListPetModel pet;
  final PetStatus status;
  PetRow({required this.pet, required this.status});
}

class PreviewDashboard extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  final List<String> petNames;

  PreviewDashboard({
    super.key,
    required this.lDataCard,
    required this.petNames,
  });

  @override
  State<PreviewDashboard> createState() => _PreviewDashboardState();
}

class _PreviewDashboardState extends State<PreviewDashboard> {
  late Timer _clockTimer;
  late Timer _refreshTimer;
  DateTime _now = DateTime.now();
  List<PetRow> _rows = [];

  @override
  void initState() {
    // _loadNotes();
    super.initState();

    _startTimers();
    _reload();
  }

  void _startTimers() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (!mounted) return;
      await _reload();
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _refreshTimer.cancel();
    super.dispose();
  }

  Future<List<PetRow>> ApiMoc({
    int yellow = 10,
    int blue = 12,
    int green = 12,
  }) async {
    final total = yellow + blue + green;

    final names = _basePetNames(total);

    String bed(int i) => (i + 1).toString().padLeft(2, '0');

    final rows = <PetRow>[];
    int idx = 0;

    for (var i = 0; i < yellow; i++, idx++) {
      rows.add(PetRow(
        pet: ListPetModel(bed_number: bed(idx), pet_name: names[idx]),
        status: PetStatus.missedMeal,
      ));
    }
    for (var i = 0; i < blue; i++, idx++) {
      rows.add(PetRow(
        pet: ListPetModel(bed_number: bed(idx), pet_name: names[idx]),
        status: PetStatus.eating,
      ));
    }
    for (var i = 0; i < green; i++, idx++) {
      rows.add(PetRow(
        pet: ListPetModel(bed_number: bed(idx), pet_name: names[idx]),
        status: PetStatus.done,
      ));
    }

    return rows;
  }

  List<String> _basePetNames(int count) {
    const baseNames = [
      'โอโม่',
      'มะลิ',
      'ข้าวปั้น',
      'เจ้าขาว',
      'ดำดอท',
      'โกโก้',
      'มะพร้าว',
      'บัตเตอร์',
      'ชาเขียว',
      'ซันเดย์',
      'โซดา',
      'น้ำผึ้ง',
      'ลาเต้',
      'คาปู',
      'โอริโอ้',
      'บราวนี่',
      'พุดดิ้ง',
      'ฟูฟู',
      'ชิพ',
      'งาขาว',
      'งาดำ',
      'คิตตี้',
      'นัตโตะ',
      'คาราเมล',
      'ปิงปิง',
      'ปังปอน',
      'ลักกี้',
      'เฉาก๋วย',
    ];

    final out = <String>[];
    for (final n in baseNames) {
      out.add(n);
      if (out.length >= count) return out;
    }
    while (out.length < count) {
      out.add('เพื่อนใหม่ ${out.length + 1}');
    }
    return out;
  }

  Future<void> _reload() async {
    final rows = await ApiMoc(yellow: 4, blue: 12, green: 8);
    if (!mounted) return;
    setState(() => _rows = rows);
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
    if (w >= 1250) return 6;
    if (w >= 1000) return 5;
    if (w >= 800) return 4;
    return 3;
  }

  List<DataCard> _buildCards() {
    final items = <({String bedCode, String name, ColorTone tone})>[];
    String norm(String? s) => (s ?? '').trim();

    for (final r in _rows) {
      final bedNum = norm(r.pet.bed_number?.toString());
      final bedCode = bedNum.isEmpty ? '-' : 'R9-BOARD-G-M-$bedNum';
      final nameRaw = norm(r.pet.pet_name);
      final name = nameRaw.isEmpty ? 'ไม่ทราบชื่อ' : nameRaw; // ไม่ uniq()
      final tone = ColorsStatus(r.status);
      items.add((bedCode: bedCode, name: name, tone: tone));
    }
    const owners = [
      'คุณอรอนงค์',
      'คุณวีรพล',
      'คุณอัจฉรา',
      'คุณณัฐพล',
      'คุณวิภา',
      'คุณพิมพ์ชนก',
      'คุณจิรายุ',
      'คุณมณีรัตน์',
      'คุณศิริชัย',
      'คุณปรัชญา',
    ];

    List<Widget> imagesCard(ColorTone t) => switch (t) {
          ColorTone.yellow => [
              Image.asset('assets/images/drug.png', width: 20, height: 20),
              Image.asset('assets/images/oh.png', width: 20, height: 20),
              Image.asset('assets/images/dc.png', width: 20, height: 20),
            ],
          ColorTone.blue => [
              Image.asset('assets/images/note.png', width: 25, height: 25),
              Image.asset('assets/images/6.png', width: 25, height: 25),
              Image.asset('assets/images/dc.png', width: 25, height: 25),
            ],
          ColorTone.green => [],
        };

    final cards = <DataCard>[];
    for (var i = 0; i < items.length; i++) {
      final e = items[i];
      final hn = 'HN${(100000 + i).toString()}';
      final owner = owners[i % owners.length];

      cards.add(DataCard(
        petNames: [e.name],
        ownerName: owner,
        hn: hn,
        tone: e.tone,
        cornerIcons: imagesCard(e.tone),
        petType: '',
      ));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    const double sideStripW = 13.0;

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

    final bigH = w >= 1500 ? 170.0 : 350.0;
    final smallH = w >= 1500 ? 120.0 : 300.0;
    final bigAspect = itemWidth / bigH;
    final smallAspect = itemWidth / smallH;

    SliverPadding CardList(List<DataCard> list, double aspect,
        {double top = 0}) {
      return SliverPadding(
        padding: EdgeInsets.only(top: top, left: 12, right: 12, bottom: 10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            childAspectRatio: aspect,
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
                      'iCare Dashboard',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: .3),
                    ),
                    const Spacer(),
                    const Text(
                      'สาขาพระราม 9  -  ห้องไอซียู',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(_now),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    if (yellow.isNotEmpty) CardList(yellow, bigAspect),
                    if (blue.isNotEmpty) CardList(blue, bigAspect, top: 20),
                    if (green.isNotEmpty) CardList(green, smallAspect, top: 20),
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
}
