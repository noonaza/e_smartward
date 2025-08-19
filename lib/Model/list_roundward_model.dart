// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_smartward/Model/list_data_roundward_model.dart';

class ListRoundwardModel {
  int? id;
  int? smw_admit_id;
  String? type_card;
  String? item_name;
  int? item_qty;
  String? unit_name;
  String? dose_qty;
  String? meal_timing;
  String? drug_instruction;
  String? take_time;
  String? start_date_use;
  String? end_date_use;
  String? stock_out;
  String? remark;
  String? create_date;
  String? create_by;
  String? delete_date;
  String? delete_by;
  String? order_item_id;
  String? doctor_eid;
  String? item_code;
  String? note_to_team;
  String? caution;
  String? drug_description;
  String? order_eid;
  String? order_date;
  String? order_time;
  String? drug_type_name;
  String? time_slot;
  String? unit_stock;
  String? status;
  String? update_date;
  String? dose_qty_name;
  String? update_by;
  String? total_useable;
  int? used_count;
  String? remaining;

  List<ListDataRoundwardModel>? data_trans;
  ListRoundwardModel({
    this.id,
    this.smw_admit_id,
    this.type_card,
    this.item_name,
    this.item_qty,
    this.unit_name,
    this.dose_qty,
    this.meal_timing,
    this.drug_instruction,
    this.take_time,
    this.start_date_use,
    this.end_date_use,
    this.stock_out,
    this.remark,
    this.create_date,
    this.create_by,
    this.delete_date,
    this.delete_by,
    this.order_item_id,
    this.doctor_eid,
    this.item_code,
    this.note_to_team,
    this.caution,
    this.drug_description,
    this.order_eid,
    this.order_date,
    this.order_time,
    this.drug_type_name,
    this.time_slot,
    this.unit_stock,
    this.status,
    this.update_date,
    this.dose_qty_name,
    this.update_by,
    this.total_useable,
    this.used_count,
    this.remaining,
    this.data_trans,
  });

  ListRoundwardModel copyWith({
    int? id,
    int? smw_admit_id,
    String? type_card,
    String? item_name,
    int? item_qty,
    String? unit_name,
    String? dose_qty,
    String? meal_timing,
    String? drug_instruction,
    String? take_time,
    String? start_date_use,
    String? end_date_use,
    String? stock_out,
    String? remark,
    String? create_date,
    String? create_by,
    String? delete_date,
    String? delete_by,
    String? order_item_id,
    String? doctor_eid,
    String? item_code,
    String? note_to_team,
    String? caution,
    String? drug_description,
    String? order_eid,
    String? order_date,
    String? order_time,
    String? drug_type_name,
    String? time_slot,
    String? unit_stock,
    String? status,
    String? update_date,
    String? dose_qty_name,
    String? update_by,
    String? total_useable,
    int? used_count,
    String? remaining,
    List<ListDataRoundwardModel>? data_trans,
  }) {
    return ListRoundwardModel(
      id: id ?? this.id,
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      type_card: type_card ?? this.type_card,
      item_name: item_name ?? this.item_name,
      item_qty: item_qty ?? this.item_qty,
      unit_name: unit_name ?? this.unit_name,
      dose_qty: dose_qty ?? this.dose_qty,
      meal_timing: meal_timing ?? this.meal_timing,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      take_time: take_time ?? this.take_time,
      start_date_use: start_date_use ?? this.start_date_use,
      end_date_use: end_date_use ?? this.end_date_use,
      stock_out: stock_out ?? this.stock_out,
      remark: remark ?? this.remark,
      create_date: create_date ?? this.create_date,
      create_by: create_by ?? this.create_by,
      delete_date: delete_date ?? this.delete_date,
      delete_by: delete_by ?? this.delete_by,
      order_item_id: order_item_id ?? this.order_item_id,
      doctor_eid: doctor_eid ?? this.doctor_eid,
      item_code: item_code ?? this.item_code,
      note_to_team: note_to_team ?? this.note_to_team,
      caution: caution ?? this.caution,
      drug_description: drug_description ?? this.drug_description,
      order_eid: order_eid ?? this.order_eid,
      order_date: order_date ?? this.order_date,
      order_time: order_time ?? this.order_time,
      drug_type_name: drug_type_name ?? this.drug_type_name,
      time_slot: time_slot ?? this.time_slot,
      unit_stock: unit_stock ?? this.unit_stock,
      status: status ?? this.status,
      update_date: update_date ?? this.update_date,
      dose_qty_name: dose_qty_name ?? this.dose_qty_name,
      update_by: update_by ?? this.update_by,
      total_useable: total_useable ?? this.total_useable,
      used_count: used_count ?? this.used_count,
      remaining: remaining ?? this.remaining,
      data_trans: data_trans ?? this.data_trans,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'smw_admit_id': smw_admit_id,
      'type_card': type_card,
      'item_name': item_name,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'dose_qty': dose_qty,
      'meal_timing': meal_timing,
      'drug_instruction': drug_instruction,
      'take_time': take_time,
      'start_date_use': start_date_use,
      'end_date_use': end_date_use,
      'stock_out': stock_out,
      'remark': remark,
      'create_date': create_date,
      'create_by': create_by,
      'delete_date': delete_date,
      'delete_by': delete_by,
      'order_item_id': order_item_id,
      'doctor_eid': doctor_eid,
      'item_code': item_code,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'order_eid': order_eid,
      'order_date': order_date,
      'order_time': order_time,
      'drug_type_name': drug_type_name,
      'time_slot': time_slot,
      'unit_stock': unit_stock,
      'status': status,
      'update_date': update_date,
      'dose_qty_name': dose_qty_name,
      'update_by': update_by,
      'total_useable': total_useable,
      'used_count': used_count,
      'remaining': remaining,
      'data_trans': data_trans!.map((x) => x.toMap()).toList(),
    };
  }

