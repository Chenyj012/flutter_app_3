import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_3/common/QcReport.dart';

import '../../../model/QcReportModel.dart';

class TableProvide with ChangeNotifier{
  List contextList=[];
  late QcReportModel model;


  getTableInfo(QcReport qcReport) async{
    contextList=[
      {'pmiImgname': 'http://cms-bucket.ws.126.net/2022/0911/834898dep00ri15di0076c004tm04ric.png', 'pmiCreator': '第一幅'},
      {'pmiImgname': 'https://img-blog.csdnimg.cn/20191109230329193.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2VuZGlhbnpoaWppYQ==,size_16,color_FFFFFF,t_70', 'pmiCreator': '第二幅'},
      {'pmiImgname': 'https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2022%2F0915%2F5333784aj00ri99ac00anc000nf00fjg.jpg&thumbnail=660x2147483647&quality=80&type=jpg', 'pmiCreator': '第三幅'},
    ];
    /*try {
      Response response = await Dio().post(
          "http://183.63.128.202:9080/findQcReportImg",
          data: {"pono": qcReport.poNo,
                 "itemsn": qcReport.itemSn});
      assert(response != null);
      model = QcReportModel.fromJson(response.data);
      if (model != null && model.code == '200') {
        *//*setState(() {
          _purorderdataModel = model.uData;
          supplierName = model.uData[0].supName;
          poNumber = model.uData[0].poNo;

        });*//*
        contextList = model.uData;
      } else {
        print('Error, Could not load Data.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }*/
  }

  getTableInfo2() async{
    contextList=[
      {'pmiImgname': 'http://cms-bucket.ws.126.net/2022/0911/834898dep00ri15di0076c004tm04ric.png', 'pmiCreator': '第一幅'},
      {'pmiImgname': 'https://img-blog.csdnimg.cn/20191109230329193.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2VuZGlhbnpoaWppYQ==,size_16,color_FFFFFF,t_70', 'pmiCreator': '第二幅'},
      {'pmiImgname': 'https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2022%2F0915%2F5333784aj00ri99ac00anc000nf00fjg.jpg&thumbnail=660x2147483647&quality=80&type=jpg', 'pmiCreator': '第三幅'},
    ];
    /*try {
      Response response = await Dio().post(
          "http://183.63.128.202:9080/findQcReportImg",
          data: {"pono": qcReport.poNo,
                 "itemsn": qcReport.itemSn});
      assert(response != null);
      model = QcReportModel.fromJson(response.data);
      if (model != null && model.code == '200') {
        *//*setState(() {
          _purorderdataModel = model.uData;
          supplierName = model.uData[0].supName;
          poNumber = model.uData[0].poNo;

        });*//*
        contextList = model.uData;
      } else {
        print('Error, Could not load Data.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }*/
  }


}
