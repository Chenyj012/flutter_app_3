class PurOrderData {
  int supId;
  int orderId;
  int detailId;
  String supName;
  String itemSn;
  String itemName;
  String poNo;
  int qaStatus;
  int uploadStatus;
  bool selected=false;//默认为未选中
  PurOrderData(
      {required this.supId, required this.supName, required this.itemName, required this.itemSn, required this.qaStatus,
        required this.orderId, required this.detailId, required this.uploadStatus, required this.poNo
      });

  factory PurOrderData.fromJson(Map<String, dynamic> json) => PurOrderData(
    supId: json["supId"],
    supName: json["supName"],
    itemName: json["itemName"],
    itemSn: json["itemSn"],
    qaStatus: json["qaStatus"],
    orderId: json["orderId"],
    detailId: json["detailId"],
    uploadStatus: json["uploadStatus"],
    poNo: json["poNo"],
  );

  Map<String, dynamic> toJson() => {
    "supId": supId,
    "supName": supName,
    "itemName": itemName,
    "itemSn": itemSn,
    "qaStatus": qaStatus,
    "orderId": orderId,
    "detailId": detailId,
    "uploadStatus": uploadStatus,
    "poNo": poNo,

  };
}