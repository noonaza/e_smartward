// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListFoodModel {
  int? id;
  int? smw_admit_id;
  String? type_card;
  String? item_name;
  String? item_qty;
  String? unit_name;
  String? dose_qty;
  String? meal_timing;
  String? drug_instruction;
  String? take_time;
  String? start_date_use;
  String? end_date_use;
  int? stock_out;
  String? remark;
  String? create_date;
  String? create_by;
  String? delete_date;
  String? delete_by;
  String? order_item_id;
  String? doctor_eid;
  String? item_code;
  String? note_to_team;
  String? caution;
  String? drug_description;
  String? order_eid;
  String? order_date;
  String? order_time;
  String? drug_type_name;
  String? time_slot;
  String? hn_number;
  String? an_number;
  String? visit_number;
  String? pet_name;
  String? pre_pare_status;
  String? date_slot;
  String? status;
  String? bed_number;
  
  ListFoodModel({
    this.id,
    this.smw_admit_id,
    this.type_card,
    this.item_name,
    this.item_qty,
    this.unit_name,
    this.dose_qty,
    this.meal_timing,
    this.drug_instruction,
    this.take_time,
    this.start_date_use,
    this.end_date_use,
    this.stock_out,
    this.remark,
    this.create_date,
    this.create_by,
    this.delete_date,
    this.delete_by,
    this.order_item_id,
    this.doctor_eid,
    this.item_code,
    this.note_to_team,
    this.caution,
    this.drug_description,
    this.order_eid,
    this.order_date,
    this.order_time,
    this.drug_type_name,
    this.time_slot,
    this.hn_number,
    this.an_number,
    this.visit_number,
    this.pet_name,
    this.pre_pare_status,
    this.date_slot,
    this.status,
    this.bed_number,
  });

  get active_time => null;


  ListFoodModel copyWith({
    int? id,
    int? smw_admit_id,
    String? type_card,
    String? item_name,
    String? item_qty,
    String? unit_name,
    String? dose_qty,
    String? meal_timing,
    String? drug_instruction,
    String? take_time,
    String? start_date_use,
    String? end_date_use,
    int? stock_out,
    String? remark,
    String? create_date,
    String? create_by,
    String? delete_date,
    String? delete_by,
    String? order_item_id,
    String? doctor_eid,
    String? item_code,
    String? note_to_team,
    String? caution,
    String? drug_description,
    String? order_eid,
    String? order_date,
    String? order_time,
    String? drug_type_name,
    String? time_slot,
    String? hn_number,
    String? an_number,
    String? visit_number,
    String? pet_name,
    String? pre_pare_status,
    String? date_slot,
    String? status,
    String? bed_number,
  }) {
    return ListFoodModel(
      id: id ?? this.id,
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      type_card: type_card ?? this.type_card,
      item_name: item_name ?? this.item_name,
      item_qty: item_qty ?? this.item_qty,
      unit_name: unit_name ?? this.unit_name,
      dose_qty: dose_qty ?? this.dose_qty,
      meal_timing: meal_timing ?? this.meal_timing,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      take_time: take_time ?? this.take_time,
      start_date_use: start_date_use ?? this.start_date_use,
      end_date_use: end_date_use ?? this.end_date_use,
      stock_out: stock_out ?? this.stock_out,
      remark: remark ?? this.remark,
      create_date: create_date ?? this.create_date,
      create_by: create_by ?? this.create_by,
      delete_date: delete_date ?? this.delete_date,
      delete_by: delete_by ?? this.delete_by,
      order_item_id: order_item_id ?? this.order_item_id,
      doctor_eid: doctor_eid ?? this.doctor_eid,
      item_code: item_code ?? this.item_code,
      note_to_team: note_to_team ?? this.note_to_team,
      caution: caution ?? this.caution,
      drug_description: drug_description ?? this.drug_description,
      order_eid: order_eid ?? this.order_eid,
      order_date: order_date ?? this.order_date,
      order_time: order_time ?? this.order_time,
      drug_type_name: drug_type_name ?? this.drug_type_name,
      time_slot: time_slot ?? this.time_slot,
      hn_number: hn_number ?? this.hn_number,
      an_number: an_number ?? this.an_number,
      visit_number: visit_number ?? this.visit_number,
      pet_name: pet_name ?? this.pet_name,
      pre_pare_status: pre_pare_status ?? this.pre_pare_status,
      date_slot: date_slot ?? this.date_slot,
      status: status ?? this.status,
      bed_number: bed_number ?? this.bed_number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'smw_admit_id': smw_admit_id,
      'type_card': type_card,
      'item_name': item_name,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'dose_qty': dose_qty,
      'meal_timing': meal_timing,
      'drug_instruction': drug_instruction,
      'take_time': take_time,
      'start_date_use': start_date_use,
      'end_date_use': end_date_use,
      'stock_out': stock_out,
      'remark': remark,
      'create_date': create_date,
      'create_by': create_by,
      'delete_date': delete_date,
      'delete_by': delete_by,
      'order_item_id': order_item_id,
      'doctor_eid': doctor_eid,
      'item_code': item_code,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'order_eid': order_eid,
      'order_date': order_date,
      'order_time': order_time,
      'drug_type_name': drug_type_name,
      'time_slot': time_slot,
      'hn_number': hn_number,
      'an_number': an_number,
      'visit_number': visit_number,
      'pet_name': pet_name,
      'pre_pare_status': pre_pare_status,
      'date_slot': date_slot,
      'status': status,
      'bed_number': bed_number,
    };
  }

  factory ListFoodModel.fromMap(Map<String, dynamic> map) {
    return ListFoodModel(
      id: map['id'] != null ? map['id'] as int : null,
      smw_admit_id: map['smw_admit_id'] != null ? map['smw_admit_id'] as int : null,
      type_card: map['type_card'] != null ? map['type_card'] as String : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as String : null,
      unit_name: map['unit_name'] != null ? map['unit_name'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      meal_timing: map['meal_timing'] != null ? map['meal_timing'] as String : null,
      drug_instruction: map['drug_instruction'] != null ? map['drug_instruction'] as String : null,
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      start_date_use: map['start_date_use'] != null ? map['start_date_use'] as String : null,
      end_date_use: map['end_date_use'] != null ? map['end_date_use'] as String : null,
      stock_out: map['stock_out'] != null ? map['stock_out'] as int : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      create_by: map['create_by'] != null ? map['create_by'] as String : null,
      delete_date: map['delete_date'] != null ? map['delete_date'] as String : null,
      delete_by: map['delete_by'] != null ? map['delete_by'] as String : null,
      order_item_id: map['order_item_id'] != null ? map['order_item_id'] as String : null,
      doctor_eid: map['doctor_eid'] != null ? map['doctor_eid'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      note_to_team: map['note_to_team'] != null ? map['note_to_team'] as String : null,
      caution: map['caution'] != null ? map['caution'] as String : null,
      drug_description: map['drug_description'] != null ? map['drug_description'] as String : null,
      order_eid: map['order_eid'] != null ? map['order_eid'] as String : null,
      order_date: map['order_date'] != null ? map['order_date'] as String : null,
      order_time: map['order_time'] != null ? map['order_time'] as String : null,
      drug_type_name: map['drug_type_name'] != null ? map['drug_type_name'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      hn_number: map['hn_number'] != null ? map['hn_number'] as String : null,
      an_number: map['an_number'] != null ? map['an_number'] as String : null,
      visit_number: map['visit_number'] != null ? map['visit_number'] as String : null,
      pet_name: map['pet_name'] != null ? map['pet_name'] as String : null,
      pre_pare_status: map['pre_pare_status'] != null ? map['pre_pare_status'] as String : null,
      date_slot: map['date_slot'] != null ? map['date_slot'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      bed_number: map['bed_number'] != null ? map['bed_number'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListFoodModel.fromJson(String source) => ListFoodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListFoodModel(id: $id, smw_admit_id: $smw_admit_id, type_card: $type_card, item_name: $item_name, item_qty: $item_qty, unit_name: $unit_name, dose_qty: $dose_qty, meal_timing: $meal_timing, drug_instruction: $drug_instruction, take_time: $take_time, start_date_use: $start_date_use, end_date_use: $end_date_use, stock_out: $stock_out, remark: $remark, create_date: $create_date, create_by: $create_by, delete_date: $delete_date, delete_by: $delete_by, order_item_id: $order_item_id, doctor_eid: $doctor_eid, item_code: $item_code, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, order_eid: $order_eid, order_date: $order_date, order_time: $order_time, drug_type_name: $drug_type_name, time_slot: $time_slot, hn_number: $hn_number, an_number: $an_number, visit_number: $visit_number, pet_name: $pet_name, pre_pare_status: $pre_pare_status, date_slot: $date_slot, status: $status, bed_number: $bed_number)';
  }

  @override
  bool operator ==(covariant ListFoodModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.smw_admit_id == smw_admit_id &&
      other.type_card == type_card &&
      other.item_name == item_name &&
      other.item_qty == item_qty &&
      other.unit_name == unit_name &&
      other.dose_qty == dose_qty &&
      other.meal_timing == meal_timing &&
      other.drug_instruction == drug_instruction &&
      other.take_time == take_time &&
      other.start_date_use == start_date_use &&
      other.end_date_use == end_date_use &&
      other.stock_out == stock_out &&
      other.remark == remark &&
      other.create_date == create_date &&
      other.create_by == create_by &&
      other.delete_date == delete_date &&
      other.delete_by == delete_by &&
      other.order_item_id == order_item_id &&
      other.doctor_eid == doctor_eid &&
      other.item_code == item_code &&
      other.note_to_team == note_to_team &&
      other.caution == caution &&
      other.drug_description == drug_description &&
      other.order_eid == order_eid &&
      other.order_date == order_date &&
      other.order_time == order_time &&
      other.drug_type_name == drug_type_name &&
      other.time_slot == time_slot &&
      other.hn_number == hn_number &&
      other.an_number == an_number &&
      other.visit_number == visit_number &&
      other.pet_name == pet_name &&
      other.pre_pare_status == pre_pare_status &&
      other.date_slot == date_slot &&
      other.status == status &&
      other.bed_number == bed_number;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      smw_admit_id.hashCode ^
      type_card.hashCode ^
      item_name.hashCode ^
      item_qty.hashCode ^
      unit_name.hashCode ^
      dose_qty.hashCode ^
      meal_timing.hashCode ^
      drug_instruction.hashCode ^
      take_time.hashCode ^
      start_date_use.hashCode ^
      end_date_use.hashCode ^
      stock_out.hashCode ^
      remark.hashCode ^
      create_date.hashCode ^
      create_by.hashCode ^
      delete_date.hashCode ^
      delete_by.hashCode ^
      order_item_id.hashCode ^
      doctor_eid.hashCode ^
      item_code.hashCode ^
      note_to_team.hashCode ^
      caution.hashCode ^
      drug_description.hashCode ^
      order_eid.hashCode ^
      order_date.hashCode ^
      order_time.hashCode ^
      drug_type_name.hashCode ^
      time_slot.hashCode ^
      hn_number.hashCode ^
      an_number.hashCode ^
      visit_number.hashCode ^
      pet_name.hashCode ^
      pre_pare_status.hashCode ^
      date_slot.hashCode ^
      status.hashCode ^
      bed_number.hashCode;
  }
}
