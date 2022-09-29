import 'package:flutter/material.dart';
import 'package:flutter_app_3/common/ColorsUtil.dart';
import '../../../common/QcReport.dart';
import '/widgets/components/images_picker/images_gridview_widget.dart';
import '/views/BaseTitleBar.dart';


class DongtaiWidget extends StatefulWidget implements PreferredSizeWidget {
  /*DongtaiWidget({this.poNo, this.itemSn, this.itemName}) ;
  final String? poNo;
  final String? itemSn;
  final String? itemName;*/
  final QcReport qcReport;
  DongtaiWidget(this.qcReport);
  ///这里设置控件（appBar）的高度
  @override
  Size get preferredSize => Size.fromHeight(50.0);
  @override
  State<StatefulWidget> createState() {
    return DongtaiWidgetState(this.qcReport/*poNo: poNo,itemSn: itemSn,itemName: itemName*/);
  }
}

class DongtaiWidgetState extends State<DongtaiWidget>   {
  /*DongtaiWidgetState({this.poNo, this.itemSn, this.itemName}) ;
  final String? poNo;
  final String? itemSn;
  final String? itemName;*/
  final QcReport qcReport2;
  DongtaiWidgetState(this.qcReport2);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: false,

//      appBar: AppBar(title: Text('Draggable Demo')),
        appBar: new PreferredSize(
       // new BaseViewBar(
            child: new BaseTitleBar(
              "选择报告",
              mycolor: Colors.green,// Color(0xffb5dbf7),
              leftIcon: Icons.arrow_back_ios,
              rightText: "上传",
              rightClick: () {
              //  print("点击了干嘛啊。。。哦");
                uploadImageToServer(qcReport2);
              },
            ),
            preferredSize: Size.fromHeight(50.0)),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: '请选择正确的QC报告上传...',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),

                  border: InputBorder.none, //去掉底部下划线
                ),
              ),
            ),
           ImagesGridviewWidget(/*poNo: poNo,itemSn: itemSn,itemName: itemName*/),
          ],
        ));
  }


}
