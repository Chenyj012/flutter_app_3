import 'package:flutter_app_3/LoginUser.dart';
import 'package:flutter_app_3/common/QcReport.dart';
import 'QcReportData.dart';
class QcReportModel {
  String msg;
  String code;
  List<QcReportData> uData;

  QcReportModel({required this.msg, required this.code, required this.uData});

  factory QcReportModel.fromJson(Map<String, dynamic> json) =>
      QcReportModel(
        msg: json["msg"],
        uData: List<QcReportData>.from(
            json["data"].map((x) => QcReportData.fromJson(x))),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "uData": List<dynamic>.from(uData.map((x) => x.toJson())),
    "msg": msg,
  };
}



