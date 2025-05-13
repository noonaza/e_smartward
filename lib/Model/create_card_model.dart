// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateCardModel {
  String? hn_number;
  String? an_number;
  String? visit_number;
  String? pet_name;
  String? tl_common_users_id;
  String? data_drug;
  String? data_food;
  String? data_observe;
  CreateCardModel({
    this.hn_number,
    this.an_number,
    this.visit_number,
    this.pet_name,
    this.tl_common_users_id,
    this.data_drug,
    this.data_food,
    this.data_observe,
  });

  CreateCardModel copyWith({
    String? hn_number,
    String? an_number,
    String? visit_number,
    String? pet_name,
    String? tl_common_users_id,
    String? data_drug,
    String? data_food,
    String? data_observe,
  }) {
    return CreateCardModel(
      hn_number: hn_number ?? this.hn_number,
      an_number: an_number ?? this.an_number,
      visit_number: visit_number ?? this.visit_number,
      pet_name: pet_name ?? this.pet_name,
      tl_common_users_id: tl_common_users_id ?? this.tl_common_users_id,
      data_drug: data_drug ?? this.data_drug,
      data_food: data_food ?? this.data_food,
      data_observe: data_observe ?? this.data_observe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hn_number': hn_number,
      'an_number': an_number,
      'visit_number': visit_number,
      'pet_name': pet_name,
      'tl_common_users_id': tl_common_users_id,
      'data_drug': data_drug,
      'data_food': data_food,
      'data_observe': data_observe,
    };
  }

  factory CreateCardModel.fromMap(Map<String, dynamic> map) {
    return CreateCardModel(
      hn_number: map['hn_number'] != null ? map['hn_number'] as String : null,
      an_number: map['an_number'] != null ? map['an_number'] as String : null,
      visit_number: map['visit_number'] != null ? map['visit_number'] as String : null,
      pet_name: map['pet_name'] != null ? map['pet_name'] as String : null,
      tl_common_users_id: map['tl_common_users_id'] != null ? map['tl_common_users_id'] as String : null,
      data_drug: map['data_drug'] != null ? map['data_drug'] as String : null,
      data_food: map['data_food'] != null ? map['data_food'] as String : null,
      data_observe: map['data_observe'] != null ? map['data_observe'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateCardModel.fromJson(String source) => CreateCardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreateCardModel(hn_number: $hn_number, an_number: $an_number, visit_number: $visit_number, pet_name: $pet_name, tl_common_users_id: $tl_common_users_id, data_drug: $data_drug, data_food: $data_food, data_observe: $data_observe)';
  }

  @override
  bool operator ==(covariant CreateCardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.hn_number == hn_number &&
      other.an_number == an_number &&
      other.visit_number == visit_number &&
      other.pet_name == pet_name &&
      other.tl_common_users_id == tl_common_users_id &&
      other.data_drug == data_drug &&
      other.data_food == data_food &&
      other.data_observe == data_observe;
  }

  @override
  int get hashCode {
    return hn_number.hashCode ^
      an_number.hashCode ^
      visit_number.hashCode ^
      pet_name.hashCode ^
      tl_common_users_id.hashCode ^
      data_drug.hashCode ^
      data_food.hashCode ^
      data_observe.hashCode;
  }
}
