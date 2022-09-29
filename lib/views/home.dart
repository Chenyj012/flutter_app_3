import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_3/common/QcReport.dart';
import 'package:flutter_app_3/model/PurOrderData.dart';
import 'package:flutter_app_3/model/PurOrderModel.dart';
import 'package:flutter_app_3/widgets/components/images_picker/dongtai_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/components/images_picker/viewImages.dart';
import '/widgets/components/searchBar/SearchAppBarWidget.dart';
import '/widgets/components/dialog/showDialog.dart';
import '/widgets/components/fileLoad/ImageUpload.dart';
var _purorderdataModel = <PurOrderData>[];
String supplierName = "";
String poNumber = "";
late PurOrderModel model;
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode? _focusNode;
  TextEditingController? _controller;
  String? _searchText;

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

  static TextStyle Titlesty = TextStyle(color: Colors.red, fontSize: 18);
  static TextStyle bodyesty = TextStyle();

//--------------------PaginatedDataTable------------------------------

  //默认的行数
  int _defalutRowPageCount = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  getPurOrder(BuildContext context) async {
    try {
      Response response = await Dio().post(
          "http://183.63.128.202:9080/findPurOrder",
          data: {"poNo": _controller?.text});
      assert(response != null);
      model = PurOrderModel.fromJson(response.data);
      if (model != null && model.code == '200') {
        setState(() {
          _purorderdataModel = model.uData;
          supplierName = model.uData[0].supName;
          poNumber = model.uData[0].poNo;
          /*MyTable table = MyTable(this.context);
          table.purorderdataModel = model.uData;*/
        });
      } else {
        print('Error, Could not load Data.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  }


  Widget getPaginatedDataTable(BuildContext context, MyTable table) {
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
        columnSpacing: 10.0,
        sortAscending: _sortAscending,
        availableRowsPerPage: const [5, 10],
        onPageChanged: (value) {
          print('$value');
        },
        onSelectAll: table.selectAll,
        //header: Text('PO单号：${_controller?.text}'),
        header: Column(
            children: <Widget>[Text('PO单号：${poNumber}'),
            Text('供应商：${supplierName}')]),
        columns: table.getColumn(),
        source: table,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBarWidget(
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
            if(_controller?.text.isEmpty == true)
              {
                showToast("请先键入PO单号查询！");
                //_focusNode?.
              }
            else {
              getPurOrder(context);
              setState(() {
                _searchText = _controller?.text;
              });

              _focusNode?.unfocus();
            }
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
              child: getPaginatedDataTable(context, MyTable(context)),
            )
          ],
        ));
  }
}

class MyTable extends DataTableSource {

  MyTable(this.context) {
    _purOrderData = _purorderdataModel;
  }
  final BuildContext context;
  List<PurOrderData> _purOrderData = <PurOrderData>[];
  int _selectCount = 0; //当前选中的行数
  int qty = 0;
  bool _isRowCountApproximate = false; //行数确定

