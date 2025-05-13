// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FoodSlotModel {
  String? type;
  int? group_id;
  String? site_code;
  String? ward;
  String? slot;
  FoodSlotModel({
    this.type,
    this.group_id,
    this.site_code,
    this.ward,
    this.slot,
  });

  FoodSlotModel copyWith({
    String? type,
    int? group_id,
    String? site_code,
    String? ward,
    String? slot,
  }) {
    return FoodSlotModel(
      type: type ?? this.type,
      group_id: group_id ?? this.group_id,
      site_code: site_code ?? this.site_code,
      ward: ward ?? this.ward,
      slot: slot ?? this.slot,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'group_id': group_id,
      'site_code': site_code,
      'ward': ward,
      'slot': slot,
    };
  }

  factory FoodSlotModel.fromMap(Map<String, dynamic> map) {
    return FoodSlotModel(
      type: map['type'] != null ? map['type'] as String : null,
      group_id: map['group_id'] != null ? map['group_id'] as int : null,
      site_code: map['site_code'] != null ? map['site_code'] as String : null,
      ward: map['ward'] != null ? map['ward'] as String : null,
      slot: map['slot'] != null ? map['slot'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodSlotModel.fromJson(String source) => FoodSlotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FoodSlotModel(type: $type, group_id: $group_id, site_code: $site_code, ward: $ward, slot: $slot)';
  }

  @override
  bool operator ==(covariant FoodSlotModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.type == type &&
      other.group_id == group_id &&
      other.site_code == site_code &&
      other.ward == ward &&
      other.slot == slot;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      group_id.hashCode ^
      site_code.hashCode ^
      ward.hashCode ^
      slot.hashCode;
  }
}
