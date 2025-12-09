import 'package:intl/intl.dart';

enum ScheduleMode { weeklyOnce, dailyCustom, monthlyCustom }

class ScheduleResult {
  final ScheduleMode mode;
  final Set<String> weekdayNames;
  final String? dailyNote;
  final DateTime? dailyDate;     // ใช้เมื่อ dailyCustom + ระบุวัน
  final Set<int> monthlyDays;

  const ScheduleResult({
    required this.mode,
    this.weekdayNames = const {},
    this.dailyNote,
    this.dailyDate,
    this.monthlyDays = const {},
  });
}

class ScheduleUtils {
  static const List<String> _thaiWeekdays = [
    'อาทิตย์','จันทร์','อังคาร','พุธ','พฤหัสบดี','ศุกร์','เสาร์',
  ];
  static const Map<String, String> _engToThai = {
    'SUN': 'อาทิตย์','MON': 'จันทร์','TUE': 'อังคาร','WED': 'พุธ',
    'THU': 'พฤหัสบดี','FRI': 'ศุกร์','SAT': 'เสาร์',
  };

  static String typeSlotFromMode(ScheduleMode m) {
    switch (m) {
      case ScheduleMode.weeklyOnce:   return 'DAYS';
      case ScheduleMode.dailyCustom:  return 'DATE';
      case ScheduleMode.monthlyCustom:return 'D_M';
    }
  }

  static DateTime buildStartDateFromSchedule(
    ScheduleResult? s, {
    String? orderDate,
    String? initialStart,
  }) {
    final now = DateTime.now();

    DateTime? init;
    if (initialStart != null && initialStart.isNotEmpty) {
      try { init = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(initialStart); } catch (_) {}
    }

    DateTime? order;
    if (orderDate != null && orderDate.isNotEmpty) {
      try { order = DateFormat('yyyy-MM-dd').parseStrict(orderDate); } catch (_) {
        try { order = DateFormat('dd/MM/yyyy').parseStrict(orderDate); } catch (_) {}
      }
    }

    if (s?.mode == ScheduleMode.dailyCustom && s?.dailyDate != null) {
      final d = s!.dailyDate!;
      return DateTime(d.year, d.month, d.day, now.hour, now.minute, now.second);
    }

    if (order != null) {
      return DateTime(order.year, order.month, order.day, now.hour, now.minute, now.second);
    }

    return init ?? now;
  }

  static bool _looksLikeList(String s) => s.trim().startsWith('[') && s.trim().endsWith(']');

  static List<String> _splitListLike(dynamic raw) {
    if (raw == null) return [];
    final s = raw.toString();
    final cleaned = s.replaceAll(RegExp(r"[{}\[\]\(\)']"), '').trim();
    if (cleaned.isEmpty) return [];
    return cleaned.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  static Set<String> parseWeeklyNames(String raw) {
    final t = raw.trim();

    if (_thaiWeekdays.any((d) => t.contains(d))) {
      return t.split(',').map((e) => e.trim()).toSet().intersection(_thaiWeekdays.toSet());
    }

    final items = _splitListLike(t);
    if (items.isNotEmpty && _engToThai.keys.toSet().contains(items.first.toUpperCase())) {
      return items.map((e) => _engToThai[e.toUpperCase()]!).toSet();
    }

    final nums = _splitListLike(t).map((e) => int.tryParse(e) ?? -999).where((n) => n >= 0).toList();
    if (nums.isNotEmpty) {
      if (nums.any((n) => n == 0 || n == 6)) {
        return nums.map((n) => _thaiWeekdays[n % 7]).toSet(); // 0=อาทิตย์..6=เสาร์
      }
      const order = ['จันทร์','อังคาร','พุธ','พฤหัสบดี','ศุกร์','เสาร์','อาทิตย์'];
      return nums.where((n) => n >= 1 && n <= 7).map((n) => order[n - 1]).toSet();
    }
    return {};
  }

  static Set<int> parseMonthlyDays(String raw) {
    return _splitListLike(raw)
        .map((e) => int.tryParse(e) ?? -1)
        .where((n) => n >= 1 && n <= 31)
        .toSet();
  }

  static ScheduleResult parseDrugSlot(String? setSlot, String? typeSlot) {
    final s = (setSlot ?? '').trim();
    final t = (typeSlot ?? '').trim().toUpperCase();

    if (s.isEmpty) {
      return const ScheduleResult(mode: ScheduleMode.weeklyOnce);
    }

    switch (t) {
      case 'DAYS':
      case 'WEEKLY':
        return ScheduleResult(
          mode: ScheduleMode.weeklyOnce,
          weekdayNames: parseWeeklyNames(s),
        );
      case 'DATE':
      case 'DAILY':
        return ScheduleResult(
          mode: ScheduleMode.dailyCustom,
          dailyNote: s,
        );
      case 'D_M':
      case 'MONTHLY':
        final days = parseMonthlyDays(_looksLikeList(s) ? s : '[$s]');
        return ScheduleResult(
          mode: ScheduleMode.monthlyCustom,
          monthlyDays: days,
        );
      default:
        return ScheduleResult(
          mode: ScheduleMode.weeklyOnce,
          weekdayNames: parseWeeklyNames(s),
        );
    }
  }
}
