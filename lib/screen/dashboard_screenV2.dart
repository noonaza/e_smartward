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
import 'dart:math' as math;
import 'package:video_player/video_player.dart';

class DashboardScreenV2 extends StatefulWidget {
  final List<Map<String, dynamic>> lDataCard;
  final List<String> petNames;

  const DashboardScreenV2({
    super.key,
    required this.lDataCard,
    required this.petNames,
  });

  @override
  State<DashboardScreenV2> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreenV2> {
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
        String foodIcon = 'assets/images/6.png';

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
        images: '',
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

    _columnsForWidth(w);
    final cards = _buildCards();
    final yellow = cards.where((c) => c.tone == ColorTone.yellow).toList();
    final blue = cards.where((c) => c.tone == ColorTone.blue).toList();
    final green = cards.where((c) => c.tone == ColorTone.green).toList();

//! การ์ดสีฟ้าเหลือง
//! การ์ดสีเขียว

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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ======= Header =======
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
                          offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
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
                            fontSize: 20),
                      ),
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
                          fontSize: 14),
                    ),
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final totalW = constraints.maxWidth;
                          final showSidebar = totalW >= 1100;
                          final showSidebarh = totalW >= 1100;
                          final sideWidth = showSidebar
                              ? math.min(700.0, totalW * 0.25)
                              : 0.0;

                          return Row(
                            children: [
                              const SizedBox(width: 12),

                              // ===== ฝั่งซ้าย (การ์ด) =====
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, innerConstraints) {
                                    final innerW = innerConstraints.maxWidth;
                                    final targetTileW =
                                        innerW >= 1200 ? 360.0 : 340.0;
                                    const bigH = 140.0;
                                    const smallH = 100.0;
                                    final bigAspect = targetTileW / bigH;
                                    final smallAspect = targetTileW / smallH;

                                    SliverPadding CardList(
                                        List<DataCard> list, double aspect,
                                        {double top = 0}) {
                                      return SliverPadding(
                                        padding: EdgeInsets.only(
                                            top: top,
                                            left: 12,
                                            right: 12,
                                            bottom: 10),
                                        sliver: SliverGrid(
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: targetTileW,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 15,
                                            childAspectRatio: aspect,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                            (context, i) =>
                                                BoardDetail(data: list[i]),
                                            childCount: list.length,
                                          ),
                                        ),
                                      );
                                    }

                                    return CustomScrollView(
                                      slivers: [
                                        if (yellow.isNotEmpty)
                                          CardList(yellow.toList(), bigAspect),
                                        if (blue.isNotEmpty)
                                          CardList(blue.toList(), bigAspect,
                                              top: 15),
                                        if (green.isNotEmpty)
                                          CardList(green.toList(), smallAspect,
                                              top: 15),
                                        const SliverToBoxAdapter(
                                            child: SizedBox(height: 12)),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              // ===== ฝั่งขวา =====
                              if (showSidebar & showSidebarh)
                                SizedBox(
                                  width: sideWidth,
                                  child: const _RightColumn(),
                                ),
                            ],
                          );
                        },
                      ),
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
                        const Spacer(),
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
                ),
              ],
            ),
          ),
        ],
      ),
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

class HeartRateVideoOrMockup extends StatefulWidget {
  final String? assetPath;
  final String? videoUrl;
  final double aspect;
  const HeartRateVideoOrMockup({
    super.key,
    this.assetPath,
    this.videoUrl,
    this.aspect = 10 / 9,
  });

  @override
  State<HeartRateVideoOrMockup> createState() => _HeartRateVideoOrMockupState();
}

class _HeartRateVideoOrMockupState extends State<HeartRateVideoOrMockup>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _vc;

  // สำหรับ mockup
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();

    if (widget.assetPath != null || widget.videoUrl != null) {
      if (widget.assetPath != null) {
        _vc = VideoPlayerController.asset(widget.assetPath!);
      } else {
        _vc = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      }
      _vc!.setLooping(true);
      _vc!.initialize().then((_) {
        if (mounted) setState(() {});
        _vc!.play();
      });
    }

    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
  }

  @override
  void dispose() {
    _vc?.dispose();
    _ac.dispose();
    super.dispose();
  }

  bool get _hasVideo => _vc != null && _vc!.value.isInitialized;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspect,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          color: Colors.black,
          child: _hasVideo
              ? Stack(
                  children: [
                    Center(child: VideoPlayer(_vc!)),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 10,
                      child: _BpmBadge(animation: _ac),
                    ),
                  ],
                )
              : _HeartRateMockGraph(animation: _ac),
        ),
      ),
    );
  }
}

class _BpmBadge extends StatelessWidget {
  final Animation<double> animation;
  const _BpmBadge({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final bpm = 82 + (math.sin(animation.value * 2 * math.pi) * 4).round();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$bpm bpm',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        );
      },
    );
  }
}

