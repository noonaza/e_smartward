// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListDataCardModel {
  String? visit_id;
  String? order_item_id;
  String? doctor_eid;
  String? item_code;
  String? item_name;
  String? item_qty;
  String? dose_qty;
  String? dose_unit_name;
  String? base_drug_usage_code;
  String? drug_instruction;
  String? fix_item_type_id;
  String? item_type_name;
  String? drug_type_id;
  String? patient_age;
  String? drug_type_name;
  String? note_to_team;
  String? caution;
  String? drug_description;
  String? start_date_use;
  String? end_date_use;
  String? order_eid;
  String? order_date;
  String? order_time;
  ListDataCardModel({
    this.visit_id,
    this.order_item_id,
    this.doctor_eid,
    this.item_code,
    this.item_name,
    this.item_qty,
    this.dose_qty,
    this.dose_unit_name,
    this.base_drug_usage_code,
    this.drug_instruction,
    this.fix_item_type_id,
    this.item_type_name,
    this.drug_type_id,
    this.patient_age,
    this.drug_type_name,
    this.note_to_team,
    this.caution,
    this.drug_description,
    this.start_date_use,
    this.end_date_use,
    this.order_eid,
    this.order_date,
    this.order_time,
  });

  get someAdditionalField => null;

  ListDataCardModel copyWith({
    String? visit_id,
    String? order_item_id,
    String? doctor_eid,
    String? item_code,
    String? item_name,
    String? item_qty,
    String? dose_qty,
    String? dose_unit_name,
    String? base_drug_usage_code,
    String? drug_instruction,
    String? fix_item_type_id,
    String? item_type_name,
    String? drug_type_id,
    String? patient_age,
    String? drug_type_name,
    String? note_to_team,
    String? caution,
    String? drug_description,
    String? start_date_use,
    String? start_end_date,
    String? order_eid,
    String? order_date,
    String? order_time,
  }) {
    return ListDataCardModel(
      visit_id: visit_id ?? this.visit_id,
      order_item_id: order_item_id ?? this.order_item_id,
      doctor_eid: doctor_eid ?? this.doctor_eid,
      item_code: item_code ?? this.item_code,
      item_name: item_name ?? this.item_name,
      item_qty: item_qty ?? this.item_qty,
      dose_qty: dose_qty ?? this.dose_qty,
      dose_unit_name: dose_unit_name ?? this.dose_unit_name,
      base_drug_usage_code: base_drug_usage_code ?? this.base_drug_usage_code,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      fix_item_type_id: fix_item_type_id ?? this.fix_item_type_id,
      item_type_name: item_type_name ?? this.item_type_name,
      drug_type_id: drug_type_id ?? this.drug_type_id,
      patient_age: patient_age ?? this.patient_age,
      drug_type_name: drug_type_name ?? this.drug_type_name,
      note_to_team: note_to_team ?? this.note_to_team,
      caution: caution ?? this.caution,
      drug_description: drug_description ?? this.drug_description,
      start_date_use: start_date_use ?? this.start_date_use,
      end_date_use: start_end_date ?? this.end_date_use,
      order_eid: order_eid ?? this.order_eid,
      order_date: order_date ?? this.order_date,
      order_time: order_time ?? this.order_time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visit_id': visit_id,
      'order_item_id': order_item_id,
      'doctor_eid': doctor_eid,
      'item_code': item_code,
      'item_name': item_name,
      'item_qty': item_qty,
      'dose_qty': dose_qty,
      'dose_unit_name': dose_unit_name,
      'base_drug_usage_code': base_drug_usage_code,
      'drug_instruction': drug_instruction,
      'fix_item_type_id': fix_item_type_id,
      'item_type_name': item_type_name,
      'drug_type_id': drug_type_id,
      'patient_age': patient_age,
      'drug_type_name': drug_type_name,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'start_date_use': start_date_use,
      'start_end_date': end_date_use,
      'order_eid': order_eid,
      'order_date': order_date,
      'order_time': order_time,
    };
  }

  factory ListDataCardModel.fromMap(Map<String, dynamic> map) {
    return ListDataCardModel(
      visit_id: map['visit_id'] != null ? map['visit_id'] as String : null,
      order_item_id:
          map['order_item_id'] != null ? map['order_item_id'] as String : null,
      doctor_eid:
          map['doctor_eid'] != null ? map['doctor_eid'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      dose_unit_name: map['dose_unit_name'] != null
          ? map['dose_unit_name'] as String
          : null,
      base_drug_usage_code: map['base_drug_usage_code'] != null
          ? map['base_drug_usage_code'] as String
          : null,
      drug_instruction: map['drug_instruction'] != null
          ? map['drug_instruction'] as String
          : null,
      fix_item_type_id: map['fix_item_type_id'] != null
          ? map['fix_item_type_id'] as String
          : null,
      item_type_name: map['item_type_name'] != null
          ? map['item_type_name'] as String
          : null,
      drug_type_id:
          map['drug_type_id'] != null ? map['drug_type_id'] as String : null,
      patient_age:
          map['patient_age'] != null ? map['patient_age'] as String : null,
      drug_type_name: map['drug_type_name'] != null
          ? map['drug_type_name'] as String
          : null,
      note_to_team:
          map['note_to_team'] != null ? map['note_to_team'] as String : null,
      caution: map['caution'] != null ? map['caution'] as String : null,
      drug_description: map['drug_description'] != null
          ? map['drug_description'] as String
          : null,
      start_date_use: map['start_date_use'] != null
          ? map['start_date_use'] as String
          : null,
      end_date_use: map['start_end_date'] != null
          ? map['start_end_date'] as String
          : null,
      order_eid: map['order_eid'] != null ? map['order_eid'] as String : null,
      order_date:
          map['order_date'] != null ? map['order_date'] as String : null,
      order_time:
          map['order_time'] != null ? map['order_time'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListDataCardModel.fromJson(String source) =>
      ListDataCardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListDataCardModel(visit_id: $visit_id, order_item_id: $order_item_id, doctor_eid: $doctor_eid, item_code: $item_code, item_name: $item_name, item_qty: $item_qty, dose_qty: $dose_qty, dose_unit_name: $dose_unit_name, base_drug_usage_code: $base_drug_usage_code, drug_instruction: $drug_instruction, fix_item_type_id: $fix_item_type_id, item_type_name: $item_type_name, drug_type_id: $drug_type_id, patient_age: $patient_age, drug_type_name: $drug_type_name, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, start_date_use: $start_date_use, start_end_date: $end_date_use, order_eid: $order_eid, order_date: $order_date, order_time: $order_time)';
  }

  @override
  bool operator ==(covariant ListDataCardModel other) {
    if (identical(this, other)) return true;

    return other.visit_id == visit_id &&
        other.order_item_id == order_item_id &&
        other.doctor_eid == doctor_eid &&
        other.item_code == item_code &&
        other.item_name == item_name &&
        other.item_qty == item_qty &&
        other.dose_qty == dose_qty &&
        other.dose_unit_name == dose_unit_name &&
        other.base_drug_usage_code == base_drug_usage_code &&
        other.drug_instruction == drug_instruction &&
        other.fix_item_type_id == fix_item_type_id &&
        other.item_type_name == item_type_name &&
        other.drug_type_id == drug_type_id &&
        other.patient_age == patient_age &&
        other.drug_type_name == drug_type_name &&
        other.note_to_team == note_to_team &&
        other.caution == caution &&
        other.drug_description == drug_description &&
        other.start_date_use == start_date_use &&
        other.end_date_use == end_date_use &&
        other.order_eid == order_eid &&
        other.order_date == order_date &&
        other.order_time == order_time;
  }

  @override
  int get hashCode {
    return visit_id.hashCode ^
        order_item_id.hashCode ^
        doctor_eid.hashCode ^
        item_code.hashCode ^
        item_name.hashCode ^
        item_qty.hashCode ^
        dose_qty.hashCode ^
        dose_unit_name.hashCode ^
        base_drug_usage_code.hashCode ^
        drug_instruction.hashCode ^
        fix_item_type_id.hashCode ^
        item_type_name.hashCode ^
        drug_type_id.hashCode ^
        patient_age.hashCode ^
        drug_type_name.hashCode ^
        note_to_team.hashCode ^
        caution.hashCode ^
        drug_description.hashCode ^
        start_date_use.hashCode ^
        end_date_use.hashCode ^
        order_eid.hashCode ^
        order_date.hashCode ^
        order_time.hashCode;
  }
}
