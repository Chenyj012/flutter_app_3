import 'package:flutter/material.dart';
import 'package:flutter_app_3/model/PurOrderData.dart';

class MyTable extends DataTableSource
{

  /*List<Shop> _shops = <Shop>[
    Shop('小米6x', 100, '手机', 1699.0),
    Shop('华为P20', 50, '手机', 4999.0),
    Shop('华硕a61', 50, '电脑', 5700.0),
    Shop('iphone7plus耳机', 9999, '耳机', 60.0),
    Shop('iphone7plus256g', 1, '手机', 4760.0),
    Shop('金士顿8g内存条', 66, '内存条', 399.0),
    Shop('西门子洗衣机9.0kg', 890, '家电', 10399.0),
    Shop('三星66寸液晶智能电视', 800, '家电', 20389.0),
  ];*/
  /*MyTable(BuildContext context,List<PurOrderData> initialList){
    _purOrderData = initialList;
  }*/
  MyTable(this.context) {
    _purOrderData = _purorderdataModel;
  }
 final BuildContext context;
  List<PurOrderData> _purOrderData  =<PurOrderData>[];
  List<PurOrderData> _purorderdataModel  =<PurOrderData>[];

  List<PurOrderData> get purorderdataModel => _purorderdataModel;

  set purorderdataModel(List<PurOrderData> value) {
    _purorderdataModel = value;
  }

  set purOrderData(List<PurOrderData> value) {
    _purOrderData = value;
  }

  int _selectCount = 0; //当前选中的行数
  int qty=0;
  bool _isRowCountApproximate = false;//行数确定
  @override
  DataRow getRow(int index)
  {
    if (index>_purOrderData.length|| index<0){FlutterError('数据错误！');}
    final PurOrderData pod = _purOrderData[index];
    return DataRow.byIndex( index:index,cells: <DataCell>[
      DataCell(Text(pod.itemSn)),
      DataCell(Text(pod.itemName)),
      //DataCell(Text('${pod.price}')),
      //数据加减功能
      DataCell(Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_left), onPressed: (){
            pod.qaStatus+=1;
            notifyListeners();
          }),
          Text('${pod.qaStatus}'),
          IconButton(icon: Icon(Icons.arrow_right), onPressed: (){
            pod.qaStatus+=1;
            notifyListeners();
          }),
        ],
      )),
      DataCell(Text('${pod.uploadStatus}')),
    ],
        selected: pod.selected,
        onSelectChanged: (isselected){
          selectOne(index,isselected!);
        }
    );
  }

  //选中单个
  void selectOne(int index,bool isSelected){
    PurOrderData purOrderData=_purOrderData[index];
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
  void _sort<T>(Comparable<T> getField(PurOrderData s),int index,bool b){
    _purOrderData.sort((PurOrderData s1,PurOrderData s2){
      if(!b){//两个项进行交换
        final PurOrderData temp=s1;
        s1=s2;
        s2=temp;
      }
      final Comparable<T> s1Value=getField(s1);
      final Comparable<T> s2Value=getField(s2);
      return Comparable.compare(s1Value, s2Value);
    });
    notifyListeners();
  }

  //排序关联_sortColumnIndex,_sortAscending
 /* void _sort<T>(Comparable<T> getField(PurOrderData s), int index, bool b) {
    table.sort(getField, b);
    setState(() {
      this._sortColumnIndex = index;
      this._sortAscending = b;
    });
  }*/
  /* List<DataColumn> getColumn() {
    return [
      DataColumn(label: Text('货号'), onSort: (i, b) {
        _sort<String>((PurOrderData p) => p.itemSn, i, b);
      }),
      DataColumn(label: Text('品名'), onSort: (i, b) {
        _sort<String>((PurOrderData p) => p.itemName, i, b);
      }),
      DataColumn(label: Text('合格状态'), onSort: (i, b) {
        _sort<num>((PurOrderData p) => p.qaStatus, i, b);
      }),
      DataColumn(label: Text('QC报告'), onSort: (i, b) {
        _sort<num>((PurOrderData p) => p.uploadStatus, i, b);
      }),
    ];
  }*/
  List<DataColumn> getColumn() {
    return [
      DataColumn(label: Text('货号'), onSort: (i, b) {
        _sort<String>((PurOrderData p) => p.itemSn, i, b);
      }),
      DataColumn(label: Text('品名'), onSort: (i, b) {
        _sort<String>((PurOrderData p) => p.itemName, i, b);
      }),
      DataColumn(label: Text('合格状态'), onSort: (i, b) {
        _sort<num>((PurOrderData p) => p.qaStatus, i, b);
      }),
      DataColumn(label: Text('QC报告'), onSort: (i, b) {
        _sort<num>((PurOrderData p) => p.uploadStatus, i, b);
      }),
    ];
  }

  @override
  int get rowCount=>_purOrderData.length ;
  @override
  bool get isRowCountApproximate=>_isRowCountApproximate;

  @override
  int get selectedRowCount=>_selectCount;

  List<PurOrderData> get purOrderData => _purOrderData;

}

/*
class Shop{
  final String name;
  int number;
  final String type;
  final double price;
  bool selected=false;//默认为未选中
  Shop(this.name, this.number, this.type, this.price,);
}*/