class _HeartRateMockGraph extends StatelessWidget {
  final Animation<double> animation;
  const _HeartRateMockGraph({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: animation,
            builder: (_, __) =>
                CustomPaint(painter: _EcgPainter(t: animation.value)),
          ),
        ),
        Positioned(right: 12, top: 10, child: _BpmBadge(animation: animation)),
        Positioned(
          left: 12,
          top: 10,
          child: Row(
            children: const [
              Icon(Icons.favorite, color: Colors.redAccent),
              SizedBox(width: 6),
              Text('Heart Rate',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}

class _EcgPainter extends CustomPainter {
  final double t;
  _EcgPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final wave = Path();
    final baseY = size.height * 0.5;
    final amp = size.height * 0.22;
    final speed = size.width * (t);

    for (double x = 0; x <= size.width; x += 2) {
      final phase = (x + speed) / size.width * 2 * math.pi;
      double y = baseY + math.sin(phase * 1.2) * (amp * .25);

      final period = size.width * 0.10;
      final dist = ((x + speed) % period);
      if (dist < 6) {
        // QRS สูง
        final spike = (1 - (dist / 6)) * amp;
        y = baseY - spike;
      } else if (dist < 18) {
        y = baseY + (amp * 0.12);
      }

      if (x == 0) {
        wave.moveTo(x, y);
      } else {
        wave.lineTo(x, y);
      }
    }

    final glow = Paint()
      ..color = Colors.greenAccent.withOpacity(.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    final stroke = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(wave, glow);
    canvas.drawPath(wave, stroke);
  }

  @override
  bool shouldRepaint(covariant _EcgPainter oldDelegate) => oldDelegate.t != t;
}

class _TileHeader extends StatelessWidget {
  final String label;
  final Color colorDot;
  const _TileHeader({required this.label, required this.colorDot});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: colorDot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const Spacer(),
        const Icon(Icons.edit_outlined, size: 18, color: Colors.black54),
      ],
    );
  }
}

// ignore: unused_element
class _TileFrame extends StatelessWidget {
  final Color color;

  final Widget child;
  const _TileFrame({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        _SensorCard(
          label: 'นาน่า',
          color: Color(0xFFFFD6D1),
          colorDot: Colors.red,
          bpm: 209,
          spO2: 99,
          animalTemp: 29.5,
          roomTemp: 27.7,
          co2: 789,
          humid: 52.3,
          motion: 0,
          pm10: 11,
          pm25: 10,
          showCamera: true,
          showGraph: true,
        ),
        SizedBox(height: 10),
        _SensorCard(
          label: 'ดันเต้',
          color: Color(0xFFD5ECFA),
          colorDot: Colors.blue,
          bpm: 209,
          spO2: 99,
          animalTemp: 29.5,
          roomTemp: 27.7,
          co2: 789,
          humid: 52.3,
          motion: 0,
          pm10: 11,
          pm25: 10,
          showCamera: true,
          showGraph: true,
        ),
        SizedBox(height: 10),
        _SensorCard(
          label: 'จีจี้',
          color: Color(0xFFD5ECFA),
          colorDot: Colors.blue,
          bpm: 209,
          spO2: 99,
          animalTemp: 29.5,
          roomTemp: 27.7,
          co2: 789,
          humid: 52.3,
          motion: 0,
          pm10: 11,
          pm25: 10,
          showCamera: true,
          showGraph: true,
        ),
        SizedBox(height: 10),
        _SensorCard(
          label: 'มาร์ตี้',
          color: Color(0xFFD5ECFA),
          colorDot: Colors.blue,
          bpm: 209,
          spO2: 99,
          animalTemp: 29.5,
          roomTemp: 27.7,
          co2: 789,
          humid: 52.3,
          motion: 0,
          pm10: 11,
          pm25: 10,
          showCamera: true,
          showGraph: true,
        ),
      ],
    );
  }
}

class _SensorCard extends StatelessWidget {
  final String label;
  final Color color;
  final Color colorDot;

  final num? bpm, spO2, animalTemp, roomTemp, co2, humid, motion, pm10, pm25;
  final bool showCamera, showGraph;

  const _SensorCard({
    required this.label,
    required this.color,
    required this.colorDot,
    this.bpm,
    this.spO2,
    this.animalTemp,
    this.roomTemp,
    this.co2,
    this.humid,
    this.motion,
    this.pm10,
    this.pm25,
    this.showCamera = false,
    this.showGraph = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TileHeader(label: label, colorDot: colorDot),
            const SizedBox(height: 5),
            LayoutBuilder(
              builder: (context, c) {
                const leftW = 160.0;
                const mediaH = 230.0;

                final infoBox = Container(
                  width: leftW,
                  height: mediaH,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _info('BPM', bpm),
                        _info('BP', null, suffix: 'mmHg'),
                        _info('SpO₂', spO2, suffix: '%'),
                        _info('Animal', animalTemp, suffix: '°C'),
                        _info('Room', roomTemp, suffix: '°C'),
                        _info('CO₂', co2, suffix: 'ppm'),
                        _info('Humid', humid, suffix: '%'),
                        _info('Motion', motion, suffix: 'sec.'),
                        _info('PM10', pm10, suffix: 'µg/m³'),
                        _info('PM2.5', pm25, suffix: 'µg/m³'),
                      ],
                    ),
                  ),
                );

                final mediaColumn = SizedBox(
                  height: mediaH,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                            height: 110,
                            width: double.infinity,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: Image.asset("assets/images/dashdog.png")),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          height: 110,
                          width: double.infinity,
                          child: HeartRateVideoOrMockup(aspect: 10 / 9),
                        ),
                      ),
                    ],
                  ),
                );

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoBox,
                    const SizedBox(width: 8),
                    Expanded(child: mediaColumn),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, num? value, {String suffix = ''}) {
    return SizedBox(
      width: 250,
      child: Text(
        '$label: ${value != null ? value.toStringAsFixed(1) + suffix : '-'}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
