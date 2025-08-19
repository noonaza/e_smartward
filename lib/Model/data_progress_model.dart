// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataProgressModel {
  String? admit_id;
  String? visit_id;
  String? create_datetime;
  String? doctor_create_name;
  String? update_datetime;
  String? doctor_update_name;
  String? s;
    String? o;
  String? a;
  String? p;
  DataProgressModel({
    this.admit_id,
    this.visit_id,
    this.create_datetime,
    this.doctor_create_name,
    this.update_datetime,
    this.doctor_update_name,
    this.s,
    this.o,
    this.a,
    this.p,
  });

  DataProgressModel copyWith({
    String? admit_id,
    String? visit_id,
    String? create_datetime,
    String? doctor_create_name,
    String? update_datetime,
    String? doctor_update_name,
    String? s,
    String? o,
    String? a,
    String? p,
  }) {
    return DataProgressModel(
      admit_id: admit_id ?? this.admit_id,
      visit_id: visit_id ?? this.visit_id,
      create_datetime: create_datetime ?? this.create_datetime,
      doctor_create_name: doctor_create_name ?? this.doctor_create_name,
      update_datetime: update_datetime ?? this.update_datetime,
      doctor_update_name: doctor_update_name ?? this.doctor_update_name,
      s: s ?? this.s,
      o: o ?? this.o,
      a: a ?? this.a,
      p: p ?? this.p,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'admit_id': admit_id,
      'visit_id': visit_id,
      'create_datetime': create_datetime,
      'doctor_create_name': doctor_create_name,
      'update_datetime': update_datetime,
      'doctor_update_name': doctor_update_name,
      's': s,
      'o': o,
      'a': a,
      'p': p,
    };
  }

  factory DataProgressModel.fromMap(Map<String, dynamic> map) {
    return DataProgressModel(
      admit_id: map['admit_id'] != null ? map['admit_id'] as String : null,
      visit_id: map['visit_id'] != null ? map['visit_id'] as String : null,
      create_datetime: map['create_datetime'] != null ? map['create_datetime'] as String : null,
      doctor_create_name: map['doctor_create_name'] != null ? map['doctor_create_name'] as String : null,
      update_datetime: map['update_datetime'] != null ? map['update_datetime'] as String : null,
      doctor_update_name: map['doctor_update_name'] != null ? map['doctor_update_name'] as String : null,
      s: map['s'] != null ? map['s'] as String : null,
      o: map['o'] != null ? map['o'] as String : null,
      a: map['a'] != null ? map['a'] as String : null,
      p: map['p'] != null ? map['p'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataProgressModel.fromJson(String source) => DataProgressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataProgressModel(admit_id: $admit_id, visit_id: $visit_id, create_datetime: $create_datetime, doctor_create_name: $doctor_create_name, update_datetime: $update_datetime, doctor_update_name: $doctor_update_name, s: $s, o: $o, a: $a, p: $p)';
  }

  @override
  bool operator ==(covariant DataProgressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.admit_id == admit_id &&
      other.visit_id == visit_id &&
      other.create_datetime == create_datetime &&
      other.doctor_create_name == doctor_create_name &&
      other.update_datetime == update_datetime &&
      other.doctor_update_name == doctor_update_name &&
      other.s == s &&
      other.o == o &&
      other.a == a &&
      other.p == p;
  }

  @override
  int get hashCode {
    return admit_id.hashCode ^
      visit_id.hashCode ^
      create_datetime.hashCode ^
      doctor_create_name.hashCode ^
      update_datetime.hashCode ^
      doctor_update_name.hashCode ^
      s.hashCode ^
      o.hashCode ^
      a.hashCode ^
      p.hashCode;
  }
}
