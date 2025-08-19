// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_smartward/Model/create_transection_model.dart';

class CreateTransDetailModel {
  final int smw_admit_id;
  final String slot;
  final String date_slot;
  final int tl_common_users_id;
  final List<DataTransectionModel> dataNote;
  CreateTransDetailModel({
    required this.smw_admit_id,
    required this.slot,
    required this.date_slot,
    required this.tl_common_users_id,
    required this.dataNote,
  });

  CreateTransDetailModel copyWith({
    int? smw_admit_id,
    String? slot,
    String? date_slot,
    int? tl_common_users_id,
    List<DataTransectionModel>? dataNote,
  }) {
    return CreateTransDetailModel(
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      slot: slot ?? this.slot,
      date_slot: date_slot ?? this.date_slot,
      tl_common_users_id: tl_common_users_id ?? this.tl_common_users_id,
      dataNote: dataNote ?? this.dataNote,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'smw_admit_id': smw_admit_id,
      'slot': slot,
      'date_slot': date_slot,
      'tl_common_users_id': tl_common_users_id,
      'dataNote': dataNote.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateTransDetailModel.fromMap(Map<String, dynamic> map) {
    return CreateTransDetailModel(
      smw_admit_id: (map['smw_admit_id'] ?? 0) as int,
      slot: (map['slot'] ?? '') as String,
      date_slot: (map['date_slot'] ?? '') as String,
      tl_common_users_id: (map['tl_common_users_id'] ?? 0) as int,
      dataNote: List<DataTransectionModel>.from((map['dataNote'] as List<int>).map<DataTransectionModel>((x) => DataTransectionModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateTransDetailModel.fromJson(String source) => CreateTransDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreateTransDetailModel(smw_admit_id: $smw_admit_id, slot: $slot, date_slot: $date_slot, tl_common_users_id: $tl_common_users_id, dataNote: $dataNote)';
  }

  @override
  bool operator ==(covariant CreateTransDetailModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.smw_admit_id == smw_admit_id &&
      other.slot == slot &&
      other.date_slot == date_slot &&
      other.tl_common_users_id == tl_common_users_id &&
      listEquals(other.dataNote, dataNote);
  }

  @override
  int get hashCode {
    return smw_admit_id.hashCode ^
      slot.hashCode ^
      date_slot.hashCode ^
      tl_common_users_id.hashCode ^
      dataNote.hashCode;
  }
}
