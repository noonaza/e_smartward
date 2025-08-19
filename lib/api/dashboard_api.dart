import 'package:dio/dio.dart';
import 'package:e_smartward/Model/dashboard_model.dart';
import 'package:e_smartward/Model/site_model.dart';
import 'package:e_smartward/Model/ward_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/show_dialog.dart';
import 'package:flutter/material.dart';

class DashboardApi {
  Future<List<DashboardModel>> loadDataDashboard(
    BuildContext context, {
    required String siteCode,
    required String ward,
    Dio? client,
  }) async {
    final dio = client ?? Dio();
    const api = '${TlConstant.syncApi}/monitor';
    final payload = {
      "type": "WARD",
      "group_id": null,
      "site_code": siteCode,
      "ward": ward,
    };

    final models = <DashboardModel>[];
    try {
      final resp = await dio.post(api, data: payload);
      final data = resp.data;
      if (data is! Map) {
        debugPrint('Unexpected response: $data');
        return models;
      }
      final code = data['code'];
      if (code == 1) {
        final body = data['body'];
        if (body is List) {
          for (final raw in body) {
            final m = raw is Map<String, dynamic>
                ? raw
                : Map<String, dynamic>.from(raw as Map);
            models.add(DashboardModel.fromJson(m));
          }
        }
      } else if (code == 401) {
        if (context.mounted) dialog.token(context, data['message']);
      } else if (code == 0) {
        if (context.mounted) dialog.Nodata(context, data['message']);
      } else {
        if (context.mounted) dialog.Error(context, data['message']);
      }
    } catch (e) {
      debugPrint('API error (/monitor): $e');
    }
    return models;
  }

  Future<List<SiteModel>> loadSite(
    BuildContext context,
  ) async {
    List<SiteModel> site = [];
    String api = '${TlConstant.syncApi}/get_site_monitor';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'area': "TLPH",
          'status': "active",
        },
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
    required String siteCode,
  }) async {
    List<WardModel> ward = [];
    String api = '${TlConstant.syncApi}/get_ward_monitor';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: {
          'site_code': siteCode,
        },
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
}
