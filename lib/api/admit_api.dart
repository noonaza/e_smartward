import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/Model/get_obs_model.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/list_data_card_model.dart';
import '../util/tlconstant.dart';
import '../widget/show_dialog.dart';

class AdmitApi {
  Future<List<ListDataCardModel>> load(BuildContext context,
      {required String type,
      required String visitId,
      required Map<String, String> headers_}) async {
    List<ListDataCardModel> lDataCard = [];
    String api = '${TlConstant.syncApi}/get_data_card';
    final dio = Dio();
    try {
      final response = await dio.post(
        api,
        data: {
          'visit_id': visitId,
        },
        options: Options(
          headers: headers_,
        ),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {
          lDataCard = (response.data['body'] as List)
              .where((item) =>
                  item['drug_type_name'] != null &&
                  item['drug_type_name'].toString().contains(type))
              .map((item) {
                try {
                  var typeName = '';
                  if (item['id'] != null) {
                    typeName = item['type_card']?.toString().trim() ?? '';
                  } else if (item['drug_type_name'] != null) {
                    typeName = item['drug_type_name'].toString().trim();
                  }

                  final meal_timing = item['drug_instruction']
                              ?.toString()
                              .toLowerCase()
                              .contains("ก่อนอาหาร") ==
                          true
                      ? "ก่อนอาหาร"
                      : item['drug_instruction']
                                  ?.toString()
                                  .toLowerCase()
                                  .contains("หลังอาหาร") ==
                              true
                          ? "หลังอาหาร"
                          : null;

                  List<String> lsTakeTime = [];
                  if (type == 'ยา') {
                    lsTakeTime = [];
                    final instruction =
                        item['drug_instruction']?.toString().toLowerCase() ??
                            '';
                    if (instruction.contains("เช้า")) {
                      lsTakeTime.add("08:00");
                    }
                    if (instruction.contains("กลางวัน")) {
                      lsTakeTime.add("12:00");
                    }
                    if (instruction.contains("เย็น")) {
                      lsTakeTime.add("16:00");
                    }
                  }

                  item['drug_type_name']?.toString().trim();


                  return ListDataCardModel(
                    id: item['id'],
                    base_drug_usage_code: item['base_drug_usage_code'],
                    caution: int.tryParse(item['caution']?.toString() ?? '0'),
                    doctor_eid: item['doctor_eid'],
                    dose_qty: item['dose_qty'],
           
                    dose_unit_name: item['dose_unit_name'],
                    drug_description: item['drug_description'],
                    drug_instruction: item['drug_instruction'],
                    drug_type_id: item['drug_type_id'],
                    visit_id: item['visit_id'],
                    drug_type_name: typeName,
                    fix_item_type_id: item['fix_item_type_id'],
                    item_code: item['item_code'],
                    item_name: item['item_name'],
                    item_qty: int.tryParse(item['item_qty']?.toString() ?? '0'),
                    stock_out:
                        int.tryParse(item['stock_out']?.toString() ?? '0'),
                    item_type_name: item['item_type_name'],
                    note_to_team: item['note_to_team'],
                    order_date: item['order_date'],
                    order_eid: item['order_eid'],
                    order_item_id: item['order_item_id'],
                    order_time: item['order_time'],
                    set_slot: item['set_slot'],

                    start_date_imed: item['start_date_imed'],
                    type_slot:
                        item['type_slot']?.toString().trim().toUpperCase(),
                    schedule_mode_label:
                        item['schedule_mode_label']?.toString().trim(),
                    use_now: item['use_now'],
                    patient_age: item['patient_age'],
                    start_date_use: (item['start_date_use'] == null ||
                            item['start_date_use'] == '')
                        ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
                        : item['start_date_use'],
                    end_date_use: item['end_date_use'],
                    meal_timing: item['meal_timing'] ?? meal_timing,
                    remark: item['remark'],
                    take_time: item['take_time'] != null
                        ? "['${item['take_time']}']"
                        : (lsTakeTime.isNotEmpty
                            ? "['${lsTakeTime.join("','")}']"
                            : null),
                    unit_name: item['unit_name'],
                    time_slot: item['time_slot'],
                    unit_stock: item['unit_stock'],

                    status: item['status'],
                    update_date: item['update_date'],
                    update_by: item['update_by'],
                    dose_qty_name: item['dose_qty_name'],
                    meal_take: item['meal_take'],
                  );
                } catch (e) {
                  return null;
                }
              })
              .whereType<ListDataCardModel>()
              .toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(
            context, '${response.data['message']}\n ${response.data['body']}');
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
    }
    return lDataCard;
  }

  Future<List<ListDataObsDetailModel>> loadObs(BuildContext context,
      {required String? code,
      required String? setKey,
      required Map<String, String> headers_}) async {
    List<ListDataObsDetailModel> lDataObs = [];
    String api = '${TlConstant.syncApi}/get_setting';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'code': code,
          'set_key': setKey,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {
          lDataObs = (response.data['body'] as List).map((item) {
            final setValue = item['set_value'];
            final rawObs = setValue['obs'];
            final obs = rawObs.toString().split(':').first;
            final rawCol = setValue['col'];
            final col = rawCol.toString().split(':').first;

            return ListDataObsDetailModel(

              code: item['code'],
              set_name: item['set_name'],
              set_value: jsonEncode({'obs': obs, 'col': col}),
              create_by: item['create_by'],
              create_date: item['create_date'],
              remark: item['remark'],

              update_by: item['update_by'],
              update_date: item['update_date'],
              delete_by: item['delete_by'],
              delete_date: item['delete_date'],
              set_key: item['set_key'],
              take_time: item['take_time'],
              time_slot: item['time_slot'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
    }

    return lDataObs;
  }

  Future<List<ListDataObsDetailModel>> loadSettingTime(BuildContext context,
      {required Map<String, String> headers_}) async {
    List<ListDataObsDetailModel> lDataObs = [];
    String api = '${TlConstant.syncApi}/get_setting';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'code': null,
          'set_key': null,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {
          lDataObs = (response.data['body'] as List).map((item) {
            return ListDataObsDetailModel(
              id: item['id'],
              code: item['code'],
              set_name: item['set_name'],
              set_value: item['set_value'].toString(),
              create_by: item['create_by'],
              remark: item['remark'],
              create_date: item['create_date'],
              update_by: item['update_by'],
              update_date: item['update_date'],
              delete_by: item['delete_by'],
              delete_date: item['delete_date'],
              set_key: item['set_key'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
    }

    return lDataObs;
  }

  Future CreateCardV2(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_, 
    required List<ListDataCardModel> lDataCardDrug_, 
    required List<ListDataCardModel> lDataCardFood_, 
    required List<GetObsModel> lDataObs_, 
    required ListUserModel mUser, 
    required String message,
  }) async {
    final List<ListDataCardModel> lDataObs = [];

    for (final obs in lDataObs_) {
      final setValue = _parseToMap(obs.set_value);
      final String detailFromSetValue =
          (setValue['detail'] ?? '').toString().trim();
      final String itemName = detailFromSetValue.isNotEmpty
          ? detailFromSetValue
          : (obs.set_name ?? '');


      final Map<String, dynamic> instr = {
        "detail": itemName,
        "level": setValue['level'] ?? 0,
        "obs": setValue['obs'] ?? 0,
        "col": setValue['col'] ?? 0,
        "time_slot": (setValue['time_slot'] ?? '').toString(),
        "delete": 0,
      };

      final String safeTypeSlot = _normTypeSlot(obs.type_slot);
      final List<String>? normSetSlot = _normSetSlotForSend(obs.set_slot);
      final String scheduleLabel = labelFromStdType(safeTypeSlot);

      final int cautionVal = (setValue['col'] is num)
          ? (setValue['col'] as num).toInt()
          : int.tryParse(setValue['col']?.toString() ?? '0') ?? 0;

      final List<String> levelList = _normalizeLevelList(setValue['level']);

      final String levelJson = jsonEncode(levelList);

      final dataCardNew = ListDataCardModel(
        item_name: detailFromSetValue,
        item_qty: 0,
        drug_instruction: jsonEncode(instr),
        take_time: obs.take_time,
        start_date_use: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        stock_out: 0,
        item_code: obs.set_name,
        drug_description: levelJson,
        remark: obs.remark,
        caution: cautionVal,
        type_slot: safeTypeSlot,
        schedule_mode_label: scheduleLabel,
        meal_timing: obs.meal_timing,
        set_slot: normSetSlot != null ? jsonEncode(normSetSlot) : null, 
        note_to_team: "",
        drug_type_name: "OBS",
      );

      lDataObs.add(dataCardNew);
    }

    final createList = {
      'hn_number': mPetAdmit_.hn,
      'an_number': mPetAdmit_.an,
      'visit_number': mPetAdmit_.visit_id,
      'pet_name': mPetAdmit_.pet_name,
      'tl_common_users_id': mUser.id,
      'message': message,
      'data_drug': lDataCardDrug_.map(_toMapFromToJson).toList(),
      'data_food': lDataCardFood_.map(_toMapFromToJson).toList(),
      'data_observe': lDataObs.map(_toMapFromToJson).toList(),
    };

    final dio = Dio();
    const String api = '${TlConstant.syncApi}/create_admit';

    try {
      final response = await dio.post(
        api,
        data: createList,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: headers_,
        ),
      );

      if (response.data['code'] == 1) {
   
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      debugPrint('CreateCardV2 error: $e');
      dialog.Error(context, 'Failed to load data. Please try again.');
    }
  }

  Future<List<DoctorModel>> loadDataDoctor(
    BuildContext context, {
    required Map<String, String> headers_,
  }) async {
    List<DoctorModel> doctor = [];
    String api = '${TlConstant.syncApi}/get_data_doctor';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {},
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          doctor = body.map<DoctorModel>((item) {
            return DoctorModel(
              employee_id: item['employee_id'],
              prename: item['prename'],
              full_nameth: item['full_nameth'],
              employee_nameen: item['employee_nameen'],
              key_search: item['key_search'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load group codes.');
    }

    return doctor;
  }

  Future<List<GetObsModel>> GetObs(
    BuildContext context, {
    required String floor,
    required String bed_number,
    required Map<String, String> headers_,
  }) async {
    final dio = Dio();
    const String api = '${TlConstant.syncApi}/get_observ';
    List<GetObsModel> lGetObs = [];

    try {
      final payload = {'floor': floor, 'bed_number': bed_number};
      final response = await dio.post(
        api,
        data: payload,
        options: Options(headers: headers_),
      );

      final data = response.data;

      if (data is Map && data['code'] == 1 && data['body'] is List) {
        final body = data['body'] as List;

        lGetObs = body.map<GetObsModel>((item) {
          final safeTypeSlot = _normTypeSlot(item['type_slot']);
          final scheduleLabel = (() {
            final raw = item['schedule_mode_label']?.toString().trim();
            return (raw != null && raw.isNotEmpty && raw != 'ไม่กำหนด')
                ? raw
                : labelFromTypeSlot(safeTypeSlot);
          })();

          final setSlotNorm = _normSetSlotForRead(item['set_slot']);
          final takeTimeRaw = item['take_time'];
          final takeTimeStr = _toJsonStringNullable(takeTimeRaw);

          final model = GetObsModel(
            code: item['code'],
            set_name: item['set_name'],
            set_value: _toJsonStringNullable(item['set_value']),
            remark: item['remark']?.toString(),
            take_time: takeTimeStr,
            time_slot: item['time_slot']?.toString(),
            type_slot: safeTypeSlot,
            schedule_mode_label: scheduleLabel,
            set_slot: setSlotNorm,
            set_key: item['set_key'],
            key_special: item['key_special'],
            create_by: item['create_by'],
            create_date: item['create_date'],
            update_by: item['update_by'],
            update_date: item['update_date'],
            delete_by: item['delete_by'],
            delete_date: item['delete_date'],
          );

       
          debugPrint(
              'LOAD OBS ← type_slot=${model.type_slot} set_slot=${model.set_slot} label=${model.schedule_mode_label}');
          return model;
        }).toList();
      } else if (data is Map && data['code'] == 401) {
        dialog.token(context, data['message']);
      } else {
        dialog.Error(
            context,
            data is Map
                ? (data['message'] ?? 'Unknown error')
                : 'Unknown error');
        debugPrint('GetObs unexpected payload => ${data.runtimeType}');
      }
    } catch (e, st) {
      debugPrint('GetObs error: $e\n$st');
      dialog.Error(context, 'โหลดข้อมูลสังเกตอาการล้มเหลว');
    }

    return lGetObs;
  }

  Future<List<GetObsModel>> GetObsAll(
    BuildContext context, {
    required Map<String, String> headers_,
  }) async {
    List<GetObsModel> lGetObsAll = [];
    String api = '${TlConstant.syncApi}/get_observ_all';
    final dio = Dio();

    final response = await dio.post(
      api,
      data: {},
      options: Options(headers: headers_),
    );

    final data = response.data;
    if (data is Map && data['code'] == 1 && data['body'] is List) {
      final body = data['body'] as List;

      lGetObsAll = body.map<GetObsModel>((item) {
        final setValue =
            (item['set_value'] as Map?)?.cast<String, dynamic>() ?? {};
        final setValueJson = jsonEncode(setValue);

        return GetObsModel(
          set_name: item['set_name'],
          set_value: setValueJson,
        );
      }).toList();
    } else {
      throw Exception(data['message'] ?? 'Unknown error');
    }

    return lGetObsAll;
  }

  Map<String, dynamic> _parseToMap(dynamic raw) {
    if (raw == null) return <String, dynamic>{};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v));
    }
    if (raw is String) {
      final s = raw.trim();
      if (s.isEmpty || s.toLowerCase() == 'null') return <String, dynamic>{};
      try {
        final d = jsonDecode(s);
        if (d is Map<String, dynamic>) return d;
        if (d is Map) return d.map((k, v) => MapEntry(k.toString(), v));
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _toMapFromToJson(dynamic e) {
    if (e == null) return <String, dynamic>{};
    try {
      final dynamic d = e;
      if (d.toJson is Function) {
        final v = d.toJson();
        if (v is Map<String, dynamic>) return v;
        if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v));
        if (v is String) {
          try {
            final dec = jsonDecode(v);
            if (dec is Map<String, dynamic>) return dec;
            if (dec is Map) return dec.map((k, v) => MapEntry(k.toString(), v));
          } catch (_) {}
        }
      }
    } catch (_) {}
    if (e is Map<String, dynamic>) return e;
    if (e is Map) return e.map((k, v) => MapEntry(k.toString(), v));
    if (e is String) {
      final s = e.trim();
      if (s.startsWith('{') && s.endsWith('}')) {
        try {
          final dec = jsonDecode(s);
          if (dec is Map<String, dynamic>) return dec;
          if (dec is Map) return dec.map((k, v) => MapEntry(k.toString(), v));
        } catch (_) {}
      }
    }
    return <String, dynamic>{};
  }

  String? _toJsonStringNullable(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    try {
      return jsonEncode(v);
    } catch (_) {
      return v.toString();
    }
  }

  String _normTypeSlot(dynamic v) {
    final t = v?.toString().trim();
    if (t == null || t.isEmpty || t.toLowerCase() == 'null') return 'ALL';
    return t.toUpperCase();
  }

  List<String>? _normSetSlotForSend(dynamic raw) {
    if (raw == null) return null;

    if (raw is List) {
      final out = raw
          .map((e) => (e ?? '').toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return out.isEmpty ? null : out;
    }

    var s = raw.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null' || s == '-') return null;

    s = s.replaceAll("'", '"').replaceAll(';', ',');
    try {
      final d = jsonDecode(s);
      if (d is List) {
        final out = d
            .map((e) => (e ?? '').toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
        return out.isEmpty ? null : out;
      }
    } catch (_) {}

    final out = s
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .split(RegExp(r'\s*[,;]\s*'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return out.isEmpty ? null : out;
  }

  String? _normSetSlotForRead(dynamic raw) {
    if (raw == null) return null;

    if (raw is List) {
      final out = raw
          .map((e) => (e ?? '').toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return out.isEmpty ? null : jsonEncode(out);
    }

    var s = raw.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null' || s == '-') return null;

    s = s.replaceAll("'", '"').replaceAll(';', ',');
    try {
      final d = jsonDecode(s);
      if (d is List) {
        final out = d
            .map((e) => (e ?? '').toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
        return out.isEmpty ? null : jsonEncode(out);
      }
    } catch (_) {}

    final out = s
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .split(RegExp(r'\s*[,;]\s*'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return out.isEmpty ? null : jsonEncode(out);
  }

  String labelFromTypeSlot(String? typeSlot) {
    switch ((typeSlot ?? '').toUpperCase()) {
      case 'DAYS':
        return 'สัปดาห์ละครั้ง';
      case 'DATE':
        return 'กำหนดรายวัน';
      case 'D_M':
        return 'กำหนดรายเดือน';
      case 'ALL':
      default:
        return 'ไม่กำหนด';
    }
  }

  String normTypeSlot(String? t) {
    final s = (t ?? '').trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return 'ALL';
    switch (s.toUpperCase()) {
      case 'DAYS':
      case 'WEEKLY_ONCE':
        return 'DAYS';
      case 'DATE':
      case 'DAILY_CUSTOM':
        return 'DATE';
      case 'D_M':
      case 'MONTHLY_CUSTOM':
        return 'D_M';
      case 'ALL':
      default:
        return 'ALL';
    }
  }

  String labelFromStdType(String? t) {
    switch ((t ?? '').trim().toUpperCase()) {
      case 'DAYS':
        return 'สัปดาห์ละครั้ง';
      case 'DATE':
        return 'กำหนดรายวัน';
      case 'D_M':
        return 'กำหนดรายเดือน';
      case 'ALL':
      default:
        return 'ไม่กำหนด';
    }
  }


  String computeScheduleLabel({
    required String? typeSlot,
    String? timeSlot,
    String? setSlot,
  }) {

    if (timeSlot?.contains('เมื่อมีอาการ') == true) return 'เมื่อมีอาการ';

    final t = normTypeSlot(typeSlot);
    return labelFromStdType(t);
  }

  List<String> _normalizeLevelList(dynamic raw) {
    if (raw == null) return const [];
    if (raw is List) {
      return raw
          .map((e) => (e ?? '').toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
   
    var s = raw.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return const [];

    s = s.replaceAll("'", '"');
    try {
      final d = jsonDecode(s);
      if (d is List) {
        return d
            .map((e) => (e ?? '').toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (_) {
  
      return s
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(RegExp(r'\s*[,;]\s*'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return const [];
  }

  Future CreateCardV1(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_,
    required List<ListDataCardModel> lDataCardDrug_,
    required List<ListDataCardModel> lDataCardFood_,
    required List<ListDataObsDetailModel> lDataObs_,
    required ListUserModel mUser,
    required String message,
  }) async {
    List<ListDataCardModel> lDataObs = [];
    for (var obs in lDataObs_) {
      final Map<String, dynamic> setValue = jsonDecode(obs.set_value!);

      final dataCardNew = ListDataCardModel(
          item_name: obs.set_name,
          item_qty: 0,
          drug_instruction:
              '{"obs" : ${setValue['obs'] ?? '0'},"col" : ${setValue['col'] ?? '0'},"time_slot" : "${setValue['time_slot'] ?? ''}","delete" : 0}',
          take_time: obs.take_time,
          start_date_use:
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          stock_out: 0,
          remark: obs.remark,
          note_to_team: "",
          drug_type_name: "OBS");

      lDataObs.add(dataCardNew);
    }

    final createList = {
      'hn_number': mPetAdmit_.hn,
      'an_number': mPetAdmit_.an,
      'visit_number': mPetAdmit_.visit_id,
      'pet_name': mPetAdmit_.pet_name,
      'tl_common_users_id': mUser.id,
      'message': message,
      'data_drug': lDataCardDrug_.map((e) => e.toJson()).toList(),
      'data_food': lDataCardFood_.map((e) => e.toJson()).toList(),
      'data_observe': lDataObs.map((e) => e.toJson()).toList(),
    };

    String api = '${TlConstant.syncApi}/create_admit';
    final dio = Dio();

    final response = await dio.post(
      api,
      data: createList,
      options: Options(headers: headers_),
    );

    try {
      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {}
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
    }
  }
}
