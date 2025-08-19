// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

class ListFileModel {
  int? id;
  String? code_project;
  int? ref_id;
  int? internal;
  String? path_file;
   String? remark;
    String? create_date;
     String? delete_date;
  ListFileModel({
    this.id,
    this.code_project,
    this.ref_id,
    this.internal,
    this.path_file,
    this.remark,
    this.create_date,
    this.delete_date,
  });


  ListFileModel copyWith({
    int? id,
    String? code_project,
    int? ref_id,
    int? internal,
    String? path_file,
    String? remark,
    String? create_date,
    String? delete_date,
  }) {
    return ListFileModel(
      id: id ?? this.id,
      code_project: code_project ?? this.code_project,
      ref_id: ref_id ?? this.ref_id,
      internal: internal ?? this.internal,
      path_file: path_file ?? this.path_file,
      remark: remark ?? this.remark,
      create_date: create_date ?? this.create_date,
      delete_date: delete_date ?? this.delete_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code_project': code_project,
      'ref_id': ref_id,
      'internal': internal,
      'path_file': path_file,
      'remark': remark,
      'create_date': create_date,
      'delete_date': delete_date,
    };
  }

  factory ListFileModel.fromMap(Map<String, dynamic> map) {
    return ListFileModel(
      id: map['id'] != null ? map['id'] as int : null,
      code_project: map['code_project'] != null ? map['code_project'] as String : null,
      ref_id: map['ref_id'] != null ? map['ref_id'] as int : null,
      internal: map['internal'] != null ? map['internal'] as int : null,
      path_file: map['path_file'] != null ? map['path_file'] as String : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      delete_date: map['delete_date'] != null ? map['delete_date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListFileModel.fromJson(String source) => ListFileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListFileModel(id: $id, code_project: $code_project, ref_id: $ref_id, internal: $internal, path_file: $path_file, remark: $remark, create_date: $create_date, delete_date: $delete_date)';
  }

  @override
  bool operator ==(covariant ListFileModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.code_project == code_project &&
      other.ref_id == ref_id &&
      other.internal == internal &&
      other.path_file == path_file &&
      other.remark == remark &&
      other.create_date == create_date &&
      other.delete_date == delete_date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      code_project.hashCode ^
      ref_id.hashCode ^
      internal.hashCode ^
      path_file.hashCode ^
      remark.hashCode ^
      create_date.hashCode ^
      delete_date.hashCode;
  }
}
