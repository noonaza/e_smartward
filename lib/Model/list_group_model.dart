// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListGroupModel {
  String? type_card;
  String? type_name;
  ListGroupModel({
    this.type_card,
    this.type_name,
  });

  ListGroupModel copyWith({
    String? type_card,
    String? type_name,
  }) {
    return ListGroupModel(
      type_card: type_card ?? this.type_card,
      type_name: type_name ?? this.type_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type_card': type_card,
      'type_name': type_name,
    };
  }

  factory ListGroupModel.fromMap(Map<String, dynamic> map) {
    return ListGroupModel(
      type_card: map['type_card'] != null ? map['type_card'] as String : null,
      type_name: map['type_name'] != null ? map['type_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListGroupModel.fromJson(String source) => ListGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ListGroupModel(type_card: $type_card, type_name: $type_name)';

  @override
  bool operator ==(covariant ListGroupModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.type_card == type_card &&
      other.type_name == type_name;
  }

  @override
  int get hashCode => type_card.hashCode ^ type_name.hashCode;
}
