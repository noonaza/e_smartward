// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:e_smartward/Model/list_data_roundward_model.dart';

class ListDataCardModel {
  int? id;
  String? visit_id;
  String? smw_admit_id;
  String? order_item_id;
  String? doctor_eid;
  String? item_code;
  String? item_name;
  int? item_qty;
  String? unit_name;
  String? take_time;
  String? time_slot;
  String? meal_timing;
  String? dose_qty;
  int? stock_out;
  String? remark;
  String? dose_unit_name;
  String? base_drug_usage_code;
  String? drug_instruction;
  String? fix_item_type_id;
  String? item_type_name;
  String? drug_type_id;
  String? patient_age;
  String? drug_type_name;
  String? note_to_team;
  String? caution;
  String? drug_description;
  String? start_date_use;
  String? end_date_use;
  String? order_eid;
  String? order_date;
  String? order_time;
  String? unit_stock;
  String? status;
  String? update_date;
  String? update_by;
   String? dose_qty_name;

  ListDataCardModel({
    this.id,
    this.visit_id,
    this.smw_admit_id,
    this.order_item_id,
    this.doctor_eid,
    this.item_code,
    this.item_name,
    this.item_qty,
    this.unit_name,
    this.take_time,
    this.time_slot,
    this.meal_timing,
    this.dose_qty,
    this.stock_out,
    this.remark,
    this.dose_unit_name,
    this.base_drug_usage_code,
    this.drug_instruction,
    this.fix_item_type_id,
    this.item_type_name,
    this.drug_type_id,
    this.patient_age,
    this.drug_type_name,
    this.note_to_team,
    this.caution,
    this.drug_description,
    this.start_date_use,
    this.end_date_use,
    this.order_eid,
    this.order_date,
    this.order_time,
    this.unit_stock,
    this.status,
    this.update_date,
    this.update_by,
    this.dose_qty_name,
  });

  factory ListDataCardModel.fromJson(Map<String, dynamic> json) {
    return ListDataCardModel(
      id: json['id'],
      visit_id: json['visit_id'],
      smw_admit_id: json['smw_admit_id'],
      order_item_id: json['order_item_id'],
      doctor_eid: json['doctor_eid'],
      item_code: json['item_code'],
      item_name: json['item_name'],
      time_slot: json['time_slot'],
      item_qty: json['item_qty'],
      unit_name: json['unit_name'],
      take_time: json['take_time'],
      meal_timing: json['meal_timing'],
      dose_qty: json['dose_qty'],
      stock_out: json['stock_out'],
      remark: json['remark'],
      dose_unit_name: json['dose_unit_name'],
      base_drug_usage_code: json['base_drug_usage_code'],
      drug_instruction: json['drug_instruction'],
      fix_item_type_id: json['fix_item_type_id'],
      item_type_name: json['item_type_name'],
      drug_type_id: json['drug_type_id'],
      patient_age: json['patient_age'],
      drug_type_name: json['drug_type_name'],
      note_to_team: json['note_to_team'],
      caution: json['caution'],
      drug_description: json['drug_description'],
      start_date_use: json['start_date_use'],
      end_date_use: json['end_date_use'],
      order_eid: json['order_eid'],
      order_date: json['order_date'],
      order_time: json['order_time'],
      unit_stock: json['unit_stock'],
      status: json['status'],
      update_date: json['update_date'],
      update_by: json['update_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visit_id,
      'smw_admit_id': smw_admit_id,
      'order_item_id': order_item_id,
      'doctor_eid': doctor_eid,
      'item_code': item_code,
      'item_name': item_name,
      'time_slot': time_slot,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'take_time': take_time,
      'meal_timing': meal_timing,
      'dose_qty': dose_qty,
      'stock_out': stock_out,
      'remark': remark,
      'dose_unit_name': dose_unit_name,
      'base_drug_usage_code': base_drug_usage_code,
      'drug_instruction': drug_instruction,
      'fix_item_type_id': fix_item_type_id,
      'item_type_name': item_type_name,
      'drug_type_id': drug_type_id,
      'patient_age': patient_age,
      'drug_type_name': drug_type_name,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'start_date_use': start_date_use,
      'end_date_use': end_date_use,
      'order_eid': order_eid,
      'order_date': order_date,
      'order_time': order_time,
      'unit_stock': unit_stock,
      'status': status,
      'update_date': update_date,
      'update_by': update_by,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  static ListDataCardModel fromMap(Map<String, dynamic> x) =>
      ListDataCardModel.fromJson(x);

  @override
  String toString() {
    return 'ListDataCardModel(id: $id, visit_id: $visit_id, smw_admit_id: $smw_admit_id, order_item_id: $order_item_id, doctor_eid: $doctor_eid, item_code: $item_code, item_name: $item_name, time_slot: $time_slot, item_qty: $item_qty, unit_name: $unit_name, take_time: $take_time, meal_timing: $meal_timing, dose_qty: $dose_qty, stock_out: $stock_out, remark: $remark, dose_unit_name: $dose_unit_name, base_drug_usage_code: $base_drug_usage_code, drug_instruction: $drug_instruction, fix_item_type_id: $fix_item_type_id, item_type_name: $item_type_name, drug_type_id: $drug_type_id, patient_age: $patient_age, drug_type_name: $drug_type_name, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, start_date_use: $start_date_use, end_date_use: $end_date_use, order_eid: $order_eid, order_date: $order_date, order_time: $order_time, unit_stock: $unit_stock, status: $status, update_date: $update_date, update_by: $update_by)';
  }
}
