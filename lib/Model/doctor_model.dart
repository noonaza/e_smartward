// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DoctorModel {
 String? employee_id;
  String? prename;
   String? full_nameth;
  String? employee_nameen;
  String? key_search;

  DoctorModel({
    this.employee_id,
    this.prename,
    this.full_nameth,
    this.employee_nameen,
    this.key_search,
  });

  @override
  String toString() {
    return 'DoctorModel(employee_id: $employee_id, prename: $prename, full_nameth: $full_nameth, employee_nameen: $employee_nameen, key_search: $key_search)';
  }

  @override
  bool operator ==(covariant DoctorModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.employee_id == employee_id &&
      other.prename == prename &&
      other.full_nameth == full_nameth &&
      other.employee_nameen == employee_nameen &&
      other.key_search == key_search;
  }

  @override
  int get hashCode {
    return employee_id.hashCode ^
      prename.hashCode ^
      full_nameth.hashCode ^
      employee_nameen.hashCode ^
      key_search.hashCode;
  }

  DoctorModel copyWith({
    String? employee_id,
    String? prename,
    String? full_nameth,
    String? employee_nameen,
    String? key_search,
  }) {
    return DoctorModel(
      employee_id: employee_id ?? this.employee_id,
      prename: prename ?? this.prename,
      full_nameth: full_nameth ?? this.full_nameth,
      employee_nameen: employee_nameen ?? this.employee_nameen,
      key_search: key_search ?? this.key_search,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employee_id': employee_id,
      'prename': prename,
      'full_nameth': full_nameth,
      'employee_nameen': employee_nameen,
      'key_search': key_search,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      employee_id: map['employee_id'] != null ? map['employee_id'] as String : null,
      prename: map['prename'] != null ? map['prename'] as String : null,
      full_nameth: map['full_nameth'] != null ? map['full_nameth'] as String : null,
      employee_nameen: map['employee_nameen'] != null ? map['employee_nameen'] as String : null,
      key_search: map['key_search'] != null ? map['key_search'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorModel.fromJson(String source) => DoctorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
