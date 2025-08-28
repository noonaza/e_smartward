// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DashboardModel {
  int? id;
  String? hn_number;
  String? an_number;
  String? visit_number;
  String? ipet_name;
  String? create_date;
  int? create_by;
  String? iowner_name;
  String? ipet_type;
  String? ibase_site_branch_id;
  String? iward;
  String? ibed_number;
  String? idoctor;
  List<String>? take_time_all;
  String? slot_now;
  String? date_slot_now;
  LastTransaction? last_transaction;
  String? status_now_slot;
  String? status_now;
  int? to_do_food;
  int? to_do_drug;
   int? to_do_idrug;

  DashboardModel({
    this.id,
    this.hn_number,
    this.an_number,
    this.visit_number,
    this.ipet_name,
    this.create_date,
    this.create_by,
    this.iowner_name,
    this.ipet_type,
    this.ibase_site_branch_id,
    this.iward,
    this.ibed_number,
    this.idoctor,
    this.take_time_all,
    this.slot_now,
    this.date_slot_now,
    this.last_transaction,
    this.status_now_slot,
    this.status_now,
    this.to_do_food,   
    this.to_do_drug,  
    this.to_do_idrug,  
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: _asInt(json['id']),
      hn_number: json['hn_number']?.toString(),
      an_number: json['an_number']?.toString(),
      visit_number: json['visit_number']?.toString(),
      ipet_name: json['ipet_name']?.toString(),
      create_date: json['create_date']?.toString(),
      create_by: _asInt(json['create_by']),
      iowner_name: json['iowner_name']?.toString(),
      ipet_type: json['ipet_type']?.toString(),
      ibase_site_branch_id: json['ibase_site_branch_id']?.toString(),
      iward: json['iward']?.toString(),
      ibed_number: json['ibed_number']?.toString(),
      idoctor: json['_doctor']?.toString(),
      take_time_all: _parseTimes(json['take_time_all']),
      slot_now: json['slot_now']?.toString(),
      date_slot_now: json['date_slot_now']?.toString(),
      last_transaction: (json['last_transaction'] is Map<String, dynamic>)
          ? LastTransaction.fromJson(
              Map<String, dynamic>.from(json['last_transaction']))
          : null,
      status_now_slot: json['status_now_slot']?.toString(),
      status_now: json['status_now']?.toString(),
      to_do_food: _asInt(json['to_do_food']),  
      to_do_drug: _asInt(json['to_do_drug']),
      to_do_idrug: _asInt(json['to_do_idrug']),    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hn_number': hn_number,
      'an_number': an_number,
      'visit_number': visit_number,
      'ipet_name': ipet_name,
      'create_date': create_date,
      'create_by': create_by,
      'iowner_name': iowner_name,
      'ipet_type': ipet_type,
      'ibase_site_branch_id': ibase_site_branch_id,
      'iward': iward,
      'ibed_number': ibed_number,
      'idoctor': idoctor,
      'take_time_all': take_time_all,
      'slot_now': slot_now,
      'date_slot_now': date_slot_now,
      'last_transaction': last_transaction?.toJson(),
      'status_now_slot': status_now_slot,
      'status_now': status_now,
      'to_do_food': to_do_food,   
      'to_do_drug': to_do_drug,
      'to_do_idrug': to_do_idrug,    
    };
  }

  // ===== helpers =====
  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static List<String>? _parseTimes(dynamic v) {
    if (v == null) return null;
    if (v is List) {
      return v
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (v is String && v.trim().isNotEmpty) {
      return v
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return null;
  }
}


class LastTransaction {
  int? id;
  int? smw_admit_id;
  String? remark;
  String? create_date;
  int? create_by;
  String? slot;
  String? date_slot;
  List<DashboardModel> dataList;

  LastTransaction({
    this.id,
    this.smw_admit_id,
    this.remark,
    this.create_date,
    this.create_by,
    this.slot,
    this.date_slot,
    this.dataList = const [],
  });

  factory LastTransaction.fromJson(Map<String, dynamic> json) {
    List<DashboardModel> dList = [];
    if (json['data_data'] is List) {
      dList = (json['data_data'] as List)
          .map((e) => DashboardModel.fromJson(
                e is Map<String, dynamic>
                    ? e
                    : Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    }
    return LastTransaction(
      id: DashboardModel._asInt(json['id']),
      smw_admit_id: DashboardModel._asInt(json['smw_admit_id']),
      remark: json['remark']?.toString(),
      create_date: json['create_date']?.toString(),
      create_by: DashboardModel._asInt(json['create_by']),
      slot: json['slot']?.toString(),
      date_slot: json['date_slot']?.toString(),
      dataList: dList, // ✅ สำคัญ
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'smw_admit_id': smw_admit_id,
      'remark': remark,
      'create_date': create_date,
      'create_by': create_by,
      'slot': slot,
      'date_slot': date_slot,
      'data_data': dataList.map((e) => e.toJson()).toList(),
    };
  }
}
