import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_3/model/PurOrderData.dart';
import 'package:flutter_app_3/model/PurOrderModel.dart';
import '/widgets/components/searchBar/SearchAppBarWidget.dart';
import '/widgets/components/dataTable/MyTable.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode? _focusNode;
  TextEditingController? _controller;
  String? _searchText;
  late PurOrderModel model;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  static TextStyle  Titlesty = TextStyle(color: Colors.red,fontSize: 18);
  static TextStyle  bodyesty = TextStyle();
/*
  List<DataColumn> lcol= [
    new  DataColumn(label: Text('商品名',style: Titlesty,)),
    new  DataColumn(label: Text('条码',style: Titlesty,)),
    new  DataColumn(label: Text('价格',style: Titlesty,)),
    new  DataColumn(label: Text('数量',style: Titlesty,)),
  ];

  List<DataRow> lrow= [
    new  DataRow(cells:[new DataCell(Text('香蕉')),
      DataCell(Text('10123')),DataCell(Text('12.8')),DataCell(Text('2'))
    ] ),
    new  DataRow(cells:[new DataCell(Text('苹果')),
      DataCell(Text('00123')),DataCell(Text('12.8')),DataCell(Text('2'))
    ] ),
    DataRow(cells:[new DataCell(Text('笔记本电脑',overflow: TextOverflow.ellipsis,)),
      DataCell(Container(
        child: Text('291267209960000005',overflow: TextOverflow.clip,softWrap: true,),),),
      DataCell(Text('1234567.8')),DataCell(Text('1'),onTap: (){

      })
    ] ),

  ];*/

//--------------------PaginatedDataTable------------------------------

  //默认的行数
  int _defalutRowPageCount = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending=true;
  MyTable table = MyTable();

  //排序关联_sortColumnIndex,_sortAscending
  void _sort<T>(Comparable<T> getField(Shop s),int index,bool b){

    table.sort(getField, b);
    setState(() {
      this._sortColumnIndex=index;
      this._sortAscending=b;
    });
  }

  List<DataColumn> getColumn() {
    return [
      DataColumn(label: Text('货号'),onSort: (i,b){_sort<String>((Shop p) =>p.name, i, b);}),
      DataColumn(label: Text('品名'),onSort: (i,b){_sort<num>((Shop p) =>p.price, i, b);}),
      DataColumn(label: Text('合格状态'),onSort: (i,b){_sort<num>((Shop p) =>p.number, i, b);}),
      DataColumn(label: Text('QC报告'),onSort: (i,b){_sort<String>((Shop p) =>p.type, i, b);}),
    ];
  }


  Widget getPaginatedDataTable(){
    return SingleChildScrollView(
      child: PaginatedDataTable(
        rowsPerPage: _defalutRowPageCount,
        onRowsPerPageChanged: (value) {
          setState(() {
            _defalutRowPageCount = value!;
          });
        },
        sortColumnIndex: _sortColumnIndex,
        initialFirstRowIndex: 0,
        sortAscending: _sortAscending,
        availableRowsPerPage: [
          5,10
        ],
        onPageChanged: (value){
          print('$value');
        },
        onSelectAll: table.selectAll,
        header: Text('PO单号：${_controller?.text}'),
        columns: getColumn(),
        source: table,
      ),
    );
  }

  var _purorderdataModel = <PurOrderData>[];

  getPurOrder() async{
    try{
      // Response response = await Dio().get("http://192.168.225.116:8081/goshop/findUser");
      Response response = await Dio().post("http://183.63.128.202:9080/findPurOrder", data: {"poNo":_controller?.text});
      /*if (response.data is Map) {
        print(response.data);
      }
      else
      {
        print("后台连接错误");
      }*/
      assert(response != null);
      model = PurOrderModel.fromJson(response.data);
      if(model!= null && model.code == 200) {
       // model.uData[0].userName,
        _purorderdataModel = model.uData;
       return _purorderdataModel;

      }else
        {
          print('Error, Could not load Data.');
          throw Exception('Failed to load Data');
        }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new SearchAppBarWidget(
          focusNode: _focusNode,
          controller: _controller,
          elevation: 2.0,
       leading: IconButton(
         icon: Icon(Icons.arrow_back),
         onPressed: () {
           Navigator.pop(context);
         },
       ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(150),
          ],
          onEditingComplete: () {
           // print('搜索框输入的内容是： ${_controller?.text}');
            getPurOrder();
            setState(() {
              _searchText = _controller?.text;
            });

            _focusNode?.unfocus();
          },
        ),


        body: /*Center(
          child: Text("搜索内容: $_searchText"),
        )*/
        Column(
          children: <Widget>[
            /*DataTable(columns: lcol, rows: lrow,
              sortColumnIndex: 1,
            ),*/
            Expanded(
              child: getPaginatedDataTable(),
            )
          ],
        )
    );
  }
}