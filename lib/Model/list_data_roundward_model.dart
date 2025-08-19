// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListDataRoundwardModel {
  int? smw_transaction_order_id;
  int? smw_transaction_id;
  String? item_name;
  String? drug_instruction;
  String? date_slot;
  String? slot;
    String? status;
  String? create_date;
  String? comment;
  String? remark;
  ListDataRoundwardModel({
    this.smw_transaction_order_id,
    this.smw_transaction_id,
    this.item_name,
    this.drug_instruction,
    this.date_slot,
    this.slot,
    this.status,
    this.create_date,
    this.comment,
    this.remark,
  });

  ListDataRoundwardModel copyWith({
    int? smw_transaction_order_id,
    int? smw_transaction_id,
    String? item_name,
    String? drug_instruction,
    String? date_slot,
    String? slot,
    String? status,
    String? create_date,
    String? comment,
    String? remark,
  }) {
    return ListDataRoundwardModel(
      smw_transaction_order_id: smw_transaction_order_id ?? this.smw_transaction_order_id,
      smw_transaction_id: smw_transaction_id ?? this.smw_transaction_id,
      item_name: item_name ?? this.item_name,
      drug_instruction: drug_instruction ?? this.drug_instruction,
      date_slot: date_slot ?? this.date_slot,
      slot: slot ?? this.slot,
      status: status ?? this.status,
      create_date: create_date ?? this.create_date,
      comment: comment ?? this.comment,
      remark: remark ?? this.remark,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'smw_transaction_order_id': smw_transaction_order_id,
      'smw_transaction_id': smw_transaction_id,
      'item_name': item_name,
      'drug_instruction': drug_instruction,
      'date_slot': date_slot,
      'slot': slot,
      'status': status,
      'create_date': create_date,
      'comment': comment,
      'remark': remark,
    };
  }

  factory ListDataRoundwardModel.fromMap(Map<String, dynamic> map) {
    return ListDataRoundwardModel(
      smw_transaction_order_id: map['smw_transaction_order_id'] != null ? map['smw_transaction_order_id'] as int : null,
      smw_transaction_id: map['smw_transaction_id'] != null ? map['smw_transaction_id'] as int : null,
      item_name: map['item_name'] != null ? map['item_name'] as String : null,
      drug_instruction: map['drug_instruction'] != null ? map['drug_instruction'] as String : null,
      date_slot: map['date_slot'] != null ? map['date_slot'] as String : null,
      slot: map['slot'] != null ? map['slot'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListDataRoundwardModel.fromJson(String source) => ListDataRoundwardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListDataRoundwardModel(smw_transaction_order_id: $smw_transaction_order_id, smw_transaction_id: $smw_transaction_id, item_name: $item_name, drug_instruction: $drug_instruction, date_slot: $date_slot, slot: $slot, status: $status, create_date: $create_date, comment: $comment, remark: $remark)';
  }

  @override
  bool operator ==(covariant ListDataRoundwardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.smw_transaction_order_id == smw_transaction_order_id &&
      other.smw_transaction_id == smw_transaction_id &&
      other.item_name == item_name &&
      other.drug_instruction == drug_instruction &&
      other.date_slot == date_slot &&
      other.slot == slot &&
      other.status == status &&
      other.create_date == create_date &&
      other.comment == comment &&
      other.remark == remark;
  }

  @override
  int get hashCode {
    return smw_transaction_order_id.hashCode ^
      smw_transaction_id.hashCode ^
      item_name.hashCode ^
      drug_instruction.hashCode ^
      date_slot.hashCode ^
      slot.hashCode ^
      status.hashCode ^
      create_date.hashCode ^
      comment.hashCode ^
      remark.hashCode;
  }
}
