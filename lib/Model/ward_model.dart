// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WardModel {
  String? base_service_point_id;
  String? ward;
  String? base_site_branch_id;
  WardModel({
    this.base_service_point_id,
    this.ward,
    this.base_site_branch_id,
  });

  WardModel copyWith({
    String? base_service_point_id,
    String? ward,
    String? base_site_branch_id,
  }) {
    return WardModel(
      base_service_point_id: base_service_point_id ?? this.base_service_point_id,
      ward: ward ?? this.ward,
      base_site_branch_id: base_site_branch_id ?? this.base_site_branch_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'base_service_point_id': base_service_point_id,
      'ward': ward,
      'base_site_branch_id': base_site_branch_id,
    };
  }

  factory WardModel.fromMap(Map<String, dynamic> map) {
    return WardModel(
      base_service_point_id: map['base_service_point_id'] != null ? map['base_service_point_id'] as String : null,
      ward: map['ward'] != null ? map['ward'] as String : null,
      base_site_branch_id: map['base_site_branch_id'] != null ? map['base_site_branch_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WardModel.fromJson(String source) => WardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WardModel(base_service_point_id: $base_service_point_id, ward: $ward, base_site_branch_id: $base_site_branch_id)';

  @override
  bool operator ==(covariant WardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.base_service_point_id == base_service_point_id &&
      other.ward == ward &&
      other.base_site_branch_id == base_site_branch_id;
  }

  @override
  int get hashCode => base_service_point_id.hashCode ^ ward.hashCode ^ base_site_branch_id.hashCode;
}
