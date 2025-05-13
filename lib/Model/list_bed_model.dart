// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListBedModel {
  String? base_room_id;
  String? base_service_point_id;
  String? ward;
  String? room_type;
  String? bed_number;
  String? bed_status;
  String? base_site_branch_id;
  ListBedModel({
    this.base_room_id,
    this.base_service_point_id,
    this.ward,
    this.room_type,
    this.bed_number,
    this.bed_status,
    this.base_site_branch_id,
  });

  ListBedModel copyWith({
    String? base_room_id,
    String? base_service_point_id,
    String? ward,
    String? room_type,
    String? bed_number,
    String? bed_status,
    String? base_site_branch_id,
  }) {
    return ListBedModel(
      base_room_id: base_room_id ?? this.base_room_id,
      base_service_point_id:
          base_service_point_id ?? this.base_service_point_id,
      ward: ward ?? this.ward,
      room_type: room_type ?? this.room_type,
      bed_number: bed_number ?? this.bed_number,
      bed_status: bed_status ?? this.bed_status,
      base_site_branch_id: base_site_branch_id ?? this.base_site_branch_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'base_room_id': base_room_id,
      'base_service_point_id': base_service_point_id,
      'ward': ward,
      'room_type': room_type,
      'bed_number': bed_number,
      'bed_status': bed_status,
      'base_site_branch_id': base_site_branch_id,
    };
  }

  factory ListBedModel.fromMap(Map<String, dynamic> map) {
    return ListBedModel(
      base_room_id:
          map['base_room_id'] != null ? map['base_room_id'] as String : null,
      base_service_point_id: map['base_service_point_id'] != null
          ? map['base_service_point_id'] as String
          : null,
      ward: map['ward'] != null ? map['ward'] as String : null,
      room_type: map['room_type'] != null ? map['room_type'] as String : null,
      bed_number:
          map['bed_number'] != null ? map['bed_number'] as String : null,
      bed_status:
          map['bed_status'] != null ? map['bed_status'] as String : null,
      base_site_branch_id: map['base_site_branch_id'] != null
          ? map['base_site_branch_id'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListBedModel.fromJson(String source) =>
      ListBedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListBedModel(base_room_id: $base_room_id, base_service_point_id: $base_service_point_id, ward: $ward, room_type: $room_type, bed_number: $bed_number, bed_status: $bed_status, base_site_branch_id: $base_site_branch_id)';
  }

  @override
  bool operator ==(covariant ListBedModel other) {
    if (identical(this, other)) return true;

    return other.base_room_id == base_room_id &&
        other.base_service_point_id == base_service_point_id &&
        other.ward == ward &&
        other.room_type == room_type &&
        other.bed_number == bed_number &&
        other.bed_status == bed_status &&
        other.base_site_branch_id == base_site_branch_id;
  }

  @override
  int get hashCode {
    return base_room_id.hashCode ^
        base_service_point_id.hashCode ^
        ward.hashCode ^
        room_type.hashCode ^
        bed_number.hashCode ^
        bed_status.hashCode ^
        base_site_branch_id.hashCode;
  }
}