  factory ListRoundwardModel.fromMap(Map<String, dynamic> map) {
    return ListRoundwardModel(
      id: map['id'] != null ? map['id'] as int : null,
      smw_admit_id: map['smw_admit_id'] != null ? map['smw_admit_id'] as int : null,
      type_card: map['type_card'] != null ? map['type_card'] as String : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as int : null,
      unit_name: map['unit_name'] != null ? map['unit_name'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      meal_timing: map['meal_timing'] != null ? map['meal_timing'] as String : null,
      drug_instruction: map['drug_instruction'] != null ? map['drug_instruction'] as String : null,
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      start_date_use: map['start_date_use'] != null ? map['start_date_use'] as String : null,
      end_date_use: map['end_date_use'] != null ? map['end_date_use'] as String : null,
      stock_out: map['stock_out'] != null ? map['stock_out'] as String : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      create_by: map['create_by'] != null ? map['create_by'] as String : null,
      delete_date: map['delete_date'] != null ? map['delete_date'] as String : null,
      delete_by: map['delete_by'] != null ? map['delete_by'] as String : null,
      order_item_id: map['order_item_id'] != null ? map['order_item_id'] as String : null,
      doctor_eid: map['doctor_eid'] != null ? map['doctor_eid'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      note_to_team: map['note_to_team'] != null ? map['note_to_team'] as String : null,
      caution: map['caution'] != null ? map['caution'] as String : null,
      drug_description: map['drug_description'] != null ? map['drug_description'] as String : null,
      order_eid: map['order_eid'] != null ? map['order_eid'] as String : null,
      order_date: map['order_date'] != null ? map['order_date'] as String : null,
      order_time: map['order_time'] != null ? map['order_time'] as String : null,
      drug_type_name: map['drug_type_name'] != null ? map['drug_type_name'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      unit_stock: map['unit_stock'] != null ? map['unit_stock'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      update_date: map['update_date'] != null ? map['update_date'] as String : null,
      dose_qty_name: map['dose_qty_name'] != null ? map['dose_qty_name'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      total_useable: map['total_useable'] != null ? map['total_useable'] as String : null,
      used_count: map['used_count'] != null ? map['used_count'] as int : null,
      remaining: map['remaining'] != null ? map['remaining'] as String : null,
      data_trans: map['data_trans'] != null ? List<ListDataRoundwardModel>.from((map['data_trans'] as List<int>).map<ListDataRoundwardModel?>((x) => ListDataRoundwardModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListRoundwardModel.fromJson(String source) =>
      ListRoundwardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListRoundwardModel(id: $id, smw_admit_id: $smw_admit_id, type_card: $type_card, item_name: $item_name, item_qty: $item_qty, unit_name: $unit_name, dose_qty: $dose_qty, meal_timing: $meal_timing, drug_instruction: $drug_instruction, take_time: $take_time, start_date_use: $start_date_use, end_date_use: $end_date_use, stock_out: $stock_out, remark: $remark, create_date: $create_date, create_by: $create_by, delete_date: $delete_date, delete_by: $delete_by, order_item_id: $order_item_id, doctor_eid: $doctor_eid, item_code: $item_code, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, order_eid: $order_eid, order_date: $order_date, order_time: $order_time, drug_type_name: $drug_type_name, time_slot: $time_slot, unit_stock: $unit_stock, status: $status, update_date: $update_date, dose_qty_name: $dose_qty_name, update_by: $update_by, total_useable: $total_useable, used_count: $used_count, remaining: $remaining, data_trans: $data_trans)';
  }

  @override
  bool operator ==(covariant ListRoundwardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.smw_admit_id == smw_admit_id &&
      other.type_card == type_card &&
      other.item_name == item_name &&
      other.item_qty == item_qty &&
      other.unit_name == unit_name &&
      other.dose_qty == dose_qty &&
      other.meal_timing == meal_timing &&
      other.drug_instruction == drug_instruction &&
      other.take_time == take_time &&
      other.start_date_use == start_date_use &&
      other.end_date_use == end_date_use &&
      other.stock_out == stock_out &&
      other.remark == remark &&
      other.create_date == create_date &&
      other.create_by == create_by &&
      other.delete_date == delete_date &&
      other.delete_by == delete_by &&
      other.order_item_id == order_item_id &&
      other.doctor_eid == doctor_eid &&
      other.item_code == item_code &&
      other.note_to_team == note_to_team &&
      other.caution == caution &&
      other.drug_description == drug_description &&
      other.order_eid == order_eid &&
      other.order_date == order_date &&
      other.order_time == order_time &&
      other.drug_type_name == drug_type_name &&
      other.time_slot == time_slot &&
      other.unit_stock == unit_stock &&
      other.status == status &&
      other.update_date == update_date &&
      other.dose_qty_name == dose_qty_name &&
      other.update_by == update_by &&
      other.total_useable == total_useable &&
      other.used_count == used_count &&
      other.remaining == remaining &&
      listEquals(other.data_trans, data_trans);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      smw_admit_id.hashCode ^
      type_card.hashCode ^
      item_name.hashCode ^
      item_qty.hashCode ^
      unit_name.hashCode ^
      dose_qty.hashCode ^
      meal_timing.hashCode ^
      drug_instruction.hashCode ^
      take_time.hashCode ^
      start_date_use.hashCode ^
      end_date_use.hashCode ^
      stock_out.hashCode ^
      remark.hashCode ^
      create_date.hashCode ^
      create_by.hashCode ^
      delete_date.hashCode ^
      delete_by.hashCode ^
      order_item_id.hashCode ^
      doctor_eid.hashCode ^
      item_code.hashCode ^
      note_to_team.hashCode ^
      caution.hashCode ^
      drug_description.hashCode ^
      order_eid.hashCode ^
      order_date.hashCode ^
      order_time.hashCode ^
      drug_type_name.hashCode ^
      time_slot.hashCode ^
      unit_stock.hashCode ^
      status.hashCode ^
      update_date.hashCode ^
      dose_qty_name.hashCode ^
      update_by.hashCode ^
      total_useable.hashCode ^
      used_count.hashCode ^
      remaining.hashCode ^
      data_trans.hashCode;
  }
}
