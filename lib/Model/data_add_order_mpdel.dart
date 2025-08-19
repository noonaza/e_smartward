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
  String? unit_stock;
  String? status;

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
    this.unit_stock,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        'item_name': item_name ?? '',
        'type_card': type_card ?? '',
        'item_qty': item_qty ?? '0',
        'unit_name': unit_name ?? '',
        'dose_qty': dose_qty ?? '0.00',
        'drug_instruction': drug_instruction ?? '',
        'take_time': take_time ?? '[]',
        'meal_timing': meal_timing ?? '',
        'start_date_use': start_date_use ?? '',
        'end_date_use': end_date_use ?? '',
        'stock_out': stock_out ?? 0,
        'remark': remark ?? '',
        'order_item_id': order_item_id ?? '',
        'doctor_eid': doctor_eid ?? '',
        'item_code': item_code ?? '',
        'note_to_team': note_to_team ?? '',
        'caution': caution ?? '',
        'drug_description': drug_description ?? '',
        'order_eid': order_eid ?? '',
        'order_date': order_date ?? '',
        'order_time': order_time ?? '',
        'time_slot': time_slot ?? '',
        'drug_type_name': drug_type_name ?? '',
        'unit_stock': unit_stock ?? '',
        'status': status ?? 'Order',
      };

  toMap() {}

  static fromMap(Map<String, dynamic> x) {}
}
