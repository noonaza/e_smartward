// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_smartward/Model/data_note_model.dart';

class NoteDetailModel {
  int? id;
  int? smw_admit_id;
  String? remark;
  String? create_date;
  String? create_by;
  String? create_by_name;
  String? slot;
  String? date_slot;
  List<DataNoteModel> dataNote;
  NoteDetailModel({
    this.id,
    this.smw_admit_id,
    this.remark,
    this.create_date,
    this.create_by,
    this.create_by_name,
    this.slot,
    this.date_slot,
    required this.dataNote,
  });

  NoteDetailModel copyWith({
    int? id,
    int? smw_admit_id,
    String? remark,
    String? create_date,
    String? create_by,
    String? slot,
    String? date_slot,
    List<DataNoteModel>? dataNote,
  }) {
    return NoteDetailModel(
      id: id ?? this.id,
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      remark: remark ?? this.remark,
      create_date: create_date ?? this.create_date,
      create_by: create_by ?? this.create_by,
      slot: slot ?? this.slot,
      date_slot: date_slot ?? this.date_slot,
      dataNote: dataNote ?? this.dataNote,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'smw_admit_id': smw_admit_id,
      'remark': remark,
      'create_date': create_date,
      'create_by': create_by,
      'slot': slot,
      'date_slot': date_slot,
      'dataNote': dataNote.map((x) => x.toMap()).toList(),
    };
  }

  factory NoteDetailModel.fromMap(Map<String, dynamic> map) {
    return NoteDetailModel(
      id: map['id'] != null ? map['id'] as int : null,
      smw_admit_id:
          map['smw_admit_id'] != null ? map['smw_admit_id'] as int : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      create_date:
          map['create_date'] != null ? map['create_date'] as String : null,
      create_by: map['create_by'] != null ? map['create_by'] as String : null,
      slot: map['slot'] != null ? map['slot'] as String : null,
      date_slot: map['date_slot'] != null ? map['date_slot'] as String : null,
      dataNote: List<DataNoteModel>.from(
        (map['dataNote'] as List<int>).map<DataNoteModel>(
          (x) => DataNoteModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteDetailModel.fromJson(String source) =>
      NoteDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoteDetailModel(id: $id, smw_admit_id: $smw_admit_id, remark: $remark, create_date: $create_date, create_by: $create_by, slot: $slot, date_slot: $date_slot, dataNote: $dataNote)';
  }

  @override
  bool operator ==(covariant NoteDetailModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.smw_admit_id == smw_admit_id &&
        other.remark == remark &&
        other.create_date == create_date &&
        other.create_by == create_by &&
        other.slot == slot &&
        other.date_slot == date_slot &&
        listEquals(other.dataNote, dataNote);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        smw_admit_id.hashCode ^
        remark.hashCode ^
        create_date.hashCode ^
        create_by.hashCode ^
        slot.hashCode ^
        date_slot.hashCode ^
        dataNote.hashCode;
  }
}
