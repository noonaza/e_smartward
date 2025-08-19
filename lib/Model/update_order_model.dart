// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateOrderModel {
  int? id;
  String? item_name;
  int? item_qty;
  String? unit_name;
  String? dose_qty;
  String? meal_timing;
  String? drug_instruction;
  String? take_time;
  String? start_date_use;
  String? end_date_use;
  int? stock_out;
  String? note_to_team;
  String? remark;
  String? caution;
  String? drug_description;
  String? drug_type_name;
  String? time_slot;
  String? unit_stock;
  String? status;
  int? tl_common_users_id;

  UpdateOrderModel({
     this.id,
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
    this.note_to_team,
    this.remark,
    this.caution,
    this.drug_description,
    this.drug_type_name,
    this.time_slot,
    this.unit_stock,
    this.status,
     this.tl_common_users_id,
  });

  /// 🔄 ใช้สำหรับส่ง Map ไปยัง API
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "item_name": item_name,
      "item_qty": item_qty ?? 0,
      "unit_name": unit_name ?? '',
      "dose_qty": dose_qty ?? '0.00',
      "meal_timing": meal_timing ?? '',
      "drug_instruction": drug_instruction ?? '',
      "take_time": take_time ?? '[]',
      "start_date_use": start_date_use ?? '',
      "end_date_use": end_date_use ?? '',
      "stock_out": stock_out ?? 0,
      "remark": remark ?? '',
      "note_to_team": note_to_team ?? '',
      "caution": caution ?? '',
      "drug_description": drug_description ?? '',
      "drug_type_name": drug_type_name ?? '',
      "time_slot": time_slot ?? '',
      "unit_stock": unit_stock ?? '',
      "status": status ?? 'Order',
      "tl_common_users_id": tl_common_users_id,
    };
  }

  /// 🔄 แปลงเป็น JSON String (หากต้องการ print)
  String toRawJson() => json.encode(toJson());

  factory UpdateOrderModel.fromMap(Map<String, dynamic> map) {
    return UpdateOrderModel(
      id: (map['id'] ?? 0) as int,
      item_name: map['item_name'],
      item_qty: map['item_qty'],
      unit_name: map['unit_name'],
      dose_qty: map['dose_qty'],
      meal_timing: map['meal_timing'],
      drug_instruction: map['drug_instruction'],
      take_time: map['take_time'],
      start_date_use: map['start_date_use'],
      end_date_use: map['end_date_use'],
      stock_out: map['stock_out'],
      note_to_team: map['note_to_team'],
      remark: map['remark'],
      caution: map['caution'],
      drug_description: map['drug_description'],
      drug_type_name: map['drug_type_name'],
      time_slot: map['time_slot'],
      unit_stock: map['unit_stock'],
      status: map['status'],
      tl_common_users_id: (map['tl_common_users_id'] ?? 0) as int,
    );
  }

  factory UpdateOrderModel.fromJson(String source) =>
      UpdateOrderModel.fromMap(json.decode(source));

  @override
  String toString() => toJson().toString();
}