  updateQaStatus(/*BuildContext context,*/String poNo,String itemSn,bool pass) async {
    try {
      Response response = await Dio().post(
          "http://183.63.128.202:9080/updateQaStatus",
          data: {"pono": poNo,
            "itemsn" :itemSn,
            "qastatus" : pass

          });
      assert(response != null);
      Map<String, dynamic> map = Map<String, dynamic>();
      if(response != null) {
        map = json.decode(response.toString());

      }
      //Map<String, dynamic> map = PurOrderData.fromJson(response.data);
      if (map != null && map['code'] == '200') {
       showToast("恭喜，数据保存成功！");
      } else {
        print('Error, Could not load Data.');
        showToast("抱歉，数据保存失败！");
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  DataRow getRow(int index) {
    if (index > _purOrderData.length || index < 0) {
      FlutterError('数据错误！');
    }
    final PurOrderData pod = _purOrderData[index];
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text(pod.itemSn)),
          DataCell(Text(pod.itemName)),
          //DataCell(Text('${pod.price}')),
          //数据加减功能
          DataCell(Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    pod.qaStatus = 1;
                    notifyListeners();
                  }),
              Text('${pod.qaStatus == 1 ? '是' : '否'}'),
              IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    pod.qaStatus = 0;
                    notifyListeners();
                  }),
    Container(
        width: 60,
        child:RaisedButton(
                  child: Text('保存'),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    print('保存');
                    showConfirmDialog(context, '确认要提交该数据吗？', () {
                      // print('点击了确定删除......');
                      // 执行确定操作后的逻辑
                      updateQaStatus(pod.poNo,pod.itemSn,pod.qaStatus.isOdd);
                    });
                  })),
            ],
          )),
          DataCell(Row(
    children: <Widget>[
     Container(
              width: 60,
              child:RaisedButton(
                  child: Text('上传'),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    print('上传');
// 保存PO等信息
                    void _savePurMsg() async{
                      SharedPreferences preferences=await SharedPreferences.getInstance();
                      preferences.setString("poNo", pod.poNo);
                      preferences.setString("itemSn", pod.itemSn);
                      preferences.setString("itemName", pod.itemName);
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => new DongtaiWidget(new QcReport(poNo:pod.poNo, itemSn:pod.itemSn,itemName:pod.itemName))));
                    /*Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>new DongtaiWidget(new QcReport(poNo:pod.poNo, itemSn:pod.itemSn,itemName:pod.itemName)*//*poNo:pod.poNo,itemSn:pod.itemSn,itemName:pod.itemName*//*) *//*new ImagePickerWidget()*//*),
                            (route) => route == null);*/
                  })),
      Container(
          width: 60,
          child:RaisedButton(
              child: Text('查看'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                print('查看');
                Navigator.push(context, MaterialPageRoute(builder: (context) => new CommodityPage(new QcReport(poNo:pod.poNo, itemSn:pod.itemSn,itemName:pod.itemName))));
              })),
        ],
    )),

          // DataCell(Text('${pod.uploadStatus}')),
        ],
        selected: pod.selected,
        onSelectChanged: (isselected) {
          selectOne(index, isselected!);
        });
  }

  //选中单个
  void selectOne(int index, bool isSelected) {
    PurOrderData purOrderData = _purOrderData[index];
    if (purOrderData.selected != isSelected) {
      //如果选中就选中数量加一，否则减一
      _selectCount = _selectCount += isSelected ? 1 : -1;
      purOrderData.selected = isSelected;
      //更新
      notifyListeners();
    }
  }

  //选中全部
  void selectAll(bool? checked) {
    for (PurOrderData _shop in _purOrderData) {
      _shop.selected = checked!;
    }
    _selectCount = checked! ? _purOrderData.length : 0;
    notifyListeners(); //通知监听器去刷新
  }

  //排序,
  void _sort<T>(Comparable<T> getField(PurOrderData s), int index, bool b) {
    _purOrderData.sort((PurOrderData s1, PurOrderData s2) {
      if (!b) {
        //两个项进行交换
        final PurOrderData temp = s1;
        s1 = s2;
        s2 = temp;
      }
      final Comparable<T> s1Value = getField(s1);
      final Comparable<T> s2Value = getField(s2);
      return Comparable.compare(s1Value, s2Value);
    });
    notifyListeners();
  }


  List<DataColumn> getColumn() {
    return [
      DataColumn(
          label: Text('货号'),
          onSort: (i, b) {
            _sort<String>((PurOrderData p) => p.itemSn, i, b);
          }),
      DataColumn(
          label: Text('品名'),
          onSort: (i, b) {
            _sort<String>((PurOrderData p) => p.itemName, i, b);
          }),
      DataColumn(
          label: Text('合格状态'),
          onSort: (i, b) {
            _sort<num>((PurOrderData p) => p.qaStatus, i, b);
          }),
      DataColumn(
          label: Text('QC报告'),
          onSort: (i, b) {
            _sort<num>((PurOrderData p) => p.uploadStatus, i, b);
          }),
    ];
  }

  @override
  int get rowCount => _purOrderData.length;
  @override
  bool get isRowCountApproximate => _isRowCountApproximate;

  @override
  int get selectedRowCount => _selectCount;
}
