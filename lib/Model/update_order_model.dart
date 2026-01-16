// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateOrderModel {
  int? id;
  String? item_name;
  String? item_code;
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
  String? set_slot;
  String? type_slot;
  String? status;
   String? meal_take;
    String? start_date_imed;
   String? use_now;
  int? tl_common_users_id;
  UpdateOrderModel({
    this.id,
    this.item_name,
    this.item_code,
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
    this.set_slot,
    this.type_slot,
    this.status,
    this.meal_take,
    this.tl_common_users_id,
  });

  UpdateOrderModel copyWith({
    int? id,
    String? item_name,
    String? item_code,
    int? item_qty,
    String? unit_name,
    String? dose_qty,
    String? meal_timing,
    String? drug_instruction,
    String? take_time,
    String? start_date_use,
    String? end_date_use,
    int? stock_out,
    String? note_to_team,
    String? remark,
    String? caution,
    String? drug_description,
    String? drug_type_name,
    String? time_slot,
    String? unit_stock,
    String? set_slot,
    String? type_slot,
    String? status,
    String? meal_take,
    int? tl_common_users_id,
  }) {
    return UpdateOrderModel(
      id: id ?? this.id,
      item_name: item_name ?? this.item_name,
      item_code: item_code ?? this.item_code,
      item_qty: item_qty ?? this.item_qty,
      unit_name: unit_name ?? this.unit_name,
      dose_qty: dose_qty ?? this.dose_qty,
      meal_timing: meal_timing ?? this.meal_timing,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      take_time: take_time ?? this.take_time,
      start_date_use: start_date_use ?? this.start_date_use,
      end_date_use: end_date_use ?? this.end_date_use,
      stock_out: stock_out ?? this.stock_out,
      note_to_team: note_to_team ?? this.note_to_team,
      remark: remark ?? this.remark,
      caution: caution ?? this.caution,
      drug_description: drug_description ?? this.drug_description,
      drug_type_name: drug_type_name ?? this.drug_type_name,
      time_slot: time_slot ?? this.time_slot,
      unit_stock: unit_stock ?? this.unit_stock,
      set_slot: set_slot ?? this.set_slot,
      type_slot: type_slot ?? this.type_slot,
      status: status ?? this.status,
      meal_take: meal_take ?? this.meal_take,
      tl_common_users_id: tl_common_users_id ?? this.tl_common_users_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item_name': item_name,
      'item_code': item_code,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'dose_qty': dose_qty,
      'meal_timing': meal_timing,
      'drug_instruction': drug_instruction,
      'take_time': take_time,
      'start_date_use': start_date_use,
      'end_date_use': end_date_use,
      'stock_out': stock_out,
      'note_to_team': note_to_team,
      'remark': remark,
      'caution': caution,
      'drug_description': drug_description,
      'drug_type_name': drug_type_name,
      'time_slot': time_slot,
      'unit_stock': unit_stock,
      'set_slot': set_slot,
      'type_slot': type_slot,
      'status': status,
      'meal_take': meal_take,
      'tl_common_users_id': tl_common_users_id,
    };
  }

  factory UpdateOrderModel.fromMap(Map<String, dynamic> map) {
    return UpdateOrderModel(
      id: map['id'] != null ? map['id'] as int : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as int : null,
      unit_name: map['unit_name'] != null ? map['unit_name'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      meal_timing: map['meal_timing'] != null ? map['meal_timing'] as String : null,
      drug_instruction: map['drug_instruction'] != null ? map['drug_instruction'] as String : null,
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      start_date_use: map['start_date_use'] != null ? map['start_date_use'] as String : null,
      end_date_use: map['end_date_use'] != null ? map['end_date_use'] as String : null,
      stock_out: map['stock_out'] != null ? map['stock_out'] as int : null,
      note_to_team: map['note_to_team'] != null ? map['note_to_team'] as String : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      caution: map['caution'] != null ? map['caution'] as String : null,
      drug_description: map['drug_description'] != null ? map['drug_description'] as String : null,
      drug_type_name: map['drug_type_name'] != null ? map['drug_type_name'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      unit_stock: map['unit_stock'] != null ? map['unit_stock'] as String : null,
      set_slot: map['set_slot'] != null ? map['set_slot'] as String : null,
      type_slot: map['type_slot'] != null ? map['type_slot'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      meal_take: map['meal_take'] != null ? map['meal_take'] as String : null,
      tl_common_users_id: map['tl_common_users_id'] != null ? map['tl_common_users_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateOrderModel.fromJson(String source) => UpdateOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdateOrderModel(id: $id, item_name: $item_name, item_code: $item_code, item_qty: $item_qty, unit_name: $unit_name, dose_qty: $dose_qty, meal_timing: $meal_timing, drug_instruction: $drug_instruction, take_time: $take_time, start_date_use: $start_date_use, end_date_use: $end_date_use, stock_out: $stock_out, note_to_team: $note_to_team, remark: $remark, caution: $caution, drug_description: $drug_description, drug_type_name: $drug_type_name, time_slot: $time_slot, unit_stock: $unit_stock, set_slot: $set_slot, type_slot: $type_slot, status: $status, meal_take: $meal_take, tl_common_users_id: $tl_common_users_id)';
  }

  @override
  bool operator ==(covariant UpdateOrderModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.item_name == item_name &&
      other.item_code == item_code &&
      other.item_qty == item_qty &&
      other.unit_name == unit_name &&
      other.dose_qty == dose_qty &&
      other.meal_timing == meal_timing &&
      other.drug_instruction == drug_instruction &&
      other.take_time == take_time &&
      other.start_date_use == start_date_use &&
      other.end_date_use == end_date_use &&
      other.stock_out == stock_out &&
      other.note_to_team == note_to_team &&
      other.remark == remark &&
      other.caution == caution &&
      other.drug_description == drug_description &&
      other.drug_type_name == drug_type_name &&
      other.time_slot == time_slot &&
      other.unit_stock == unit_stock &&
      other.set_slot == set_slot &&
      other.type_slot == type_slot &&
      other.status == status &&
      other.meal_take == meal_take &&
      other.tl_common_users_id == tl_common_users_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      item_name.hashCode ^
      item_code.hashCode ^
      item_qty.hashCode ^
      unit_name.hashCode ^
      dose_qty.hashCode ^
      meal_timing.hashCode ^
      drug_instruction.hashCode ^
      take_time.hashCode ^
      start_date_use.hashCode ^
      end_date_use.hashCode ^
      stock_out.hashCode ^
      note_to_team.hashCode ^
      remark.hashCode ^
      caution.hashCode ^
      drug_description.hashCode ^
      drug_type_name.hashCode ^
      time_slot.hashCode ^
      unit_stock.hashCode ^
      set_slot.hashCode ^
      type_slot.hashCode ^
      status.hashCode ^
      meal_take.hashCode ^
      tl_common_users_id.hashCode;
  }
}
