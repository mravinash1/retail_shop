// ignore_for_file: unnecessary_type_check

import 'dart:convert';

List<PurchaseModelClass> purchaseModelFromJson(String str) =>
List<PurchaseModelClass>.from(json.decode(str).map((x) => PurchaseModelClass.fromJson(x)));

class PurchaseModelClass {
  int id;
  String rawname;
  double qty;
  String unitname;
  double amount;
  double otherQty;
  String entrydate;
  String vdate; 
  double rate;
  dynamic shopid;
  dynamic rawcode;
  dynamic fromdeptcode;
  dynamic ordQty;
  dynamic reqQty;

  PurchaseModelClass({
    required this.id,
    required this.rawname,
    required this.qty,
    required this.unitname,
    required this.amount,
    required this.otherQty,
    required this.entrydate,
    required this.vdate,
    required this.rate,
    required this.shopid,
    required this.rawcode,
    required this.fromdeptcode,
    required this.ordQty,
    required this.reqQty,
  });

  factory PurchaseModelClass.fromJson(List<dynamic> json) {
    var data = json[0]; // First element of the nested list

    return PurchaseModelClass(
      id: data['id'] ?? 0,
      rawname: data['rawname'] ?? '',
      qty: data['qty']?.toDouble() ?? 0.0,
      unitname: data['unitname'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      otherQty: json[1]?.toDouble() ?? 0.0, // Outer quantity
      entrydate: data['entrydate'] ?? '',
      vdate: data['vdate'] ?? '',
      rate: data['rate']?.toDouble() ?? 0.0,
      shopid: data['shopid']?? 0,
      rawcode : data['rawcode']?? 0,
      fromdeptcode : data['fromdeptcode']??0,
      ordQty: (json is List) ? (json.length == 2) ? json[1] ?? 0 : 0 : 0,
      reqQty: (json is List) ? (json.length == 4) ? json[3] ?? 0 : 0 : 0,
    );
  }
}
