import 'package:flutter/material.dart';

class MyTable extends DataTableSource
{

  List<Shop> _shops = <Shop>[
    Shop('小米6x', 100, '手机', 1699.0),
    Shop('华为P20', 50, '手机', 4999.0),
    Shop('华硕a61', 50, '电脑', 5700.0),
    Shop('iphone7plus耳机', 9999, '耳机', 60.0),
    Shop('iphone7plus256g', 1, '手机', 4760.0),
    Shop('金士顿8g内存条', 66, '内存条', 399.0),
    Shop('西门子洗衣机9.0kg', 890, '家电', 10399.0),
    Shop('三星66寸液晶智能电视', 800, '家电', 20389.0),
  ];
  int _selectCount = 0; //当前选中的行数
  int qty=0;
  bool _isRowCountApproximate = false;//行数确定
  @override
  DataRow getRow(int index)
  {
    if (index>_shops.length|| index<0){FlutterError('数据错误！');}
    final Shop shop = _shops[index];
    return DataRow.byIndex( index:index,cells: <DataCell>[
      DataCell(Text(shop.name)),
      DataCell(Text('${shop.price}')),
      //数据加减功能
      DataCell(Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_left), onPressed: (){
            shop.number+=1;
            notifyListeners();
          }),
          Text('${shop.number}'),
          IconButton(icon: Icon(Icons.arrow_right), onPressed: (){
            shop.number+=1;
            notifyListeners();
          }),
        ],
      )),
      DataCell(Text(shop.type)),
    ],
        selected: shop.selected,
        onSelectChanged: (isselected){
          selectOne(index,isselected!);
        }
    );
  }

  //选中单个
  void selectOne(int index,bool isSelected){
    Shop shop=_shops[index];
    if (shop.selected != isSelected) {
      //如果选中就选中数量加一，否则减一
      _selectCount = _selectCount += isSelected ? 1 : -1;
      shop.selected = isSelected;
      //更新
      notifyListeners();
    }
  }
  //选中全部
  void selectAll(bool? checked) {
    for (Shop _shop in _shops) {
      _shop.selected = checked!;
    }
    _selectCount = checked! ? _shops.length : 0;
    notifyListeners(); //通知监听器去刷新
  }

  //排序,
  void sort<T>(Comparable<T> getField(Shop shop),bool b){
    _shops.sort((Shop s1,Shop s2){
      if(!b){//两个项进行交换
        final Shop temp=s1;
        s1=s2;
        s2=temp;
      }
      final Comparable<T> s1Value=getField(s1);
      final Comparable<T> s2Value=getField(s2);
      return Comparable.compare(s1Value, s2Value);
    });
    notifyListeners();
  }

  @override
  int get rowCount=>_shops.length ;
  @override
  bool get isRowCountApproximate=>_isRowCountApproximate;

  @override
  int get selectedRowCount=>_selectCount;



}

class Shop{
  final String name;
  int number;
  final String type;
  final double price;
  bool selected=false;//默认为未选中
  Shop(this.name, this.number, this.type, this.price,);
}