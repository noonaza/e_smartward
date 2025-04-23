import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_smartward/Model/list_data_obs.dart';
import 'package:flutter/material.dart';
import '../Model/list_data_card.dart';
import '../util/tlconstant.dart';
import '../widget/show_dialog.dart';

class DataCardApi {
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
            var drug_type_name = item['drug_type_name'];
            var lTypeName = drug_type_name.toString().split(']');
            var typeName = lTypeName[1];
            return ListDataCardModel(
              base_drug_usage_code: item['base_drug_usage_code'],
              caution: item['caution'],
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
              item_qty: item['item_qty'],
              item_type_name: item['item_type_name'],
              note_to_team: item['note_to_team'],
              order_date: item['order_date'],
              order_eid: item['order_eid'],
              order_item_id: item['order_item_id'],
              order_time: item['order_time'],
              patient_age: item['patient_age'],
              start_date_use: item['start_date_use'],
              end_date_use: item['end_date_use'],
            );
          }).toList();

          // print('listData: $lDataCard');
        }
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
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
              id: item['id'],
              code: item['code'],
              set_name: item['set_name'],
              set_value: jsonEncode({'obs': obs, 'col': col}),
              create_by: item['create_by'],
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
   Future<List<ListDataObsDetailModel>> loadSettingTime(BuildContext context,
      {
      required Map<String, String> headers_}) async {
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
}
