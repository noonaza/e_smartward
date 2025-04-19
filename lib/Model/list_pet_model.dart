// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListPetModel {
  String? hn_number;
  String? visit_id;
  String? hn;
  String? an;
  String? owner_name;
  String? pet_name;
  String? pet_type;
  String? base_site_branch_id;
  String? ward;
  String? room_type;
  String? bed_number;
  ListPetModel({
    this.hn_number,
    this.visit_id,
    this.hn,
    this.an,
    this.owner_name,
    this.pet_name,
    this.pet_type,
    this.base_site_branch_id,
    this.ward,
    this.room_type,
    this.bed_number,
  });

  ListPetModel copyWith({
    String? hn_number,
    String? visit_id,
    String? hn,
    String? an,
    String? owner_name,
    String? pet_name,
    String? pet_type,
    String? base_site_branch_id,
    String? ward,
    String? room_type,
    String? bed_number,
  }) {
    return ListPetModel(
      hn_number: hn_number ?? this.hn_number,
      visit_id: visit_id ?? this.visit_id,
      hn: hn ?? this.hn,
      an: an ?? this.an,
      owner_name: owner_name ?? this.owner_name,
      pet_name: pet_name ?? this.pet_name,
      pet_type: pet_type ?? this.pet_type,
      base_site_branch_id: base_site_branch_id ?? this.base_site_branch_id,
      ward: ward ?? this.ward,
      room_type: room_type ?? this.room_type,
      bed_number: bed_number ?? this.bed_number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hn_number': hn_number,
      'visit_id': visit_id,
      'hn': hn,
      'an': an,
      'owner_name': owner_name,
      'pet_name': pet_name,
      'pet_type': pet_type,
      'base_site_branch_id': base_site_branch_id,
      'ward': ward,
      'room_type': room_type,
      'bed_number': bed_number,
    };
  }

  factory ListPetModel.fromMap(Map<String, dynamic> map) {
    return ListPetModel(
      hn_number: map['hn_number'] != null ? map['hn_number'] as String : null,
      visit_id: map['visit_id'] != null ? map['visit_id'] as String : null,
      hn: map['hn'] != null ? map['hn'] as String : null,
      an: map['an'] != null ? map['an'] as String : null,
      owner_name: map['owner_name'] != null ? map['owner_name'] as String : null,
      pet_name: map['pet_name'] != null ? map['pet_name'] as String : null,
      pet_type: map['pet_type'] != null ? map['pet_type'] as String : null,
      base_site_branch_id: map['base_site_branch_id'] != null ? map['base_site_branch_id'] as String : null,
      ward: map['ward'] != null ? map['ward'] as String : null,
      room_type: map['room_type'] != null ? map['room_type'] as String : null,
      bed_number: map['bed_number'] != null ? map['bed_number'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListPetModel.fromJson(String source) => ListPetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListPetModel(hn_number: $hn_number, visit_id: $visit_id, hn: $hn, an: $an, owner_name: $owner_name, pet_name: $pet_name, pet_type: $pet_type, base_site_branch_id: $base_site_branch_id, ward: $ward, room_type: $room_type, bed_number: $bed_number)';
  }

  @override
  bool operator ==(covariant ListPetModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.hn_number == hn_number &&
      other.visit_id == visit_id &&
      other.hn == hn &&
      other.an == an &&
      other.owner_name == owner_name &&
      other.pet_name == pet_name &&
      other.pet_type == pet_type &&
      other.base_site_branch_id == base_site_branch_id &&
      other.ward == ward &&
      other.room_type == room_type &&
      other.bed_number == bed_number;
  }

  @override
  int get hashCode {
    return hn_number.hashCode ^
      visit_id.hashCode ^
      hn.hashCode ^
      an.hashCode ^
      owner_name.hashCode ^
      pet_name.hashCode ^
      pet_type.hashCode ^
      base_site_branch_id.hashCode ^
      ward.hashCode ^
      room_type.hashCode ^
      bed_number.hashCode;
  }
}
