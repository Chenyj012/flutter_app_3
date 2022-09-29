import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
/*import '../../../common/ExtendImg.dart';*/
import '../../../common/QcReport.dart';
import '../../../common/animation_net_image.dart';
import '../dataTable/QcReportTable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_3/common/QcReport.dart';

import '../../../model/QcReportModel.dart';

class CommodityPage extends StatefulWidget {

  final QcReport qcReport;
  CommodityPage(this.qcReport);
  _CommodityPageState createState() => _CommodityPageState(this.qcReport);
}

class _CommodityPageState extends State<CommodityPage> {

  List? contextList;
  final QcReport qcReport;
  _CommodityPageState (this.qcReport);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance=ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(title: Text('已上传的QC报告'),),
      body:Container(
        child: FutureBuilder(
          //future: _getInfo(context,this.qcReport),     //调用请求方法
          future: _getInfo2(context),     //调用请求方法
          builder: (context,snapshot){
            if(snapshot.hasData){                      //判断是否有返回值

            // contextList=Provide.value<TableProvide>(context).contextList;       //返回结果进行赋值
            //  contextList=Provide.value<TableProvide>(context).contextList;
              return Center(
                  child: ListView.builder(                                      //用listView进行布局
                    itemCount: contextList?.length,
                    itemBuilder: (BuildContext context,int index){
                      return rowContext(context,index);
                    },
                  )
              );
            }else{
              return Center(
                  child:Text('加载中')
              );
            }
          },
        ),
      ),
    );
  }

  Widget rowContext(context,index){
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(                                                                //显示图片
            width: ScreenUtil().setWidth(400),
            height: ScreenUtil().setHeight(500),
            margin: EdgeInsets.only(bottom: 5),//
            child: Image.network('http://183.63.128.202:9080/file/qcreport/${contextList![index].pmiImgname}',fit: BoxFit.fill,),
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return HYImageDetailPage('http://183.63.128.202:9080/file/qcreport/${contextList![index].pmiImgname}');
            }));
           /* Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: Duration(seconds: 3),
                pageBuilder: (ctx, animation1, animation2) {
                  return FadeTransition(
                    opacity: animation1,
                    child: HYModalPage(),
                  );
                }
            ));*/
          },
        ),
        Text('${contextList![index].pmiCreator}')                                     //显示文字
      ],
    );
  }


  _getInfo(BuildContext context,QcReport qcReport) async{
     Provide.value<TableProvide>(context).getTableInfo(qcReport);
    return '加载完毕';
  }

 Future _getInfo2(BuildContext context) async{
 // await  Provide.value<TableProvide>(context).getTableInfo2();
   /*contextList=[
     {'pmiImgname': 'http://cms-bucket.ws.126.net/2022/0911/834898dep00ri15di0076c004tm04ric.png', 'pmiCreator': '第一幅'},
     {'pmiImgname': 'https://img-blog.csdnimg.cn/20191109230329193.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2VuZGlhbnpoaWppYQ==,size_16,color_FFFFFF,t_70', 'pmiCreator': '第二幅'},
     {'pmiImgname': 'https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2022%2F0915%2F5333784aj00ri99ac00anc000nf00fjg.jpg&thumbnail=660x2147483647&quality=80&type=jpg', 'pmiCreator': '第三幅'},
   ];*/
   QcReportModel model;
   try {
     Response response = await Dio().post(
         "http://183.63.128.202:9080/findQcReportImg",
         data: {"pono": qcReport.poNo,
           "itemsn": qcReport.itemSn});
     assert(response != null);
     model = QcReportModel.fromJson(response.data);
     if (model != null && model.code == '200') {

   contextList = model.uData;
   } else {
   print('Error, Could not load Data.');
   throw Exception('Failed to load Data');
   }
 } catch (e) {
  print(e);
  }
    return '加载完毕';
  }
}

