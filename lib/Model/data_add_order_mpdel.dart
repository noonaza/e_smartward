// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataAddOrderModel {
  String? item_name;
  String? type_card;
  String? item_qty;
  String? unit_name;
  String? dose_qty;
  String? drug_instruction;
  String? take_time;
  String? meal_timing;
  String? start_date_use;
  String? end_date_use;
  int? stock_out;
  String? remark;
  String? order_item_id;
  String? doctor_eid;
  String? item_code;
  String? note_to_team;
  String? caution;
  String? drug_description;
  String? order_eid;
  String? order_date;
  String? order_time;
  String? time_slot;
  String? drug_type_name;
  String? type_slot;
  String? set_slot;
  String? use_now;
  String? start_date_imed;
  String? unit_stock;
  String? status;
  String? schedule_mode_label;
  String? meal_take;


  DataAddOrderModel({
    this.item_name,
    this.type_card,
    this.item_qty,
    this.unit_name,
    this.dose_qty,
    this.drug_instruction,
    this.take_time,
    this.meal_timing,
    this.start_date_use,
    this.end_date_use,
    this.stock_out,
    this.remark,
    this.order_item_id,
    this.doctor_eid,
    this.item_code,
    this.note_to_team,
    this.caution,
    this.drug_description,
    this.order_eid,
    this.order_date,
    this.order_time,
    this.time_slot,
    this.drug_type_name,
    this.type_slot,
    this.set_slot,
    this.use_now,
    this.start_date_imed,
    this.unit_stock,
    this.status,
    this.schedule_mode_label,
    this.meal_take,
  });

  DataAddOrderModel copyWith({
    String? item_name,
    String? type_card,
    String? item_qty,
    String? unit_name,
    String? dose_qty,
    String? drug_instruction,
    String? take_time,
    String? meal_timing,
    String? start_date_use,
    String? end_date_use,
    int? stock_out,
    String? remark,
    String? order_item_id,
    String? doctor_eid,
    String? item_code,
    String? note_to_team,
    String? caution,
    String? drug_description,
    String? order_eid,
    String? order_date,
    String? order_time,
    String? time_slot,
    String? drug_type_name,
    String? type_slot,
    String? set_slot,
    String? use_now,
    String? start_date_imed,
    String? unit_stock,
    String? status,
    String? schedule_mode_label,
    String? meal_take,
  }) {
    return DataAddOrderModel(
      item_name: item_name ?? this.item_name,
      type_card: type_card ?? this.type_card,
      item_qty: item_qty ?? this.item_qty,
      unit_name: unit_name ?? this.unit_name,
      dose_qty: dose_qty ?? this.dose_qty,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      take_time: take_time ?? this.take_time,
      meal_timing: meal_timing ?? this.meal_timing,
      start_date_use: start_date_use ?? this.start_date_use,
      end_date_use: end_date_use ?? this.end_date_use,
      stock_out: stock_out ?? this.stock_out,
      remark: remark ?? this.remark,
      order_item_id: order_item_id ?? this.order_item_id,
      doctor_eid: doctor_eid ?? this.doctor_eid,
      item_code: item_code ?? this.item_code,
      note_to_team: note_to_team ?? this.note_to_team,
      caution: caution ?? this.caution,
      drug_description: drug_description ?? this.drug_description,
      order_eid: order_eid ?? this.order_eid,
      order_date: order_date ?? this.order_date,
      order_time: order_time ?? this.order_time,
      time_slot: time_slot ?? this.time_slot,
      drug_type_name: drug_type_name ?? this.drug_type_name,
      type_slot: type_slot ?? this.type_slot,
      set_slot: set_slot ?? this.set_slot,
      use_now: use_now ?? this.use_now,
      start_date_imed: start_date_imed ?? this.start_date_imed,
      unit_stock: unit_stock ?? this.unit_stock,
      status: status ?? this.status,
      schedule_mode_label: schedule_mode_label ?? this.schedule_mode_label,
      meal_take: meal_take ?? this.meal_take,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_name': item_name,
      'type_card': type_card,
      'item_qty': item_qty,
      'unit_name': unit_name,
      'dose_qty': dose_qty,
      'drug_instruction': drug_instruction,
      'take_time': take_time,
      'meal_timing': meal_timing,
      'start_date_use': start_date_use,
      'end_date_use': end_date_use,
      'stock_out': stock_out,
      'remark': remark,
      'order_item_id': order_item_id,
      'doctor_eid': doctor_eid,
      'item_code': item_code,
      'note_to_team': note_to_team,
      'caution': caution,
      'drug_description': drug_description,
      'order_eid': order_eid,
      'order_date': order_date,
      'order_time': order_time,
      'time_slot': time_slot,
      'drug_type_name': drug_type_name,
      'type_slot': type_slot,
      'set_slot': set_slot,
      'use_now': use_now,
      'start_date_imed': start_date_imed,
      'unit_stock': unit_stock,
      'status': status,
      'schedule_mode_label': schedule_mode_label,
      'meal_take': meal_take,
    };
  }

  factory DataAddOrderModel.fromMap(Map<String, dynamic> map) {
    return DataAddOrderModel(
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      type_card: map['type_card'] != null ? map['type_card'] as String : null,
      item_qty: map['item_qty'] != null ? map['item_qty'] as String : null,
      unit_name: map['unit_name'] != null ? map['unit_name'] as String : null,
      dose_qty: map['dose_qty'] != null ? map['dose_qty'] as String : null,
      drug_instruction: map['drug_instruction'] != null
          ? map['drug_instruction'] as String
          : null,
      take_time: map['take_time'] != null ? map['take_time'] as String : null,
      meal_timing:
          map['meal_timing'] != null ? map['meal_timing'] as String : null,
      start_date_use: map['start_date_use'] != null
          ? map['start_date_use'] as String
          : null,
      end_date_use:
          map['end_date_use'] != null ? map['end_date_use'] as String : null,
      stock_out: map['stock_out'] != null ? map['stock_out'] as int : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      order_item_id:
          map['order_item_id'] != null ? map['order_item_id'] as String : null,
      doctor_eid:
          map['doctor_eid'] != null ? map['doctor_eid'] as String : null,
      item_code: map['item_code'] != null ? map['item_code'] as String : null,
      note_to_team:
          map['note_to_team'] != null ? map['note_to_team'] as String : null,
      caution: map['caution'] != null ? map['caution'] as String : null,
      drug_description: map['drug_description'] != null
          ? map['drug_description'] as String
          : null,
      order_eid: map['order_eid'] != null ? map['order_eid'] as String : null,
      order_date:
          map['order_date'] != null ? map['order_date'] as String : null,
      order_time:
          map['order_time'] != null ? map['order_time'] as String : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      drug_type_name: map['drug_type_name'] != null
          ? map['drug_type_name'] as String
          : null,
      type_slot: map['type_slot'] != null ? map['type_slot'] as String : null,
      set_slot: map['set_slot'] != null ? map['set_slot'] as String : null,
      use_now: map['use_now'] != null ? map['use_now'] as String : null,
      start_date_imed: map['start_date_imed'] != null
          ? map['start_date_imed'] as String
          : null,
      unit_stock:
          map['unit_stock'] != null ? map['unit_stock'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      schedule_mode_label: map['schedule_mode_label'] != null
          ? map['schedule_mode_label'] as String
          : null,
      meal_take: map['meal_take'] != null ? map['meal_take'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataAddOrderModel.fromJson(String source) =>
      DataAddOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataAddOrderModel(item_name: $item_name, type_card: $type_card, item_qty: $item_qty, unit_name: $unit_name, dose_qty: $dose_qty, drug_instruction: $drug_instruction, take_time: $take_time, meal_timing: $meal_timing, start_date_use: $start_date_use, end_date_use: $end_date_use, stock_out: $stock_out, remark: $remark, order_item_id: $order_item_id, doctor_eid: $doctor_eid, item_code: $item_code, note_to_team: $note_to_team, caution: $caution, drug_description: $drug_description, order_eid: $order_eid, order_date: $order_date, order_time: $order_time, time_slot: $time_slot, drug_type_name: $drug_type_name, type_slot: $type_slot, set_slot: $set_slot, use_now: $use_now, start_date_imed: $start_date_imed, unit_stock: $unit_stock, status: $status, schedule_mode_label: $schedule_mode_label, meal_take: $meal_take)';
  }

  @override
  bool operator ==(covariant DataAddOrderModel other) {
    if (identical(this, other)) return true;

    return other.item_name == item_name &&
        other.type_card == type_card &&
        other.item_qty == item_qty &&
        other.unit_name == unit_name &&
        other.dose_qty == dose_qty &&
        other.drug_instruction == drug_instruction &&
        other.take_time == take_time &&
        other.meal_timing == meal_timing &&
        other.start_date_use == start_date_use &&
        other.end_date_use == end_date_use &&
        other.stock_out == stock_out &&
        other.remark == remark &&
        other.order_item_id == order_item_id &&
        other.doctor_eid == doctor_eid &&
        other.item_code == item_code &&
        other.note_to_team == note_to_team &&
        other.caution == caution &&
        other.drug_description == drug_description &&
        other.order_eid == order_eid &&
        other.order_date == order_date &&
        other.order_time == order_time &&
        other.time_slot == time_slot &&
        other.drug_type_name == drug_type_name &&
        other.type_slot == type_slot &&
        other.set_slot == set_slot &&
        other.use_now == use_now &&
        other.start_date_imed == start_date_imed &&
        other.unit_stock == unit_stock &&
        other.status == status &&
        other.schedule_mode_label == schedule_mode_label &&
        other.meal_take == meal_take;
  }

  @override
  int get hashCode {
    return item_name.hashCode ^
        type_card.hashCode ^
        item_qty.hashCode ^
        unit_name.hashCode ^
        dose_qty.hashCode ^
        drug_instruction.hashCode ^
        take_time.hashCode ^
        meal_timing.hashCode ^
        start_date_use.hashCode ^
        end_date_use.hashCode ^
        stock_out.hashCode ^
        remark.hashCode ^
        order_item_id.hashCode ^
        doctor_eid.hashCode ^
        item_code.hashCode ^
        note_to_team.hashCode ^
        caution.hashCode ^
        drug_description.hashCode ^
        order_eid.hashCode ^
        order_date.hashCode ^
        order_time.hashCode ^
        time_slot.hashCode ^
        drug_type_name.hashCode ^
        type_slot.hashCode ^
        set_slot.hashCode ^
        use_now.hashCode ^
        start_date_imed.hashCode ^
        unit_stock.hashCode ^
        status.hashCode ^
        schedule_mode_label.hashCode ^
        meal_take.hashCode;
  }
}
