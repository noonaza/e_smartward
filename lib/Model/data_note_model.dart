// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_smartward/Model/create_transection_model.dart';

class DataNoteModel {
  int? smw_transaction_order_id;
  int? smw_admit_order_id;
  String? type_card;
  String? item_name;
  int? item_qty;
  String? unit_name;
  String? dose_qty;
  String? meal_timing;
  String? drug_instruction;
  String? remark;
  String? item_code;
  String? note_to_team;
  String? caution;
  String? drug_description;
  String? time_slot;
  String? pre_pare_status;
  String? drug_type_name;
  String? date_slot;
  String? slot;
  String? save_by;
  String? save_by_name;
  String? create_date;
  String? comment;
  String? doctor;
  String? status;
  int? file_count;
  List<FileModel>? file;

  DataNoteModel({
    this.smw_transaction_order_id,
    this.smw_admit_order_id,
    this.type_card,
    this.item_name,
    this.item_qty,
    this.unit_name,
    this.dose_qty,
    this.meal_timing,
    this.drug_instruction,
    this.remark,
    this.item_code,
    this.note_to_team,
    this.caution,
    this.drug_description,
    this.time_slot,
    this.pre_pare_status,
    this.drug_type_name,
    this.date_slot,
    this.slot,
    this.save_by,
    this.save_by_name,
    this.create_date,
    this.comment,
    this.doctor,
    this.status,
    this.file_count,
    this.file,
  });

  get id => null;

  get ref_id => null;

  DataNoteModel copyWith({
    int? smw_transaction_order_id,
    int? smw_admit_order_id,
    String? type_card,
    String? item_name,
    int? item_qty,
    String? unit_name,
    String? dose_qty,
    String? meal_timing,
    String? drug_instruction,
    String? remark,
    String? item_code,
    String? note_to_team,
    String? caution,
    String? drug_description,
    String? time_slot,
    String? pre_pare_status,
    String? drug_type_name,
    String? date_slot,
    String? slot,
    String? save_by,
    String? save_by_name,
    String? create_date,
    String? comment,
    String? doctor,
    String? status,
    int? file_count,
    List<FileModel>? file,
  }) {
    return DataNoteModel(
      smw_transaction_order_id: smw_transaction_order_id ?? this.smw_transaction_order_id,
      smw_admit_order_id: smw_admit_order_id ?? this.smw_admit_order_id,
      type_card: type_card ?? this.type_card,
      item_name: item_name ?? this.item_name,
      item_qty: item_qty ?? this.item_qty,
      unit_name: unit_name ?? this.unit_name,
      dose_qty: dose_qty ?? this.dose_qty,
      meal_timing: meal_timing ?? this.meal_timing,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      remark: remark ?? this.remark,
      item_code: item_code ?? this.item_code,
      note_to_team: note_to_team ?? this.note_to_team,
      caution: caution ?? this.caution,
      drug_description: drug_description ?? this.drug_description,
      time_slot: time_slot ?? this.time_slot,
      pre_pare_status: pre_pare_status ?? this.pre_pare_status,
      drug_type_name: drug_type_name ?? this.drug_type_name,
      date_slot: date_slot ?? this.date_slot,
      slot: slot ?? this.slot,
      save_by: save_by ?? this.save_by,
      save_by_name: save_by_name ?? this.save_by_name,
      create_date: create_date ?? this.create_date,
      comment: comment ?? this.comment,
      doctor: doctor ?? this.doctor,
      status: status ?? this.status,
      file_count: file_count ?? this.file_count,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'smw_transaction_order_id': smw_transaction_order_id,
      'smw_admit_order_id': smw_admit_order_id,
      'type_card': type_card,
      'item_name': item_name,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'dose_qty': dose_qty,
      'meal_timing': meal_timing,
      'drug_instruction': drug_instruction,
      'remark': remark,
      'item_code': item_code,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'time_slot': time_slot,
      'pre_pare_status': pre_pare_status,
      'drug_type_name': drug_type_name,
      'date_slot': date_slot,
      'slot': slot,
      'save_by': save_by,
      'save_by_name': save_by_name,
      'create_date': create_date,
      'comment': comment,
      'doctor': doctor,
      'status': status,
      'file_count': file_count,
      'file': file?.map((x) => x?.toMap()).toList(),
    };
  }

