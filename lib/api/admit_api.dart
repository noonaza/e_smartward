import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_smartward/Model/list_data_obs_model.dart';
import 'package:e_smartward/Model/list_pet_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:flutter/material.dart';
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
            var drug_type_name = '';
            var lTypeName = [];
            var typeName = '';
            if (item['id'] != null) {
              typeName = item['type_card'];
            } else {
              drug_type_name = item['drug_type_name'];
              lTypeName = drug_type_name.toString().split(']');
              typeName = lTypeName[1];
            }
            final meal_timing = item['drug_instruction']
                    .toString()
                    .toLowerCase()
                    .contains("ก่อนอาหาร")
                ? "ก่อนอาหาร"
                : item['drug_instruction']
                        .toString()
                        .toLowerCase()
                        .contains("หลังอาหาร")
                    ? "หลังอาหาร"
                    : null;

            return ListDataCardModel(
              id: item['id'],
              base_drug_usage_code: item['base_drug_usage_code'],
              caution: item['caution'],
              doctor_eid: item['doctor_eid'],
              dose_qty: double.parse(item['dose_qty'].toString().isEmpty ||
                      item['dose_qty'] == null
                  ? '0'
                  : item['dose_qty'].toString()),
              dose_unit_name: item['dose_unit_name'],
              drug_description: item['drug_description'],
              drug_instruction: item['drug_instruction'],

              drug_type_id: item['drug_type_id'],
              visit_id: item['visit_id'],
              drug_type_name: typeName,
              fix_item_type_id: item['fix_item_type_id'],
              item_code: item['item_code'],
              item_name: item['item_name'],
              item_qty: int.parse(item['item_qty'].toString().isEmpty ||
                      item['item_qty'] == null
                  ? '0'
                  : item['item_qty'].toString()), //5
              stock_out: int.parse(item['stock_out'].toString().isEmpty ||
                      item['stock_out'] == null
                  ? '0'
                  : item['stock_out'].toString()), //5
              item_type_name: item['item_type_name'],
              note_to_team: item['note_to_team'],
              order_date: item['order_date'],
              order_eid: item['order_eid'],
              order_item_id: item['order_item_id'],
              order_time: item['order_time'],
              patient_age: item['patient_age'],
              start_date_use:
                  item['start_date_use'] == null || item['start_date_use'] == ''
                      ? DateTime.now().toString()
                      : item['start_date_use'],
              end_date_use: item['end_date_use'],
              // id: item['id'],
              meal_timing: item['meal_timing'] ?? meal_timing,
              remark: item['remark'],
              take_time: item['take_time'],
              unit_name: item['unit_name'],
              time_slot: item['time_slot'],
            );
          }).toList();

          // print('listData: $lDataCard');
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
              //id: item['id'],
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
          // print('listDataObs: $lDataObs');
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
          // print('listDataObs: $lDataObs');
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

  Future CreateCard(
    BuildContext context, {
    required Map<String, String> headers_,
    required ListPetModel mPetAdmit_,
    required List<ListDataCardModel> lDataCardDrug_,
    required List<ListDataCardModel> lDataCardFood_,
    required List<ListDataObsDetailModel> lDataObs_,
    required ListUserModel mUser,
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
          start_date_use: DateTime.now().toString(),
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
