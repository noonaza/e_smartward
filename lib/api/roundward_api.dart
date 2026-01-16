import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_smartward/Model/data_add_order_mpdel.dart';
import 'package:e_smartward/Model/data_progress_model.dart';
import 'package:e_smartward/Model/list_an_model.dart';
import 'package:e_smartward/Model/list_data_roundward_model.dart';
import 'package:e_smartward/Model/list_file._model.dart';
import 'package:e_smartward/Model/list_group_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_roundward_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/Model/new_order_model.dart';
import 'package:e_smartward/Model/update_order_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoundWardApi {
  Future<List<ListPetModel>> loadListAdmit(
    BuildContext context, {
    required String ward,
    required String siteCode,
    required String? groupId,
    required String type,
    required Map<String, String> headers_,
  }) async {
    List<ListPetModel> admit = [];
    String api = '${TlConstant.syncApi}/get_list_admid';
    final dio = Dio();

    try {
      final data = {
        'type': type,
        'group_id': groupId,
        'site_code': siteCode,
        'ward': ward,
      };

      final response = await dio.post(
        api,
        data: data,
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
                doctor: item['doctor'],
                admit_date: item['admit_date'],
                admit_time: item['admit_time'],
                admit_datetimes: item['admit_datetimes'],
                image: item['image']);
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

  Future<List<ListAnModel>> loadListAn(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_,
  }) async {
    List<ListAnModel> an = [];
    String api = '${TlConstant.syncApi}/get_list_an';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'hn_number': mPetAdmit_.hn,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          an = body.map<ListAnModel>((item) {
            return ListAnModel(
              smw_admit_id: item['smw_admit_id'],
              an_number: item['an_number'],
              visit_number: item['visit_number'],
              create_date: item['create_date'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load AN.');
    }

    return an;
  }

  Future<List<ListGroupModel>> loadHeadGroup(
    BuildContext context, {
    required Map<String, String> headers_,
    DateTime? date_,
  }) async {
    List<ListGroupModel> group = [];
    String api = '${TlConstant.syncApi}/get_group_datacard';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'type_card': null,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          group = body.map<ListGroupModel>((item) {
            return ListGroupModel(
              type_card: item['type_card'],
              type_name: item['type_name'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load AN.');
    }

    return group;
  }

  Future<List<ListRoundwardModel>> loadDataRoundWard(
    BuildContext context, {
    required ListAnModel mListAn_,
    required Map<String, String> headers_,
    ListGroupModel? mGroup_,
    DateTime? selectedDate,
  }) async {
    List<ListRoundwardModel> dataward = [];
    String api = '${TlConstant.syncApi}/get_transaction_bytype';
    final dio = Dio();
    try {
      final response = await dio.post(
        api,
        data: {
          'smw_admit_id': mListAn_.smw_admit_id,
          'type_card': mGroup_?.type_card,
          'type_name': mGroup_?.type_name,
          'date_slot':
              DateFormat('yyyy-MM-dd').format(selectedDate ?? DateTime.now()),

          //'date_slot': "2025-07-17"
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];

        if (body is List) {
          dataward = body.map<ListRoundwardModel>((item) {
            final List<ListDataRoundwardModel> cardList = [];
            if (item['data_trans'] is List) {
              for (var card in item['data_trans']) {
                cardList.add(ListDataRoundwardModel(
                  smw_transaction_order_id: card['smw_transaction_order_id']
                          is int
                      ? card['smw_transaction_order_id']
                      : int.tryParse(
                          card['smw_transaction_order_id']?.toString() ?? ''),
                  smw_transaction_id: card['smw_transaction_id'] is int
                      ? card['smw_transaction_id']
                      : int.tryParse(
                          card['smw_transaction_id']?.toString() ?? ''),
                  item_name: card['item_name']?.toString() ?? '',
                  drug_instruction: card['drug_instruction']?.toString() ?? '',
                  date_slot: card['date_slot']?.toString() ?? '',
                  slot: card['slot']?.toString() ?? '',
                  comment: card['comment']?.toString() ?? '',
                  remark: card['remark']?.toString() ?? '',
                  status: card['status']?.toString() ?? '',
                  save_by: card['save_by'] is int
                      ? card['save_by']
                      : int.tryParse(card['save_by']?.toString() ?? ''),
                  save_by_name: card['save_by_name']?.toString() ?? '',
                  create_date: card['create_date']?.toString() ?? '',
                ));
              }
            }

            return ListRoundwardModel(
              id: item['id'] is int
                  ? item['id']
                  : int.tryParse(item['id'].toString()),
              smw_admit_id: item['smw_admit_id'] is int
                  ? item['smw_admit_id']
                  : int.tryParse(item['smw_admit_id'].toString()),
              type_card: item['type_card']?.toString(),
              item_name: item['item_name']?.toString(),
              item_qty: item['item_qty'] is int
                  ? item['item_qty']
                  : int.tryParse(item['item_qty'].toString()),
              unit_name: item['unit_name']?.toString(),
              dose_qty: item['dose_qty']?.toString(),
              meal_timing: item['meal_timing']?.toString(),
              drug_instruction: item['drug_instruction']?.toString(),
              take_time: item['take_time']?.toString(),
              start_date_use: item['start_date_use']?.toString(),
              end_date_use: item['end_date_use']?.toString(),
              stock_out: item['stock_out']?.toString(),
              remark: item['remark']?.toString(),
              create_date: item['create_date']?.toString(),
              create_by: item['create_by']?.toString(),
              delete_date: item['delete_date']?.toString(),
              delete_by: item['delete_by']?.toString(),
              order_item_id: item['order_item_id']?.toString(),
              doctor_eid: item['doctor_eid']?.toString(),
              item_code: item['item_code']?.toString(),
              note_to_team: item['note_to_team']?.toString(),
              caution: item['caution']?.toString(),
              drug_description: item['drug_description']?.toString(),
              order_eid: item['order_eid']?.toString(),
              type_slot: item['type_slot']?.toString(),
              order_date: item['order_date']?.toString(),
              order_time: item['order_time']?.toString(),
              drug_type_name: item['drug_type_name']?.toString(),
              time_slot: item['time_slot']?.toString(),
              unit_stock: item['unit_stock']?.toString(),
              status: item['status']?.toString(),
              update_date: item['update_date']?.toString(),
              set_slot: item['set_slot']?.toString(),
              use_now: item['use_now']?.toString(),
              update_by: item['update_by']?.toString(),
              total_useable: item['total_useable']?.toString(),
              dose_qty_name: item['dose_qty_name']?.toString(),
              used_count: item['used_count'] is int
                  ? item['used_count']
                  : int.tryParse(item['used_count'].toString()),
              remaining: item['remaining']?.toString(),
              data_trans: cardList,
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        if (context.mounted) {
          dialog.token(context, response.data['message']);
        }
      } else if (response.data['code'] == 0) {
        if (context.mounted) {
          dialog.Nodata(context, response.data['message']);
        }
      } else {
        if (context.mounted) {
          dialog.Error(context, response.data['message']);
        }
      }
    } catch (e) {
      if (context.mounted) {
        dialog.Error(context, 'Failed to load');
      }
    }

    return dataward;
  }

  Future<List<DataProgressModel>> loadProgress(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_,
  }) async {
    List<DataProgressModel> progress = [];
    String api = '${TlConstant.syncApi}/get_progressnote';
    final dio = Dio();

    try {
      if (mPetAdmit_.visit_id == null || mPetAdmit_.visit_id!.isEmpty) {
        dialog.Error(context, 'ไม่พบ visit_id ของสัตว์ตัวนี้');
        return [];
      }
      final response = await dio.post(
        api,
        data: {
          'visit_id': mPetAdmit_.visit_id,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          progress = body.map<DataProgressModel>((item) {
            return DataProgressModel(
              admit_id: item['admit_id'],
              visit_id: item['visit_id'],
              create_datetime: item['create_datetime'],
              doctor_create_name: item['doctor_create_name'],
              update_datetime: item['update_datetime'],
              doctor_update_name: item['doctor_update_name'],
              s: item['s'],
              o: item['o'],
              a: item['a'],
              p: item['p'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load progress.');
    }

    return progress;
  }

  Future<List<NewOrderModel>> loadNewOrder(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_,
  }) async {
    List<NewOrderModel> newOrder = [];
    String api = '${TlConstant.syncApi}/check_new_order';
    final dio = Dio();

    try {
      final data = {
        "visit_id": mPetAdmit_.visit_id,
      };

      final response = await dio.post(
        api,
        data: data,
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          newOrder = body.map<NewOrderModel>((item) {
            return NewOrderModel(
              visit_id: item['visit_id'],
              order_item_id: item['order_item_id'],
              doctor_eid: item['doctor_eid'],
              item_code: item['item_code'],
              item_name: item['item_name'],
              item_qty: item['item_qty'],
              unit_name: item['unit_name'],
              dose_qty: item['dose_qty'],
              dose_unit_name: item['dose_unit_name'],
              base_drug_usage_code: item['base_drug_usage_code'],
              drug_instruction: item['drug_instruction'],
              fix_item_type_id: item['fix_item_type_id'],
              item_type_name: item['item_type_name'],
              drug_type_id: item['drug_type_id'],
              drug_type_name: item['drug_type_name'],
              note_to_team: item['note_to_team'],
              caution: item['caution'],
              drug_description: item['drug_description'],
              start_date_use: item['start_date_use'],
              end_date_use: item['end_date_use'],
              order_eid: item['order_eid'],
              order_date: item['order_date'],
              order_time: item['order_time'],
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

    return newOrder;
  }

  Future<void> AddOrder(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_,
    required ListAnModel mListAn_,
    required List<DataAddOrderModel> lDataOrder_,
    required ListUserModel mUser,
    NewOrderModel? mNewOrder_,
  }) async {
    final List<Map<String, dynamic>> formattedData = [];

    for (var item in lDataOrder_) {
      final Map<String, dynamic> data = jsonDecode(item.toJson());

      if (item.type_card == 'OBS') {
        Map<String, dynamic> setValue = {};

        try {
          final decoded = jsonDecode(item.take_time ?? '{}');

          if (decoded is Map) {
            setValue = decoded.map((k, v) => MapEntry(k.toString(), v));
          } else {
            setValue = {};
          }
        } catch (_) {
          setValue = {};
        }

        data['drug_instruction'] = jsonEncode({
          "obs": setValue['obs'] ?? 0,
          "col": setValue['col'] ?? 0,
          "time_slot": setValue['time_slot'] ?? "",
          "delete": 0,
        });
      }

      formattedData.add(data);
    }

    final createList = {
      'smw_admit_id': mListAn_.smw_admit_id ?? 0,
      'tl_common_users_id': mUser.id ?? 0,
      'data_card': formattedData,
    };

    String api = '${TlConstant.syncApi}/add_order';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: createList,
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] != 0) {
          dialog.success(context, 'บันทึกข้อมูลสำเร็จ');
          Navigator.of(context).pop();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'เกิดข้อผิดพลาด: $e');
    }
  }

  Future<void> updateOrderData(
      {required BuildContext context,
      required Map<String, String> headers_,
      required UpdateOrderModel updatedDrug,
      required ListUserModel mUser,
      required ListPetModel mPetAdmit_,
      required ListAnModel mListAn_,
      required ListRoundwardModel mData_}) async {
    String api = '${TlConstant.syncApi}/update_order';
    final dio = Dio();

    final updatePayload = {
      "id": mData_.id,
      "item_name": updatedDrug.item_name,
      "item_qty": updatedDrug.item_qty ?? 0,
      "unit_name": updatedDrug.unit_name ?? '',
      "dose_qty": updatedDrug.dose_qty ?? '',
      "meal_timing": updatedDrug.meal_timing ?? '',
      "drug_instruction": updatedDrug.drug_instruction ?? '',
      "take_time": updatedDrug.take_time ?? "[]",
      "start_date_use": updatedDrug.start_date_use ?? '',
      "end_date_use": updatedDrug.end_date_use ?? '',
      "stock_out": updatedDrug.stock_out ?? 0,
      "remark": updatedDrug.remark ?? '',
      "note_to_team": updatedDrug.note_to_team ?? '',
      "caution": updatedDrug.caution ?? '',
      "drug_description": updatedDrug.drug_description ?? '',
      "drug_type_name": updatedDrug.drug_type_name ?? '',
      "time_slot": updatedDrug.time_slot ?? '',
      "unit_stock": updatedDrug.unit_stock ?? '',
      "status": updatedDrug.status ?? 'Order',
      "tl_common_users_id": mUser.id,
      "meal_take": updatedDrug.meal_take ?? '',
      "start_date_imed": updatedDrug.start_date_imed ?? '',
      "type_slot": updatedDrug.type_slot ?? '',
      "set_slot": updatedDrug.set_slot ?? '',
      "use_now": updatedDrug.use_now ?? '',
    };

    try {
      final response = await dio.post(
        api,
        data: updatePayload,
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        dialog.success(context, 'บันทึกข้อมูลสำเร็จ');
        Navigator.of(context).pop();
      } else {
        dialog.Error(context,
            'บันทึกไม่สำเร็จ: ${response.data['message'] ?? 'ไม่ทราบสาเหตุ'}');
      }
    } catch (e) {
      dialog.Error(context, 'เกิดข้อผิดพลาด: $e');
    }
  }

  Future<List<ListFileModel>> loadFile(
    BuildContext context, {
    required int? orderId,
    required Map<String, String> headers_,
  }) async {
    List<ListFileModel> files = [];

    if (orderId == null || orderId == 0) {
      return files;
    }

    String api = '${TlConstant.syncApi}/get_file_transaction';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'smw_transaction_order_id': orderId,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        if (body is List) {
          files = body.map<ListFileModel>((item) {
            return ListFileModel(
              id: item['id'] ?? 0,
              code_project: "SMW",
              ref_id: item['ref_id'] ?? '',
              internal: item['internal'] ?? '',
              path_file: item['path_file'] ?? '',
              remark: item['remark'] ?? '',
              create_date: item['create_date'] ?? '',
              delete_date: item['delete_date'],
            );
          }).toList();
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load file data.');
    }

    return files;
  }
}
