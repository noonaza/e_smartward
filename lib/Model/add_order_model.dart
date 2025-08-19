// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_smartward/Model/data_add_order_mpdel.dart';

class AddOrderModel {
  int? smw_admit_id;
  int? tl_common_users_id;
  List<DataAddOrderModel>? dataOder;
  AddOrderModel({
    this.smw_admit_id,
    this.tl_common_users_id,
    this.dataOder,
  });

  AddOrderModel copyWith({
    int? smw_admit_id,
    int? tl_common_users_id,
    List<DataAddOrderModel>? dataOder,
  }) {
    return AddOrderModel(
      smw_admit_id: smw_admit_id ?? this.smw_admit_id,
      tl_common_users_id: tl_common_users_id ?? this.tl_common_users_id,
      dataOder: dataOder ?? this.dataOder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'smw_admit_id': smw_admit_id,
      'tl_common_users_id': tl_common_users_id,
      'dataOder': dataOder!.map((x) => x.toMap()).toList(),
    };
  }

  factory AddOrderModel.fromMap(Map<String, dynamic> map) {
    return AddOrderModel(
      smw_admit_id:
          map['smw_admit_id'] != null ? map['smw_admit_id'] as int : null,
      tl_common_users_id: map['tl_common_users_id'] != null
          ? map['tl_common_users_id'] as int
          : null,
      dataOder: map['dataOder'] != null
          ? List<DataAddOrderModel>.from(
              (map['dataOder'] as List<int>).map<DataAddOrderModel?>(
                (x) => DataAddOrderModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddOrderModel.fromJson(String source) =>
      AddOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AddOrderModel(smw_admit_id: $smw_admit_id, tl_common_users_id: $tl_common_users_id, dataOder: $dataOder)';

  @override
  bool operator ==(covariant AddOrderModel other) {
    if (identical(this, other)) return true;

    return other.smw_admit_id == smw_admit_id &&
        other.tl_common_users_id == tl_common_users_id &&
        listEquals(other.dataOder, dataOder);
  }

  @override
  int get hashCode =>
      smw_admit_id.hashCode ^ tl_common_users_id.hashCode ^ dataOder.hashCode;
}
