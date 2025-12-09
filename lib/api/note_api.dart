import 'package:dio/dio.dart';
import 'package:e_smartward/Model/create_transection_model.dart';
import 'package:e_smartward/Model/data_note_model.dart';
import 'package:e_smartward/Model/list_file._model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/create_trans_detail_model.dart';
import '../Model/list_pet_model.dart';
import '../Model/note_detail_model.dart';
import '../util/tlconstant.dart';
import '../widget/show_dialog.dart';

class NoteApi {
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
      final response = await dio.post(
        api,
        data: {
          'type': type,
          'group_id': groupId,
          'site_code': siteCode,
          'ward': ward,
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
              admit_date: item['admit_date'],
              admit_time: item['admit_time'],
              admit_datetimes: item['admit_datetimes'],
              doctor: item['doctor'],
              image: item['image'],
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

  Future<List<NoteDetailModel>> loadNoteDetail(
    BuildContext context, {
    required String visitId,
    required String date_time,
    required Map<String, String> headers_,
  }) async {
    List<NoteDetailModel> notes = [];
    String api = '${TlConstant.syncApi}/get_transaction';
    final dio = Dio();

    final rootContext = Navigator.of(context, rootNavigator: true).context;

    try {
      final response = await dio.post(
        api,
        data: {
          'visit_id': visitId,
          'date_time': DateFormat('yyyy-MM-dd HH:00')
              .format(DateTime.now().add(const Duration(minutes: 15))),
        },
        options: Options(headers: headers_),
      );
      final code = response.data['code'];
      if (code == 1) {
        final body = response.data['body'];
        if (body is List && body.isNotEmpty) {
          notes = body.map<NoteDetailModel>((item) {
            return NoteDetailModel(
              id: item['id'] is int
                  ? item['id']
                  : int.tryParse(item['id'].toString()),
              smw_admit_id: item['smw_admit_id'] is int
                  ? item['smw_admit_id']
                  : int.tryParse(item['smw_admit_id'].toString()),
              remark: item['remark']?.toString(),
              create_date: item['create_date']?.toString(),
              create_by: item['create_by']?.toString(),
              create_by_name: item['create_by_name']?.toString(),
              slot: item['slot']?.toString(),
              date_slot: item['date_slot']?.toString(),
              dataNote: (item['data_card'] is List)
                  ? (item['data_card'] as List).map<DataNoteModel>((card) {
                      return DataNoteModel(
                        smw_transaction_order_id:
                            card['smw_transaction_order_id'] is int
                                ? card['smw_transaction_order_id']
                                : int.tryParse(card['smw_transaction_order_id']
                                        ?.toString() ??
                                    ''),
                        smw_admit_order_id: card['smw_admit_order_id'] is int
                            ? card['smw_admit_order_id']
                            : int.tryParse(
                                card['smw_admit_order_id']?.toString() ?? ''),
                        type_card: card['type_card']?.toString() ?? '',
                        item_name: card['item_name']?.toString() ?? '',
                        item_qty: card['item_qty'] ?? 0,
                        unit_name: card['unit_name']?.toString() ?? '',
                        dose_qty: card['dose_qty']?.toString() ?? '',
                        meal_timing: card['meal_timing']?.toString() ?? '',
                        drug_instruction:
                            card['drug_instruction']?.toString() ?? '',
                        remark: card['remark']?.toString() ?? '',
                        item_code: card['item_code']?.toString() ?? '',
                        note_to_team: card['note_to_team']?.toString() ?? '',
                        caution: card['caution']?.toString() ?? '',
                        drug_description:
                            card['drug_description']?.toString() ?? '',
                        time_slot: card['time_slot']?.toString() ?? '',
                        drug_type_name:
                            card['drug_type_name']?.toString() ?? '',
                        pre_pare_status:
                            card['pre_pare_status']?.toString() ?? '',
                        date_slot: card['date_slot']?.toString() ?? '',
                        slot: card['slot']?.toString() ?? '',
                        create_date: card['create_date']?.toString() ?? '',
                        save_by: card['save_by']?.toString() ?? '',
                        save_by_name: card['save_by_name']?.toString() ?? '',
                        levels: card['levels']?.toString() ?? '',
                        col: card['col']?.toString() ?? '',
                        doctor: card['doctor']?.toString() ?? '',
                        feed: card['feed']?.toString() ?? '',
                        comment: card['comment']?.toString() ?? '',
                        status: card['status']?.toString() ?? '',
                        file_count: card['file_count'] is int
                            ? card['file_count']
                            : int.tryParse(
                                card['file_count']?.toString() ?? ''),
                      );
                    }).toList()
                  : <DataNoteModel>[],
            );
          }).toList();
        } else {
          dialog.Nodata(
              rootContext, 'ไม่พบข้อมูลการให้อาหาร / ยา สำหรับช่วงเวลานี้');
        }
      } else if (code == 401) {
        dialog.token(rootContext, response.data['message'] ?? 'Unauthorized');
      } else if (code == 0) {
        dialog.Nodata(rootContext,
            response.data['message'] ?? 'ไม่พบข้อมูล Admit ในระบบ');
      } else {
        dialog.Error(rootContext,
            response.data['message'] ?? 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์');
      }
    } catch (e) {
      dialog.Error(rootContext, 'Failed to load group codes.');
    }

    return notes;
  }

  Future CreateTransection(
    BuildContext context, {
    required Map<String, String> headers_,
    required CreateTransectionModel mNoteData,
    required ListPetModel mPetAdmit_,
    required ListUserModel mUser,
  }) async {
    final createList = {
      'smw_admit_id': mNoteData.smw_admit_id,
      'slot': mNoteData.slot,
      'date_slot': mNoteData.date_slot,
      'remark': mNoteData.remark,
      'tl_common_users_id': mNoteData.tl_common_users_id,
    };

    String api = '${TlConstant.syncApi}/save_transaction';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: createList,
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
    }
  }

  Future CreateTransectionDetail(
    BuildContext context, {
    required Map<String, String> headers_,
    required CreateTransDetailModel mNoteDataDetail,
    required ListPetModel mPetAdmit_,
    required ListUserModel mUser,
  }) async {
    int? smwTransactionId;
    final createList = {
      'tl_common_users_id': mNoteDataDetail.tl_common_users_id,
      'smw_admit_id': mNoteDataDetail.smw_admit_id,
      'slot': mNoteDataDetail.slot,
      'date_slot': mNoteDataDetail.date_slot,
      'data_card': mNoteDataDetail.dataNote.map((e) => e.toJson()).toList(),
    };

    String api = '${TlConstant.syncApi}/create_transaction_detail';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: createList,
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        smwTransactionId = response.data['body'];
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
      return smwTransactionId;
    } catch (e) {
      dialog.Error(context, 'Failed to load data. Please try again.');
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

  Future<List<NoteDetailModel>> loadObsTransection(
    BuildContext context, {
    required String visitId,
    required Map<String, String> headers_,
  }) async {
    List<NoteDetailModel> notes = [];
    String api = '${TlConstant.syncApi}/get_new_transaction';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {'visit_id': visitId},
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];

        if (body is Map<String, dynamic>) {
          final List<DataNoteModel> cardList = [];
          if (body['data_card'] is List) {
            for (var card in body['data_card']) {
              cardList.add(DataNoteModel(
                smw_transaction_order_id: card['smw_transaction_order_id'],
                smw_admit_order_id: card['smw_admit_order_id'],
                type_card: card['type_card']?.toString(),
                item_name: card['item_name']?.toString(),
                item_qty: card['item_qty'],
                unit_name: card['unit_name']?.toString(),
                dose_qty: card['dose_qty']?.toString(),
                meal_timing: card['meal_timing']?.toString(),
                drug_instruction: card['drug_instruction']?.toString(),
                remark: card['remark']?.toString(),
                item_code: card['item_code']?.toString(),
                note_to_team: card['note_to_team']?.toString(),
                caution: card['caution']?.toString(),
                drug_description: card['drug_description']?.toString(),
                time_slot: card['time_slot']?.toString(),
                drug_type_name: card['time_slot']?.toString(),
                pre_pare_status: card['pre_pare_status']?.toString(),
                date_slot: card['date_slot']?.toString(),
                save_by: card['save_by']?.toString(),
                slot: card['slot']?.toString(),
                levels: card['levels']?.toString(),
                col: card['col']?.toString(),
                comment: card['comment']?.toString(),
                status: card['status']?.toString(),
              ));
            }
          }

          notes = [
            NoteDetailModel(
              id: body['id'],
              smw_admit_id: body['smw_admit_id'],
              remark: body['remark']?.toString(),
              create_date: body['create_date']?.toString(),
              create_by: body['create_by']?.toString(),
              create_by_name: body['create_by_name']?.toString(),
              slot: body['slot']?.toString(),
              date_slot: body['date_slot']?.toString(),
              dataNote: cardList,
            )
          ];
        }
      } else if (response.data['code'] == 401) {
        if (context.mounted) {
          dialog.token(context, response.data['message']);
        }
      } else {
        if (context.mounted) {
          dialog.Error(context, response.data['message']);
        }
      }
    } catch (e) {
      if (context.mounted) {
        dialog.Error(context, 'Failed to load group codes.');
      }
    }

    return notes;
  }
}
