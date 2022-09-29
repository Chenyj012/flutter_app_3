import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_3/model/PurOrderData.dart';
import 'package:flutter_app_3/model/PurOrderModel.dart';
import 'package:flutter_app_3/widgets/components/dataTable/MyTable.dart';
import '/widgets/components/searchBar/SearchAppBarWidget.dart';

TextEditingController? _controller;
var _purorderdataModel = <PurOrderData>[];
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode? _focusNode;
 // TextEditingController? _controller;
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

  getPurOrder() async{
    try{
      // Response response = await Dio().get("http://192.168.225.116:8081/goshop/findUser");
      Response response = await Dio().post("http://183.63.128.202:9080/findPurOrder", data: {"poNo":_controller?.text});
      assert(response != null);
      model = PurOrderModel.fromJson(response.data);
      if(model!= null && model.code == '200') {
        // model.uData[0].userName,
        setState(() {
          _purorderdataModel = model.uData;
        });
        //return _purorderdataModel;

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
             // child: getPaginatedDataTable(),
                child: PurOrderTable()
            )
          ],
        )
    );
  }
}
/*--------------------PaginatedDataTable------------------------------*/

//默认的行数
int _defalutRowPageCount = PaginatedDataTable.defaultRowsPerPage;
int? _sortColumnIndex;
bool _sortAscending=true;
MyTable table = MyTable();

//排序关联_sortColumnIndex,_sortAscending
void _sort<T>(Comparable<T> getField(PurOrderData s),int index,bool b){

  table.sort(getField, b);
  setState(() {
    this._sortColumnIndex=index;
    this._sortAscending=b;
  });
}
class PurOrderTable extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: Text('Data Tables'),
      ),*/
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('PO单号：${_controller?.text}'),
            rowsPerPage: 4,
            columns: [
              DataColumn(label: Text('货号')),
              DataColumn(label: Text('品名')),
              DataColumn(label: Text('是否合格')),
              DataColumn(label: Text('QC报告')),
            ],
            source: _DataSource(context),
          ),
        ],
      ),
    );
  }
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


/*class _Row {
  _Row(
      this.valueA,
      this.valueB,
      this.valueC,
      this.valueD,
      );

  final String valueA;
  final String valueB;
  final String valueC;
  final int valueD;

  bool selected = false;
}*/

class _DataSource extends DataTableSource {
  /*_DataSource(this.context) {
    _rows = <PurOrderData>[
      _Row('Cell A1', 'CellB1', 'CellC1', 1),
      _Row('Cell A2', 'CellB2', 'CellC2', 2),
      _Row('Cell A3', 'CellB3', 'CellC3', 3),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
    ];
  }*/
 _DataSource(this.context) {
   _rows = _purorderdataModel;
 }
  final BuildContext context;
  List<PurOrderData> _rows = <PurOrderData>[];

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
       /* if (row.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value!;
          notifyListeners();
        }*/

      },
      cells: [
        DataCell(Text(row.itemSn)),
        DataCell(Text(row.itemName)),
        DataCell(Text(row.qaStatus.toString())),
        DataCell(Text(row.uploadStatus.toString())),
      ],
    );
  }
//选中单个
  void selectOne(int index,bool isSelected){
    PurOrderData poData=_rows[index];
    if (poData.selected != isSelected) {
      //如果选中就选中数量加一，否则减一
      _selectedCount = _selectedCount += isSelected ? 1 : -1;
      poData.selected = isSelected;
      //更新
      notifyListeners();
    }
  }
  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

