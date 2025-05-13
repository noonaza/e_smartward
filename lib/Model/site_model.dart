// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SiteModel {
  int? id;
  String? name;
  int? tl_area_id;
  String? code_name;
  String? status;
  String? area_code;
  SiteModel({
    this.id,
    this.name,
    this.tl_area_id,
    this.code_name,
    this.status,
    this.area_code,
  });

  SiteModel copyWith({
    int? id,
    String? name,
    int? tl_area_id,
    String? code_name,
    String? status,
    String? area_code,
  }) {
    return SiteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tl_area_id: tl_area_id ?? this.tl_area_id,
      code_name: code_name ?? this.code_name,
      status: status ?? this.status,
      area_code: area_code ?? this.area_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'tl_area_id': tl_area_id,
      'code_name': code_name,
      'status': status,
      'area_code': area_code,
    };
  }

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      tl_area_id: map['tl_area_id'] != null ? map['tl_area_id'] as int : null,
      code_name: map['code_name'] != null ? map['code_name'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      area_code: map['area_code'] != null ? map['area_code'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SiteModel.fromJson(String source) => SiteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SiteModel(id: $id, name: $name, tl_area_id: $tl_area_id, code_name: $code_name, status: $status, area_code: $area_code)';
  }

  @override
  bool operator ==(covariant SiteModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.tl_area_id == tl_area_id &&
      other.code_name == code_name &&
      other.status == status &&
      other.area_code == area_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      tl_area_id.hashCode ^
      code_name.hashCode ^
      status.hashCode ^
      area_code.hashCode;
  }
}
