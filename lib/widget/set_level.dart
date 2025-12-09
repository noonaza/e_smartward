import 'dart:convert';

class SetValueParser {

  static Map<String, dynamic> parse(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v));
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final v = jsonDecode(raw);
        if (v is Map<String, dynamic>) return v;
        if (v is Map) {
          return v.map((k, v) => MapEntry(k.toString(), v));
        }
      } catch (_) {

      }
    }
    return {};
  }

  static bool flag(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == '1' || s == 'true';
    }
    return false;
  }

  static String detailString(Map<String, dynamic> sv) {
    final d = sv['detail'];
    if (d == null) return '';
    if (d is String) return d;
    
    return '';
  }
}