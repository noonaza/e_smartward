import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_smartward/Model/site_model.dart';
import 'package:e_smartward/Model/ward_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:flutter/material.dart';
import '../Model/list_food_model.dart';
import '../Model/list_pet_model.dart';
import '../Model/list_user_model.dart';

class ManageFoodApi {
 Future<List<String>> loadFoodSlot(
  BuildContext context, {
  required Map<String, String> headers_,
  String? groupId,
  String? siteCode,
  String? wardCode,
  required String type,
}) async {
  String api = '${TlConstant.syncApi}/get_food_slot';
  final dio = Dio();

  try {
    final response = await dio.post(
      api,
      data: {
        "type": type,
        "group_id": groupId != null ? int.tryParse(groupId) : null,
        "site_code": siteCode,
        "ward": wardCode,
      },
      options: Options(headers: headers_),
    );

    if (response.data['code'] == 1) {
      if (response.data['body'] is List) {
        return List<String>.from(response.data['body']);
      }
    } else if (response.data['code'] == 401) {
      dialog.token(context, response.data['message']);
    } else {
      dialog.Error(context, response.data['message']);
    }
  } catch (e) {
    dialog.Error(context, 'Failed to load data. Please try again.');
  }

  return [];
}


  Future<List<ListFoodModel>> loadGroupCodeList(
    BuildContext context, {
    required Map<String, String> headers_,
  }) async {
    List<ListFoodModel> groupCodes = [];
    String api = '${TlConstant.syncApi}/get_setting';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'code': 'GROUP-BED',
          'set_key': null,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          groupCodes = body.map<ListFoodModel>((item) {
            return ListFoodModel(
              id: item['id'],
              item_name: item['set_name'].toString(),
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

    return groupCodes;
  }

  Future<List<ListPetModel>> loadListAdmit(
    BuildContext context, {
    required Map<String, String> headers_,
  }) async {
    List<ListPetModel> admit = [];
    String api = '${TlConstant.syncApi}/get_list_admid';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'type': 'GROUP-BED',
          'group_id': null,
          'site_code': null,
          'ward': null,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          admit = body.map<ListPetModel>((item) {
            return ListPetModel(
              visit_id: item['visit_id'],
              hn: item['hn'],
              an: item['an'],
              owner_name: item['owner_name'],
              pet_name: item['pet_name'],
              pet_type: item['pet_type'],
              base_site_branch_id: item['base_site_branch_id'],
              ward: item['ward'],
              room_type: item['room_type'],
              bed_number: item['bed_number'],
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

    return admit;
  }

  Future<List<SiteModel>> loadSite(
    BuildContext context, {
    required Map<String, String> headers_,
  }) async {
    List<SiteModel> site = [];
    String api = '${TlConstant.syncApi}/get_site';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'area': "TLPH",
          'status': "active",
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          site = body.map<SiteModel>((item) {
            return SiteModel(
              id: item['id'],
              name: item['name'].toString(),
              code_name: item['code_name'].toString(),
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

    return site;
  }

  Future<List<WardModel>> loadDataWard(
    BuildContext context, {
    required Map<String, String> headers_,
    required String siteCode,
  }) async {
    List<WardModel> ward = [];
    String api = '${TlConstant.syncApi}/get_data_ward';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'site_code': siteCode,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          ward = body.map<WardModel>((item) {
            return WardModel(
                base_service_point_id: item['base_service_point_id'],
                ward: item['ward'],
                base_site_branch_id: item['base_site_branch_id']);
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

    return ward;
  }

  Future<List<SiteModel>> loadDataBed(
    BuildContext context, {
    required Map<String, String> headers_,
  }) async {
    List<SiteModel> site = [];
    String api = '${TlConstant.syncApi}/get_data_bed';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'site_code': "TLPH",
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          site = body.map<SiteModel>((item) {
            return SiteModel(
              id: item['id'],
              name: item['name'].toString(),
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

    return site;
  }

  Future<List<Map<String, dynamic>>> loadListFoodSlot(
    BuildContext context, {
    required Map<String, String> headers_,
    required String slot,
    required String groupId,
    required String siteCode,
    required String ward,
    required String type,
  }) async {
    String api = '${TlConstant.syncApi}/get_listfood_inslot';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          "type": type,
          "group_id": int.tryParse(groupId),
          "site_code": siteCode,
          "ward": ward,
          "slot": slot,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          final List<Map<String, dynamic>> result = [];

          for (final item in body) {
            final takeTime = item['take_time'];
            if (takeTime != null && takeTime is String) {
              try {
                final List<dynamic> takeTimes =
                    jsonDecode(takeTime.replaceAll("'", '"'));

                if (takeTimes.contains(slot)) {
                  result.add({
                    'id': item['id'],
                    'smw_admit_id': item['smw_admit_id'],
                    'type_card': item['type_card'],
                    'item_name': item['item_name'] ?? '',
                    'item_qty': item['item_qty']?.toString() ?? '',
                    'unit_name': item['unit_name'] ?? '',
                    'dose_qty': item['dose_qty'],
                    'meal_timing': item['meal_timing'],
                    'drug_instruction': item['drug_instruction'],
                    'take_time': slot,
                    'start_date_use': item['start_date_use'],
                    'end_date_use': item['end_date_use'],
                    'stock_out': item['stock_out']?.toString() ?? '0',
                    'remark': item['remark'],
                    'create_date': item['create_date'],
                    'create_by': item['create_by'],
                    'delete_date': item['delete_date'],
                    'delete_by': item['delete_by'],
                    'order_item_id': item['order_item_id'],
                    'doctor_eid': item['doctor_eid'],
                    'item_code': item['item_code'],
                    'note_to_team': item['note_to_team'],
                    'caution': item['caution'],
                    'drug_description': item['drug_description'],
                    'order_eid': item['order_eid'],
                    'order_date': item['order_date'],
                    'order_time': item['order_time'],
                    'drug_type_name': item['drug_type_name'],
                    'time_slot': item['time_slot'],
                    'hn_number': item['hn_number'] ?? '',
                    'an_number': item['an_number'] ?? '',
                    'visit_number': item['visit_number'] ?? '',
                    'status': item['status'] ?? '',
                    'pet_name': item['pet_name'] ?? '',
                    'pre_pare_status': item['pre_pare_status'] ?? '',
                    'date_slot': item['date_slot'] ?? '',
                    'bed_number': item['bed_number'] ?? '',
                  });
                }
              } catch (e) {
               
                dialog.Error(context, 'JSON decode error: $e');
              }
            }
          }

          return result;
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      
      dialog.Error(context, 'Error loading food slot: $e');
    }

    return [];
  }

  Future CreateFood(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListFoodModel mFood_,
    required ListUserModel mUser,
  }) async {
    final saveFood = {
      'smw_admit_id': mFood_.smw_admit_id,
      'smw_admit_order_id': mFood_.id,
      'slot': mFood_.take_time,
      'date_slot': mFood_.date_slot,
      'stock_out': mFood_.stock_out,
      'pre_pare_status': mFood_.status,
      'tl_common_users_id': mUser.id,
    };

    String api = '${TlConstant.syncApi}/save_take_food';
    final dio = Dio();

    final response = await dio.post(
      api,
      data: saveFood,
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

  Future<List<ListPetModel>> loadApiPetAdmit(BuildContext context,
      {required String hnNumber, required Map<String, String> headers_}) async {
    List<ListPetModel> lDataPet = [];
    String api = '${TlConstant.syncApi}/get_data_admit';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'hn_number': hnNumber,
        },
        options: Options(
          headers: headers_,
        ),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {
          (response.data['body'] as List).map((item) {
            return ListPetModel(
              an: item['an'],
              base_site_branch_id: item['base_site_branch_id'],
              bed_number: item['bed_number'],
              hn: hnNumber,
              owner_name: item['owner_name'],
              pet_name: item['pet_name'],
              pet_type: item['pet_type'],
              room_type: item['room_type'],
              visit_id: item['visit_id'],
              ward: item['ward'],
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

    return lDataPet;
  }
}
