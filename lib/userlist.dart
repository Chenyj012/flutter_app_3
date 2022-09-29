class Userdata {
  int userId;
  String userNo;
  String userName;
  String password;
  int enableStatus;

  Userdata(
      {required this.userId, required this.userNo, required this.userName, required this.password, required this.enableStatus});

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    userId: json["userId"],
    userNo: json["userNo"],
    userName: json["userName"],
    password: json["password"],
    enableStatus: json["enableStatus"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userNo": userNo,
    "userName": userName,
    "password": password,
    "enableStatus": enableStatus.toString(),
  };
}