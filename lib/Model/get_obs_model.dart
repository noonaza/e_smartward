// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetObsModel {
  int? id;
  String? code;
  String? set_name;
  String? set_value;
  String? create_by;
  String? create_date;
  String? update_by;
  String? update_date;
  String? delete_by;
  String? remark;
  String? delete_date;
  String? item_code;
  String? take_time;
  String? time_slot;
  String? set_key;
  String? key_special;
  String? meal_timing;
  String? type_slot;
    String? order_item_id;
      String? order_date;
  String? drug_description;
    String? start_date_use;
  String? set_slot;
  String? schedule_mode_label;
  GetObsModel({
    this.id,
    this.code,
    this.set_name,
    this.set_value,
    this.create_by,
    this.create_date,
    this.update_by,
    this.update_date,
    this.delete_by,
    this.remark,
    this.delete_date,
    this.item_code,
    this.take_time,
    this.time_slot,
    this.set_key,
    this.key_special,
    this.meal_timing,
    this.type_slot,
    this.order_item_id,
    this.order_date,
    this.drug_description,
    this.start_date_use,
    this.set_slot,
    this.schedule_mode_label,
  });

  GetObsModel copyWith({
    int? id,
    String? code,
    String? set_name,
    String? set_value,
    String? create_by,
    String? create_date,
    String? update_by,
    String? update_date,
    String? delete_by,
    String? remark,
    String? delete_date,
    String? item_code,
    String? take_time,
    String? time_slot,
    String? set_key,
    String? key_special,
    String? meal_timing,
    String? type_slot,
    String? order_item_id,
    String? order_date,
    String? drug_description,
    String? start_date_use,
    String? set_slot,
    String? schedule_mode_label,
  }) {
    return GetObsModel(
      id: id ?? this.id,
      code: code ?? this.code,
      set_name: set_name ?? this.set_name,
      set_value: set_value ?? this.set_value,
      create_by: create_by ?? this.create_by,
      create_date: create_date ?? this.create_date,
      update_by: update_by ?? this.update_by,
      update_date: update_date ?? this.update_date,
      delete_by: delete_by ?? this.delete_by,
      remark: remark ?? this.remark,
      delete_date: delete_date ?? this.delete_date,
      item_code: item_code ?? this.item_code,
      take_time: take_time ?? this.take_time,
      time_slot: time_slot ?? this.time_slot,
      set_key: set_key ?? this.set_key,
      key_special: key_special ?? this.key_special,
      meal_timing: meal_timing ?? this.meal_timing,
      type_slot: type_slot ?? this.type_slot,
      order_item_id: order_item_id ?? this.order_item_id,
      order_date: order_date ?? this.order_date,
      drug_description: drug_description ?? this.drug_description,
      start_date_use: start_date_use ?? this.start_date_use,
      set_slot: set_slot ?? this.set_slot,
      schedule_mode_label: schedule_mode_label ?? this.schedule_mode_label,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'set_name': set_name,
      'set_value': set_value,
      'create_by': create_by,
      'create_date': create_date,
      'update_by': update_by,
      'update_date': update_date,
      'delete_by': delete_by,
      'remark': remark,
      'delete_date': delete_date,
      'item_code': item_code,
      'take_time': take_time,
      'time_slot': time_slot,
      'set_key': set_key,
      'key_special': key_special,
      'meal_timing': meal_timing,
      'type_slot': type_slot,
      'order_item_id': order_item_id,
      'order_date': order_date,
      'drug_description': drug_description,
      'start_date_use': start_date_use,
      'set_slot': set_slot,
      'schedule_mode_label': schedule_mode_label,
    };
  }

  factory GetObsModel.fromMap(Map<String, dynamic> map) {
    return GetObsModel(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] != null ? map['code'] as String : null,
      set_name: map['set_name'] != null ? map['set_name'] as String : null,
      set_value: map['set_value'] != null ? map['set_value'] as String : null,
      create_by: map['create_by'] != null ? map['create_by'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      update_date: map['update_date'] != null ? map['update_date'] as String : null,
      delete_by: map['delete_by'] != null ? map['delete_by'] as String : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      delete_date: map['delete_date'] != null ? map['delete_date'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      set_key: map['set_key'] != null ? map['set_key'] as String : null,
      key_special: map['key_special'] != null ? map['key_special'] as String : null,
      meal_timing: map['meal_timing'] != null ? map['meal_timing'] as String : null,
      type_slot: map['type_slot'] != null ? map['type_slot'] as String : null,
      order_item_id: map['order_item_id'] != null ? map['order_item_id'] as String : null,
      order_date: map['order_date'] != null ? map['order_date'] as String : null,
      drug_description: map['drug_description'] != null ? map['drug_description'] as String : null,
      start_date_use: map['start_date_use'] != null ? map['start_date_use'] as String : null,
      set_slot: map['set_slot'] != null ? map['set_slot'] as String : null,
      schedule_mode_label: map['schedule_mode_label'] != null ? map['schedule_mode_label'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetObsModel.fromJson(String source) =>
      GetObsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetObsModel(id: $id, code: $code, set_name: $set_name, set_value: $set_value, create_by: $create_by, create_date: $create_date, update_by: $update_by, update_date: $update_date, delete_by: $delete_by, remark: $remark, delete_date: $delete_date, item_code: $item_code, take_time: $take_time, time_slot: $time_slot, set_key: $set_key, key_special: $key_special, meal_timing: $meal_timing, type_slot: $type_slot, order_item_id: $order_item_id, order_date: $order_date, drug_description: $drug_description, start_date_use: $start_date_use, set_slot: $set_slot, schedule_mode_label: $schedule_mode_label)';
  }

  @override
  bool operator ==(covariant GetObsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.code == code &&
      other.set_name == set_name &&
      other.set_value == set_value &&
      other.create_by == create_by &&
      other.create_date == create_date &&
      other.update_by == update_by &&
      other.update_date == update_date &&
      other.delete_by == delete_by &&
      other.remark == remark &&
      other.delete_date == delete_date &&
      other.item_code == item_code &&
      other.take_time == take_time &&
      other.time_slot == time_slot &&
      other.set_key == set_key &&
      other.key_special == key_special &&
      other.meal_timing == meal_timing &&
      other.type_slot == type_slot &&
      other.order_item_id == order_item_id &&
      other.order_date == order_date &&
      other.drug_description == drug_description &&
      other.start_date_use == start_date_use &&
      other.set_slot == set_slot &&
      other.schedule_mode_label == schedule_mode_label;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      code.hashCode ^
      set_name.hashCode ^
      set_value.hashCode ^
      create_by.hashCode ^
      create_date.hashCode ^
      update_by.hashCode ^
      update_date.hashCode ^
      delete_by.hashCode ^
      remark.hashCode ^
      delete_date.hashCode ^
      item_code.hashCode ^
      take_time.hashCode ^
      time_slot.hashCode ^
      set_key.hashCode ^
      key_special.hashCode ^
      meal_timing.hashCode ^
      type_slot.hashCode ^
      order_item_id.hashCode ^
      order_date.hashCode ^
      drug_description.hashCode ^
      start_date_use.hashCode ^
      set_slot.hashCode ^
      schedule_mode_label.hashCode;
  }
}
