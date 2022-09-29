class QcReportData {
 // int reportId;
  DateTime pmiCreateddate;
  String pmiImgname;
  String pmiCreator;
  int? id;
  int? pmiSupId;
  String? pmiItemSn;
  String? pmiItemName;
  String? pmiPono;
  String? pmiSupName;



  bool selected=false;//默认为未选中
  QcReportData(
      {required this.pmiCreateddate, required this.pmiImgname, required this.pmiCreator,this.id,this.pmiItemName,this.pmiItemSn,this.pmiPono,this.pmiSupId,
        this.pmiSupName
      });

  factory QcReportData.fromJson(Map<String, dynamic> json) => QcReportData(
    pmiCreateddate: json["pmiCreateddate"],
    pmiImgname: json["pmiImgname"],
    pmiCreator: json["pmiCreator"],
    id: json["id"],
    pmiSupId: json["pmiSupId"],
    pmiItemSn: json["pmiItemSn"],
    pmiItemName: json["pmiItemName"],
    pmiPono: json["pmiPono"],
    pmiSupName: json["pmiSupName"],
  );

  Map<String, dynamic> toJson() => {
    "pmiCreateddate": pmiCreateddate,
    "pmiImgname": pmiImgname,
    "pmiCreator" : pmiCreator,
    "id" :id,
    "pmiSupId":pmiSupId,
    "pmiItemSn":pmiItemSn,
    "pmiItemName":pmiItemName,
    "pmiPono":pmiPono,
    "pmiSupName":pmiSupName
  };
}