import 'package:flutter_app_3/LoginUser.dart';
import 'PurOrderData.dart';
class PurOrderModel {
  String msg;
  String code;
  List<PurOrderData> uData;

  PurOrderModel({required this.msg, required this.code, required this.uData});

  factory PurOrderModel.fromJson(Map<String, dynamic> json) =>
      PurOrderModel(
        msg: json["msg"],
        uData: List<PurOrderData>.from(
            json["data"].map((x) => PurOrderData.fromJson(x))),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "uData": List<dynamic>.from(uData.map((x) => x.toJson())),
    "msg": msg,
  };
}



