import 'package:dio/dio.dart';
import 'package:e_smartward/Model/chat_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:flutter/material.dart';

class ChatApi {
  loadAutoChat(
    BuildContext context, {
    required Map<String, String> headers_,
    required visitId,
  }) async {
    List<ChatModel> dataChat = [];
    String api = '${TlConstant.syncApi}/get_chat';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'visit_id': visitId,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        if (response.data['body'] is List) {
          dataChat = (response.data['body'] as List).map((item) {
            return ChatModel(
              id: item['id'] is int
                  ? item['id']
                  : int.tryParse(item['id'].toString()),
              type_message: item['type_message'],
              message: item['message'],
              create_by: item['create_by'] is int
                  ? item['create_by']
                  : int.tryParse(item['create_by'].toString()),
              create_date: item['create_date'],
              update_by: item['update_by'] is int
                  ? item['update_by']
                  : int.tryParse(item['update_by'].toString()),
              visit_number: item['visit_number'],
              update_date: item['update_date'],
              create_by_name: item['create_by_name'],
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

    return dataChat;
  }

  CreateChat(
    BuildContext context, {
    required Map<String, String> headers_,
    required String visitId,
    required String typeMessage,
    required String message,
    required tlCommonUsersId,
  }) async {
    const String api = '${TlConstant.syncApi}/create_chat';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'visit_id': visitId,
          'type_message': typeMessage,
          'message': message,
          'tl_common_users_id': tlCommonUsersId,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        final int? chatId = body is int ? body : int.tryParse(body.toString());
        return chatId;
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to create chat. Please try again.');
    }

    return null;
  }

  EditChat(
    BuildContext context, {
    required Map<String, String> headers_,
    required int id,
    required String typeMessage,
    required String message,
    required tlCommonUsersId,
  }) async {
    const String api = '${TlConstant.syncApi}/edit_chat';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'id': id,
          'type_message': typeMessage,
          'tl_common_users_id': tlCommonUsersId,
        },
        options: Options(headers: headers_),
      );

      if (response.data['code'] == 1) {
        final body = response.data['body'];
        final int? chatId = body is int ? body : int.tryParse(body.toString());
        return chatId;
      } else if (response.data['code'] == 401) {
        dialog.token(context, response.data['message']);
      } else {
        dialog.Error(context, response.data['message']);
      }
    } catch (e) {
      dialog.Error(context, 'Failed to create chat. Please try again.');
    }

    return null;
  }
}
