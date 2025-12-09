// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CreateTransectionModel {
  final int smw_admit_id;
  final String slot;
  final String date_slot;
  final String remark;
  final int tl_common_users_id;
  final List<DataTransectionModel> dataNote;

  CreateTransectionModel({
    required this.smw_admit_id,
    required this.slot,
    required this.date_slot,
    required this.remark,
    required this.tl_common_users_id,
    required this.dataNote,
  });

  CreateTransectionModel copyWith({
    int? smw_admit_id,
    String? slot,
    String? date_slot,
    String? remark,
    int? tl_common_users_id,
    List<DataTransectionModel>? dataNote,
  }) {
    return CreateTransectionModel(
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      slot: slot ?? this.slot,
      date_slot: date_slot ?? this.date_slot,
      remark: remark ?? this.remark,
      tl_common_users_id: tl_common_users_id ?? this.tl_common_users_id,
      dataNote: dataNote ?? this.dataNote,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'smw_admit_id': smw_admit_id,
      'slot': slot,
      'date_slot': date_slot,
      'remark': remark,
      'tl_common_users_id': tl_common_users_id,
      'dataNote': dataNote.map((x) => x.toJson()).toList(),
    };
  }

  factory CreateTransectionModel.fromMap(Map<String, dynamic> map) {
    return CreateTransectionModel(
      smw_admit_id: map['smw_admit_id'] ?? 0,
      slot: map['slot'] ?? '',
      date_slot: map['date_slot'] ?? '',
      remark: map['remark'] ?? '',
      tl_common_users_id: map['tl_common_users_id'] ?? 0,
      dataNote: List<DataTransectionModel>.from(
        (map['dataNote'] as List).map((x) => DataTransectionModel.fromJson(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateTransectionModel.fromJson(String source) =>
      CreateTransectionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateTransectionModel(smw_admit_id: $smw_admit_id, slot: $slot, date_slot: $date_slot, remark: $remark, tl_common_users_id: $tl_common_users_id, dataNote: $dataNote)';
  }

  @override
  bool operator ==(covariant CreateTransectionModel other) {
    if (identical(this, other)) return true;
    return smw_admit_id == other.smw_admit_id &&
        slot == other.slot &&
        date_slot == other.date_slot &&
        remark == other.remark &&
        tl_common_users_id == other.tl_common_users_id &&
        listEquals(dataNote, other.dataNote);
  }

  @override
  int get hashCode {
    return smw_admit_id.hashCode ^
        slot.hashCode ^
        date_slot.hashCode ^
        remark.hashCode ^
        tl_common_users_id.hashCode ^
        dataNote.hashCode;
  }
}

class FileModel {
  // final int? id;
  final String path;
  final String remark;

  FileModel({
    required this.path,
    required this.remark,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      path: json['path_file'] ?? '',
      remark: json['remark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'remark': remark,
    };
  }

  toMap() {}

  static fromMap(Map<String, dynamic> x) {}
}

class DataTransectionModel {
  final int? smw_transaction_order_id;
  final int smw_admit_order_id;
  final String type_card;
  final String item_name;
  final int item_qty;
  final String unit_name;
  final String dose_qty;
  final String meel_status;
  final String drug_instruction;
  final String remark;
  final String item_code;
  final String note_to_team;
  final String? caution;
  final String drug_description;
  final String time_slot;
  late final String pre_pare_status;
  final String date_slot;
  final String slot;
  final String status;
  final String? comment;
  final String? doctor;
  String? feed;
  final String? col;
  final String? levels;
  List<FileModel>? file;

  DataTransectionModel({
    this.smw_transaction_order_id,
    required this.smw_admit_order_id,
    required this.type_card,
    required this.item_name,
    required this.item_qty,
    required this.unit_name,
    required this.dose_qty,
    required this.meel_status,
    required this.drug_instruction,
    required this.remark,
    required this.item_code,
    required this.note_to_team,
    this.caution,
    required this.drug_description,
    required this.time_slot,
    required this.pre_pare_status,
    required this.date_slot,
    required this.slot,
    required this.status,
    this.comment,
    this.doctor,
    this.feed,
    this.col,
    this.levels,
    required this.file,
  });

  factory DataTransectionModel.fromJson(Map<String, dynamic> json) {
    return DataTransectionModel(
      smw_transaction_order_id: json['smw_transaction_order_id'],
      smw_admit_order_id: json['smw_admit_order_id'],
      type_card: json['type_card'],
      item_name: json['item_name'],
      item_qty: json['item_qty'],
      unit_name: json['unit_name'],
      dose_qty: json['dose_qty'],
      meel_status: json['meal_timing'],
      drug_instruction: json['drug_instruction'],
      remark: json['remark'],
      item_code: json['item_code'],
      note_to_team: json['note_to_team'],
      caution: json['caution'],
      drug_description: json['drug_description'],
      time_slot: json['time_slot'],
      pre_pare_status: json['pre_pare_status'],
      date_slot: json['date_slot'],
      slot: json['slot'],
      doctor: json['doctor'],
      feed: json['feed'],
      status: json['status'],
      comment: json['comment'],
      col: json['col'],
      levels: json['levels'],
      file: (json['file'] as List<dynamic>?)
              ?.map((e) => FileModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'smw_transaction_order_id': smw_transaction_order_id,
      'smw_admit_order_id': smw_admit_order_id,
      'type_card': type_card,
      'item_name': item_name,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'dose_qty': dose_qty,
      'meal_timing': meel_status,
      'drug_instruction': drug_instruction,
      'remark': remark,
      'item_code': item_code,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'time_slot': time_slot,
      'pre_pare_status': pre_pare_status,
      'date_slot': date_slot,
      'slot': slot,
      'status': status,
      'doctor': doctor,
      'feed': feed,
      'comment': comment,
      'col': col,
      'levels': levels,
      'file': file?.map((f) => f.toJson()).toList(),
    };
  }

  toMap() {}

  static fromMap(Map<String, dynamic> x) {}
}