  factory DataNoteModel.fromMap(Map<String, dynamic> map) {
    return DataNoteModel(
      smw_transaction_order_id: map['smw_transaction_order_id'] != null ? map['smw_transaction_order_id'] as int : null,
      smw_admit_order_id: map['smw_admit_order_id'] != null ? map['smw_admit_order_id'] as int : null,
      type_card: map['type_card'] != null ? map['type_card'] as String : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as int : null,
      unit_name: map['unit_name'] != null ? map['unit_name'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      meal_timing: map['meal_timing'] != null ? map['meal_timing'] as String : null,
      drug_instruction: map['drug_instruction'] != null ? map['drug_instruction'] as String : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      note_to_team: map['note_to_team'] != null ? map['note_to_team'] as String : null,
      caution: map['caution'] != null ? map['caution'] as String : null,
      drug_description: map['drug_description'] != null ? map['drug_description'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      pre_pare_status: map['pre_pare_status'] != null ? map['pre_pare_status'] as String : null,
      drug_type_name: map['drug_type_name'] != null ? map['drug_type_name'] as String : null,
      date_slot: map['date_slot'] != null ? map['date_slot'] as String : null,
      slot: map['slot'] != null ? map['slot'] as String : null,
      save_by: map['save_by'] != null ? map['save_by'] as String : null,
      save_by_name: map['save_by_name'] != null ? map['save_by_name'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      doctor: map['doctor'] != null ? map['doctor'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      file_count: map['file_count'] != null ? map['file_count'] as int : null,
      file: map['file'] != null ? List<FileModel>.from((map['file'] as List<int>).map<FileModel?>((x) => FileModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataNoteModel.fromJson(String source) =>
      DataNoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataNoteModel(smw_transaction_order_id: $smw_transaction_order_id, smw_admit_order_id: $smw_admit_order_id, type_card: $type_card, item_name: $item_name, item_qty: $item_qty, unit_name: $unit_name, dose_qty: $dose_qty, meal_timing: $meal_timing, drug_instruction: $drug_instruction, remark: $remark, item_code: $item_code, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, time_slot: $time_slot, pre_pare_status: $pre_pare_status, drug_type_name: $drug_type_name, date_slot: $date_slot, slot: $slot, save_by: $save_by, save_by_name: $save_by_name, create_date: $create_date, comment: $comment, doctor: $doctor, status: $status, file_count: $file_count, file: $file)';
  }

  @override
  bool operator ==(covariant DataNoteModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.smw_transaction_order_id == smw_transaction_order_id &&
      other.smw_admit_order_id == smw_admit_order_id &&
      other.type_card == type_card &&
      other.item_name == item_name &&
      other.item_qty == item_qty &&
      other.unit_name == unit_name &&
      other.dose_qty == dose_qty &&
      other.meal_timing == meal_timing &&
      other.drug_instruction == drug_instruction &&
      other.remark == remark &&
      other.item_code == item_code &&
      other.note_to_team == note_to_team &&
      other.caution == caution &&
      other.drug_description == drug_description &&
      other.time_slot == time_slot &&
      other.pre_pare_status == pre_pare_status &&
      other.drug_type_name == drug_type_name &&
      other.date_slot == date_slot &&
      other.slot == slot &&
      other.save_by == save_by &&
      other.save_by_name == save_by_name &&
      other.create_date == create_date &&
      other.comment == comment &&
      other.doctor == doctor &&
      other.status == status &&
      other.file_count == file_count &&
      listEquals(other.file, file);
  }

  @override
  int get hashCode {
    return smw_transaction_order_id.hashCode ^
      smw_admit_order_id.hashCode ^
      type_card.hashCode ^
      item_name.hashCode ^
      item_qty.hashCode ^
      unit_name.hashCode ^
      dose_qty.hashCode ^
      meal_timing.hashCode ^
      drug_instruction.hashCode ^
      remark.hashCode ^
      item_code.hashCode ^
      note_to_team.hashCode ^
      caution.hashCode ^
      drug_description.hashCode ^
      time_slot.hashCode ^
      pre_pare_status.hashCode ^
      drug_type_name.hashCode ^
      date_slot.hashCode ^
      slot.hashCode ^
      save_by.hashCode ^
      save_by_name.hashCode ^
      create_date.hashCode ^
      comment.hashCode ^
      doctor.hashCode ^
      status.hashCode ^
      file_count.hashCode ^
      file.hashCode;
  }

  map(Function(dynamic e) param0) {}
}
