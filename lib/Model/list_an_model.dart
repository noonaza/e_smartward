// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListAnModel {
  int? smw_admit_id;
  String? an_number;
  String? visit_number;
  String? create_date;
  ListAnModel({
    this.smw_admit_id,
    this.an_number,
    this.visit_number,
    this.create_date,
  });

  ListAnModel copyWith({
    int? smw_admit_id,
    String? an_number,
    String? visit_number,
    String? create_date,
  }) {
    return ListAnModel(
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      an_number: an_number ?? this.an_number,
      visit_number: visit_number ?? this.visit_number,
      create_date: create_date ?? this.create_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'smw_admit_id': smw_admit_id,
      'an_number': an_number,
      'visit_number': visit_number,
      'create_date': create_date,
    };
  }

  factory ListAnModel.fromMap(Map<String, dynamic> map) {
    return ListAnModel(
      smw_admit_id: map['smw_admit_id'] != null ? map['smw_admit_id'] as int : null,
      an_number: map['an_number'] != null ? map['an_number'] as String : null,
      visit_number: map['visit_number'] != null ? map['visit_number'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListAnModel.fromJson(String source) => ListAnModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListAnModel(smw_admit_id: $smw_admit_id, an_number: $an_number, visit_number: $visit_number, create_date: $create_date)';
  }

  @override
  bool operator ==(covariant ListAnModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.smw_admit_id == smw_admit_id &&
      other.an_number == an_number &&
      other.visit_number == visit_number &&
      other.create_date == create_date;
  }

  @override
  int get hashCode {
    return smw_admit_id.hashCode ^
      an_number.hashCode ^
      visit_number.hashCode ^
      create_date.hashCode;
  }
}
