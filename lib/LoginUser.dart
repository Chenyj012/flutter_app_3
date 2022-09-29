import 'package:flutter_app_3/LoginUser.dart';
import 'package:flutter_app_3/userlist.dart';
class User {
  String msg;
  String code;
  List<Userdata> uData;

  User({required this.msg, required this.code, required this.uData});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        msg: json["msg"],
        uData: List<Userdata>.from(
            json["data"].map((x) => Userdata.fromJson(x))),
        code: json["code"],
      );

 Map<String, dynamic> toJson() => {
    "code": code,
    "uData": List<dynamic>.from(uData.map((x) => x.toJson())),
    "msg": msg,
  };
}



