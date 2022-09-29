import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/components/searchBar/SearchAppBarWidget.dart';

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
            print('搜索框输入的内容是： ${_controller?.text}');
            setState(() {
              _searchText = _controller?.text;
            });

            _focusNode?.unfocus();
          },
        ),


        body: Center(
          child: Text("搜索内容: $_searchText"),
        )
    );
  }
}