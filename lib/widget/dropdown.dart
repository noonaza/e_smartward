import 'package:e_smartward/Model/site_model.dart';
import 'package:e_smartward/Model/ward_model.dart';
import 'package:flutter/material.dart';
import '../Model/list_food_model.dart';
import '../api/manage_food_api.dart';
import 'text.dart';

class GroupDropdown extends StatefulWidget {
  final Map<String, String> headers_;
  final Function(String) onSelected;
  const GroupDropdown(
      {super.key, required this.headers_, required this.onSelected});

  @override
  State<GroupDropdown> createState() => _GroupDropdownState();
}

class _GroupDropdownState extends State<GroupDropdown> {
  List<ListFoodModel> groupCodes = [];
  ListFoodModel? selectedCode;

  @override
  void initState() {
    super.initState();
    ManageFoodApi()
        .loadGroupCodeList(context, headers_: widget.headers_)
        .then((codes) {
      setState(() {
        groupCodes = codes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ListFoodModel>(
      hint: text(context, "เลือกกลุ่มเตียง"),
      value: selectedCode,
      isExpanded: true,
      underline: const SizedBox(),
      items: groupCodes.map((group) {
        return DropdownMenuItem<ListFoodModel>(
          value: group,
          child: Row(
            children: [
              const Icon(Icons.local_hotel, color: Colors.teal, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: text(
                  context,
                  group.item_name!,
                  color: Colors.teal,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (group) {
        setState(() {
          selectedCode = group;
        });

        widget.onSelected(group!.id.toString());
      },
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
    );
  }
}

class SiteDropdown extends StatefulWidget {
  final Map<String, String> headers_;
  final Function(String) onSelected;
  final String? initialSiteCode;

  const SiteDropdown({
    super.key,
    required this.headers_,
    required this.onSelected,
    this.initialSiteCode,
  });

  @override
  State<SiteDropdown> createState() => _SiteDropdownState();
}

class _SiteDropdownState extends State<SiteDropdown> {
  List<SiteModel> groupSite = [];
  SiteModel? selectedSite;

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    final sites =
        await ManageFoodApi().loadSite(context, headers_: widget.headers_);
    SiteModel? defaultSite;

    if (widget.initialSiteCode != null &&
        widget.initialSiteCode!.trim().isNotEmpty) {
      final code = widget.initialSiteCode!.trim().toLowerCase();
      // เลือกคีย์ให้ถูกกับโมเดลคุณ: code_name หรือ code
      defaultSite = sites.cast<SiteModel?>().firstWhere(
            (s) => (s?.code_name ?? '').toLowerCase() == code,
            orElse: () => null,
          );
    }

    setState(() {
      groupSite = sites;
      selectedSite = defaultSite; // 👈 เซ็ต default ที่นี่
    });

    // ถ้าอยากให้ callback ทำงานทันทีเมื่อมี default
    if (defaultSite != null) {
      // รอให้ widget build รอบนี้เสร็จก่อนค่อย callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelected(defaultSite!.code_name!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SiteModel>(
      hint: text(context, "เลือก Site"),
      value: selectedSite,
      isExpanded: true,
      underline: const SizedBox(),
      items: groupSite.map((site) {
        return DropdownMenuItem<SiteModel>(
          value: site,
          child: Row(
            children: [
              const Icon(Icons.place, color: Colors.teal, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: text(
                  context,
                  site.name ?? '',
                  color: Colors.teal,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (site) {
        if (site != null) {
          setState(() => selectedSite = site);
          widget.onSelected(site.code_name!);
        }
      },
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
    );
  }
}

class WardDropdown extends StatefulWidget {
  final Map<String, String> headers_;
  final String? selectedSiteCode;
  final Function(String) onSelected;

  const WardDropdown({
    super.key,
    required this.headers_,
    required this.onSelected,
    this.selectedSiteCode,
  });

  @override
  State<WardDropdown> createState() => _WardDropdownState();
}

class _WardDropdownState extends State<WardDropdown> {
  List<WardModel> groupWard = [];
  WardModel? selectedWard;

  @override
  void initState() {
    super.initState();
    if ((widget.selectedSiteCode ?? '').isNotEmpty) {
      _loadWardData();
    }
  }

  @override
  void didUpdateWidget(covariant WardDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSiteCode != oldWidget.selectedSiteCode &&
        (widget.selectedSiteCode ?? '').isNotEmpty) {
      _loadWardData();
    }
  }
  // void didUpdateWidget(covariant WardDropdown oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.selectedSiteCode != oldWidget.selectedSiteCode) {
  //     _loadWardData();
  //   }
  // }

  void _loadWardData() async {
    if (widget.selectedSiteCode != null) {
      final ward = await ManageFoodApi().loadDataWard(
        context,
        headers_: widget.headers_,
        siteCode: widget.selectedSiteCode!,
      );
      setState(() {
        groupWard = ward;
        selectedWard = null;
      });
    } else {
      setState(() {
        groupWard = [];
        selectedWard = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<WardModel>(
      hint: text(context, 'เลือก Ward'),
      value: selectedWard,
      isExpanded: true,
      underline: const SizedBox(),
      items: groupWard.map((ward) {
        return DropdownMenuItem<WardModel>(
          value: ward,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.meeting_room, color: Colors.teal, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: text(
                  context,
                  ward.ward!,
                  color: Colors.teal,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (WardModel? newValue) {
        setState(() {
          selectedWard = newValue;
        });
        if (newValue != null) {
          widget.onSelected(newValue.ward!);
        }
      },
    );
  }
}
