// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:e_smartward/Model/list_obs_detail.dart';

class ListDataObsDetailModel {
  int? id;
  String? code;
  String? set_name;
  String? set_value;
  DataObsDetail? mDataObs;
  String? create_by;
  String? create_date;
  String? update_by;
  String? update_date;
  String? delete_by;
  String? delete_date;
  String? set_key;
  ListDataObsDetailModel({
    this.id,
    this.code,
    this.set_name,
    this.set_value,
    this.mDataObs,
    this.create_by,
    this.create_date,
    this.update_by,
    this.update_date,
    this.delete_by,
    this.delete_date,
    this.set_key,
  });

  get obs => null;

  get col => null;

  ListDataObsDetailModel copyWith({
    int? id,
    String? code,
    String? set_name,
    String? set_value,
    DataObsDetail? mDataObs,
    String? create_by,
    String? create_date,
    String? update_by,
    String? update_date,
    String? delete_by,
    String? delete_date,
    String? set_key,
  }) {
    return ListDataObsDetailModel(
      id: id ?? this.id,
      code: code ?? this.code,
      set_name: set_name ?? this.set_name,
      set_value: set_value ?? this.set_value,
      mDataObs: mDataObs ?? this.mDataObs,
      create_by: create_by ?? this.create_by,
      create_date: create_date ?? this.create_date,
      update_by: update_by ?? this.update_by,
      update_date: update_date ?? this.update_date,
      delete_by: delete_by ?? this.delete_by,
      delete_date: delete_date ?? this.delete_date,
      set_key: set_key ?? this.set_key,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'set_name': set_name,
      'set_value': set_value,
      'mDataObs': mDataObs?.toMap(),
      'create_by': create_by,
      'create_date': create_date,
      'update_by': update_by,
      'update_date': update_date,
      'delete_by': delete_by,
      'delete_date': delete_date,
      'set_key': set_key,
    };
  }

  factory ListDataObsDetailModel.fromMap(Map<String, dynamic> map) {
    return ListDataObsDetailModel(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] != null ? map['code'] as String : null,
      set_name: map['set_name'] != null ? map['set_name'] as String : null,
      set_value: map['set_value'] != null ? map['set_value'] as String : null,
      mDataObs: map['mDataObs'] != null ? DataObsDetail.fromMap(map['mDataObs'] as Map<String,dynamic>) : null,
      create_by: map['create_by'] != null ? map['create_by'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      update_date: map['update_date'] != null ? map['update_date'] as String : null,
      delete_by: map['delete_by'] != null ? map['delete_by'] as String : null,
      delete_date: map['delete_date'] != null ? map['delete_date'] as String : null,
      set_key: map['set_key'] != null ? map['set_key'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListDataObsDetailModel.fromJson(String source) => ListDataObsDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListDataObsDetailModel(id: $id, code: $code, set_name: $set_name, set_value: $set_value, mDataObs: $mDataObs, create_by: $create_by, create_date: $create_date, update_by: $update_by, update_date: $update_date, delete_by: $delete_by, delete_date: $delete_date, set_key: $set_key)';
  }

  @override
  bool operator ==(covariant ListDataObsDetailModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.code == code &&
      other.set_name == set_name &&
      other.set_value == set_value &&
      other.mDataObs == mDataObs &&
      other.create_by == create_by &&
      other.create_date == create_date &&
      other.update_by == update_by &&
      other.update_date == update_date &&
      other.delete_by == delete_by &&
      other.delete_date == delete_date &&
      other.set_key == set_key;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      code.hashCode ^
      set_name.hashCode ^
      set_value.hashCode ^
      mDataObs.hashCode ^
      create_by.hashCode ^
      create_date.hashCode ^
      update_by.hashCode ^
      update_date.hashCode ^
      delete_by.hashCode ^
      delete_date.hashCode ^
      set_key.hashCode;
  }
}
