// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataObsDetail {
  int? obs;
  int? col;
  String? time_slot;
  int? delete;
  DataObsDetail({
    this.obs,
    this.col,
    this.time_slot,
    this.delete,
  });

  DataObsDetail copyWith({
    int? obs,
    int? col,
    String? time_slot,
    int? delete,
  }) {
    return DataObsDetail(
      obs: obs ?? this.obs,
      col: col ?? this.col,
      time_slot: time_slot ?? this.time_slot,
      delete: delete ?? this.delete,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'obs': obs,
      'col': col,
      'time_slot': time_slot,
      'delete': delete,
    };
  }

  factory DataObsDetail.fromMap(Map<String, dynamic> map) {
    return DataObsDetail(
      obs: map['obs'] != null ? map['obs'] as int : null,
      col: map['col'] != null ? map['col'] as int : null,
      time_slot: map['time_slot'] != null ? map['time_slot'] as String : null,
      delete: map['delete'] != null ? map['delete'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataObsDetail.fromJson(String source) => DataObsDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataObsDetail(obs: $obs, col: $col, time_slot: $time_slot, delete: $delete)';
  }

  @override
  bool operator ==(covariant DataObsDetail other) {
    if (identical(this, other)) return true;
  
    return 
      other.obs == obs &&
      other.col == col &&
      other.time_slot == time_slot &&
      other.delete == delete;
  }

  @override
  int get hashCode {
    return obs.hashCode ^
      col.hashCode ^
      time_slot.hashCode ^
      delete.hashCode;
  }
}
