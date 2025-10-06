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
  String? take_time;
  String? time_slot;
  String? set_key;
  String? key_special;
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
    this.take_time,
    this.time_slot,
    this.set_key,
    this.key_special,
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
    String? take_time,
    String? time_slot,
    String? set_key,
    String? key_special,
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
      take_time: take_time ?? this.take_time,
      time_slot: time_slot ?? this.time_slot,
      set_key: set_key ?? this.set_key,
      key_special: key_special ?? this.key_special,
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
      'take_time': take_time,
      'time_slot': time_slot,
      'set_key': set_key,
      'key_special': key_special,
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
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      set_key: map['set_key'] != null ? map['set_key'] as String : null,
      key_special: map['key_special'] != null ? map['key_special'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetObsModel.fromJson(String source) =>
      GetObsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetObsModel(id: $id, code: $code, set_name: $set_name, set_value: $set_value, create_by: $create_by, create_date: $create_date, update_by: $update_by, update_date: $update_date, delete_by: $delete_by, remark: $remark, delete_date: $delete_date, take_time: $take_time, time_slot: $time_slot, set_key: $set_key, key_special: $key_special)';
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
      other.take_time == take_time &&
      other.time_slot == time_slot &&
      other.set_key == set_key &&
      other.key_special == key_special;
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
      take_time.hashCode ^
      time_slot.hashCode ^
      set_key.hashCode ^
      key_special.hashCode;
  }
}
