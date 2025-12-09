// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListDataCardModel {
  int? id;
  String? visit_id;
  String? smw_admit_id;
  String? order_item_id;
  String? doctor_eid;
  String? item_code;
  String? item_name;
  int? item_qty;
  String? unit_name;
  String? take_time;
  String? time_slot;
  String? meal_timing;
  String? dose_qty;
  int? stock_out;
  String? remark;
  String? dose_unit_name;
  String? base_drug_usage_code;
  String? drug_instruction;
  String? fix_item_type_id;
  String? item_type_name;
  String? drug_type_id;
  String? patient_age;
  String? drug_type_name;
  String? note_to_team;
  int? caution;
  String? drug_description;
  String? start_date_use;
  String? end_date_use;
  String? order_eid;
  String? order_date;
  String? order_time;
  String? unit_stock;
  String? status;
  String? update_date;
  String? update_by;
  String? dose_qty_name;
  String? type_slot;
  String? set_slot;
  String? use_now;
  String? start_date_imed;
  String? schedule_mode_label;
  String? meal_take;
  ListDataCardModel({
    this.id,
    this.visit_id,
    this.smw_admit_id,
    this.order_item_id,
    this.doctor_eid,
    this.item_code,
    this.item_name,
    this.item_qty,
    this.unit_name,
    this.take_time,
    this.time_slot,
    this.meal_timing,
    this.dose_qty,
    this.stock_out,
    this.remark,
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
    this.unit_stock,
    this.status,
    this.update_date,
    this.update_by,
    this.dose_qty_name,
    this.type_slot,
    this.set_slot,
    this.use_now,
    this.start_date_imed,
    this.schedule_mode_label,
    this.meal_take,
  });

  ListDataCardModel copyWith({
    int? id,
    String? visit_id,
    String? smw_admit_id,
    String? order_item_id,
    String? doctor_eid,
    String? item_code,
    String? item_name,
    int? item_qty,
    String? unit_name,
    String? take_time,
    String? time_slot,
    String? meal_timing,
    String? dose_qty,
    int? stock_out,
    String? remark,
    String? dose_unit_name,
    String? base_drug_usage_code,
    String? drug_instruction,
    String? fix_item_type_id,
    String? item_type_name,
    String? drug_type_id,
    String? patient_age,
    String? drug_type_name,
    String? note_to_team,
    int? caution,
    String? drug_description,
    String? start_date_use,
    String? end_date_use,
    String? order_eid,
    String? order_date,
    String? order_time,
    String? unit_stock,
    String? status,
    String? update_date,
    String? update_by,
    String? dose_qty_name,
    String? type_slot,
    String? set_slot,
    String? use_now,
    String? start_date_imed,
    String? schedule_mode_label,
    String? meal_take,
  }) {
    return ListDataCardModel(
      id: id ?? this.id,
      visit_id: visit_id ?? this.visit_id,
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      order_item_id: order_item_id ?? this.order_item_id,
      doctor_eid: doctor_eid ?? this.doctor_eid,
      item_code: item_code ?? this.item_code,
      item_name: item_name ?? this.item_name,
      item_qty: item_qty ?? this.item_qty,
      unit_name: unit_name ?? this.unit_name,
      take_time: take_time ?? this.take_time,
      time_slot: time_slot ?? this.time_slot,
      meal_timing: meal_timing ?? this.meal_timing,
      dose_qty: dose_qty ?? this.dose_qty,
      stock_out: stock_out ?? this.stock_out,
      remark: remark ?? this.remark,
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
      end_date_use: end_date_use ?? this.end_date_use,
      order_eid: order_eid ?? this.order_eid,
      order_date: order_date ?? this.order_date,
      order_time: order_time ?? this.order_time,
      unit_stock: unit_stock ?? this.unit_stock,
      status: status ?? this.status,
      update_date: update_date ?? this.update_date,
      update_by: update_by ?? this.update_by,
      dose_qty_name: dose_qty_name ?? this.dose_qty_name,
      type_slot: type_slot ?? this.type_slot,
      set_slot: set_slot ?? this.set_slot,
      use_now: use_now ?? this.use_now,
      start_date_imed: start_date_imed ?? this.start_date_imed,
      schedule_mode_label: schedule_mode_label ?? this.schedule_mode_label,
      meal_take: meal_take ?? this.meal_take,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visit_id': visit_id,
      'smw_admit_id': smw_admit_id,
      'order_item_id': order_item_id,
      'doctor_eid': doctor_eid,
      'item_code': item_code,
      'item_name': item_name,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'take_time': take_time,
      'time_slot': time_slot,
      'meal_timing': meal_timing,
      'dose_qty': dose_qty,
      'stock_out': stock_out,
      'remark': remark,
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
      'end_date_use': end_date_use,
      'order_eid': order_eid,
      'order_date': order_date,
      'order_time': order_time,
      'unit_stock': unit_stock,
      'status': status,
      'update_date': update_date,
      'update_by': update_by,
      'dose_qty_name': dose_qty_name,
      'type_slot': type_slot,
      'set_slot': set_slot,
      'use_now': use_now,
      'start_date_imed': start_date_imed,
      'schedule_mode_label': schedule_mode_label,
      'meal_take': meal_take,
    };
  }

  factory ListDataCardModel.fromMap(Map<String, dynamic> map) {
    return ListDataCardModel(
      id: map['id'] != null ? map['id'] as int : null,
      visit_id: map['visit_id'] != null ? map['visit_id'] as String : null,
      smw_admit_id:
          map['smw_admit_id'] != null ? map['smw_admit_id'] as String : null,
      order_item_id:
          map['order_item_id'] != null ? map['order_item_id'] as String : null,
      doctor_eid:
          map['doctor_eid'] != null ? map['doctor_eid'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as int : null,
      unit_name: map['unit_name'] != null ? map['unit_name'] as String : null,
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      meal_timing:
          map['meal_timing'] != null ? map['meal_timing'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      stock_out: map['stock_out'] != null ? map['stock_out'] as int : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
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
      caution: map['caution'] != null ? map['caution'] as int : null,
      drug_description: map['drug_description'] != null
          ? map['drug_description'] as String
          : null,
      start_date_use: map['start_date_use'] != null
          ? map['start_date_use'] as String
          : null,
      end_date_use:
          map['end_date_use'] != null ? map['end_date_use'] as String : null,
      order_eid: map['order_eid'] != null ? map['order_eid'] as String : null,
      order_date:
          map['order_date'] != null ? map['order_date'] as String : null,
      order_time:
          map['order_time'] != null ? map['order_time'] as String : null,
      unit_stock:
          map['unit_stock'] != null ? map['unit_stock'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      update_date:
          map['update_date'] != null ? map['update_date'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      dose_qty_name:
          map['dose_qty_name'] != null ? map['dose_qty_name'] as String : null,
      type_slot: map['type_slot'] != null ? map['type_slot'] as String : null,
      set_slot: map['set_slot'] != null ? map['set_slot'] as String : null,
      use_now: map['use_now'] != null ? map['use_now'] as String : null,
      start_date_imed: map['start_date_imed'] != null
          ? map['start_date_imed'] as String
          : null,
      schedule_mode_label: map['schedule_mode_label'] != null
          ? map['schedule_mode_label'] as String
          : null,
      meal_take: map['meal_take'] != null ? map['meal_take'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListDataCardModel.fromJson(String source) =>
      ListDataCardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListDataCardModel(id: $id, visit_id: $visit_id, smw_admit_id: $smw_admit_id, order_item_id: $order_item_id, doctor_eid: $doctor_eid, item_code: $item_code, item_name: $item_name, item_qty: $item_qty, unit_name: $unit_name, take_time: $take_time, time_slot: $time_slot, meal_timing: $meal_timing, dose_qty: $dose_qty, stock_out: $stock_out, remark: $remark, dose_unit_name: $dose_unit_name, base_drug_usage_code: $base_drug_usage_code, drug_instruction: $drug_instruction, fix_item_type_id: $fix_item_type_id, item_type_name: $item_type_name, drug_type_id: $drug_type_id, patient_age: $patient_age, drug_type_name: $drug_type_name, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, start_date_use: $start_date_use, end_date_use: $end_date_use, order_eid: $order_eid, order_date: $order_date, order_time: $order_time, unit_stock: $unit_stock, status: $status, update_date: $update_date, update_by: $update_by, dose_qty_name: $dose_qty_name, type_slot: $type_slot, set_slot: $set_slot, use_now: $use_now, start_date_imed: $start_date_imed, schedule_mode_label: $schedule_mode_label, meal_take: $meal_take)';
  }

  @override
  bool operator ==(covariant ListDataCardModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visit_id == visit_id &&
        other.smw_admit_id == smw_admit_id &&
        other.order_item_id == order_item_id &&
        other.doctor_eid == doctor_eid &&
        other.item_code == item_code &&
        other.item_name == item_name &&
        other.item_qty == item_qty &&
        other.unit_name == unit_name &&
        other.take_time == take_time &&
        other.time_slot == time_slot &&
        other.meal_timing == meal_timing &&
        other.dose_qty == dose_qty &&
        other.stock_out == stock_out &&
        other.remark == remark &&
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
        other.order_time == order_time &&
        other.unit_stock == unit_stock &&
        other.status == status &&
        other.update_date == update_date &&
        other.update_by == update_by &&
        other.dose_qty_name == dose_qty_name &&
        other.type_slot == type_slot &&
        other.set_slot == set_slot &&
        other.use_now == use_now &&
        other.start_date_imed == start_date_imed &&
        other.schedule_mode_label == schedule_mode_label &&
        other.meal_take == meal_take;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        visit_id.hashCode ^
        smw_admit_id.hashCode ^
        order_item_id.hashCode ^
        doctor_eid.hashCode ^
        item_code.hashCode ^
        item_name.hashCode ^
        item_qty.hashCode ^
        unit_name.hashCode ^
        take_time.hashCode ^
        time_slot.hashCode ^
        meal_timing.hashCode ^
        dose_qty.hashCode ^
        stock_out.hashCode ^
        remark.hashCode ^
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
        order_time.hashCode ^
        unit_stock.hashCode ^
        status.hashCode ^
        update_date.hashCode ^
        update_by.hashCode ^
        dose_qty_name.hashCode ^
        type_slot.hashCode ^
        set_slot.hashCode ^
        use_now.hashCode ^
        start_date_imed.hashCode ^
        schedule_mode_label.hashCode ^
        meal_take.hashCode;
  }
}
