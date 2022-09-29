import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_3/LoginUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/components/Tab/tabs.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(new LoginAlertDemoApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前       MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:    Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class LoginAlertDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return new MaterialApp(
    //     theme: new ThemeData(
    //       primarySwatch: Colors.green,
    //     ),
    //     home: Scaffold(
    //       body: new LoginHomePage(),
    //     ));

    return new MaterialApp(
         theme: new ThemeData(
           primarySwatch: Colors.green,
        ),
        home: new Scaffold(
            body: new LoginHomePage(),
        appBar: new AppBar(
        actions: [
        IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
    showDialog(
    context: context,
    builder: (context) {
    return AlertDialog(
    title: Text("提示"),
    content: Text("确认退出吗？"),
    actions: [
    FlatButton(child: Text("取消"),onPressed: (){
    Navigator.of(context).pop("cancel");
    }),
    FlatButton(child: Text("确认"),onPressed: (){
    SystemNavigator.pop();
    })
    ],
    );
    });
    })
    ],
    title: new Text("欢迎登陆XXX平台")
    )
    )
    );


  }
}

class LoginHomePage extends StatefulWidget {
  @override
  _LoginHomePageState createState() {
    // TODO: implement createState
    return new _LoginHomePageState();
  }
}

class _LoginHomePageState extends State<LoginHomePage> {
  List getList = [];
  List postList = [];
  String name="";
  String password="";
  String login="登录";
  late User model;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120.0,
              alignment:Alignment.centerLeft,
              padding: EdgeInsets.only(left:30.0),
              color: Colors.white,
              child: Icon(Icons.access_alarm),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left:30.0,right: 30.0),
              child: new Container(
                child: buildForm(),
              ),
            ),

          ],
        ),

      ],
    );
  }

  TextEditingController unameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  GlobalKey formKey = new GlobalKey<FormState>();
 /* void _login() {
    showDialog(
        context: context,
        builder: (context) {
          getHttp();
          if (unameController.text == "admin" && pwdController.text == "123456") {
            String sucess = "登录成功 \n" + unameController.text;
            return AlertDialog(
              content: Text(sucess),
            );
          } else {
            String err = "登录失败 \n 账号或密码错误";
            return AlertDialog(
              content: Text(err),
            );
          }
        });
  }*/

  /*_login() async {
    var response = await http.post("http://localhost:8080/user/login", body: {"userName": name, "password": password});
    Utf8Decoder decode = new Utf8Decoder();
    if (response.statusCode == 200) {
      Map map = json.decode(decode.convert(response.bodyBytes));
      print(map);
      String code = map['code'];
      if(code=="E19999"){
        setState(() {
          login=map['msg'];
        });
      }else{
        setState(() {
          login="登录成功";
        });
      }

    } else {
      setState(() {
        login = "网络错误";
      });
    }
  }*/


  // 保存账号密码
  void _saveLoginMsg() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("name", unameController.text);
    preferences.setString("pwd", pwdController.text);
  }
  // 读取账号密码，并将值直接赋给账号框和密码框
  void _getLoginMsg()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    unameController.text=preferences.getString("name")!;
    pwdController.text=preferences.getString("pwd")!;
  }
  @override
  void initState(){
    super.initState();
    _getLoginMsg();
  }
  void getHttp() async{
    try{
      // Response response = await Dio().get("http://192.168.225.116:8081/goshop/findUser");183.128.68.202:9080
      //Response response = await Dio().post("http://183.63.128.202:9080/findUser", data: {"userNo":unameController.text,"password":pwdController.text});
      Response response = await Dio().post("http://183.63.128.202:9080/findUser", data: {"userNo":unameController.text,"password":pwdController.text});
      if (response.data is Map) {
        print(response.data);
      }
      else
        {
          print("后台连接错误");
        }
      model = User.fromJson(response.data);
      if(model != null) {
        setState(() {
          login="登录成功";
          Fluttertoast.showToast(
            msg: '欢迎你，'+model.uData[0].userName,
            fontSize: 14,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
          );
        });
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (context) => new Tabs()),
                (route) => route == null);
       // return true;@override
        //   Widget build(BuildContext context) {
        //     return MaterialApp(
        //         home:Tabs()
        //     );
      } else
            {
              setState(() {
                login="登录失败";
              });
            }
    }catch(e){
      print(e);
    }
  }

  Widget buildForm() {
    return Form(
      //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.always, key: formKey,
      child: Column(
        children: <Widget>[

           TextFormField(
              autofocus: false,
              //keyboardType: TextInputType.number,
              //键盘回车键的样式 IOS 只能识别数字
              textInputAction: TextInputAction.next,
              controller: unameController,
              decoration: const InputDecoration(
                  labelText: "用户名或手机号",
                  hintText: "用户名或手机号",
                  icon: Icon(Icons.person)),
              // 校验用户名
              validator: (v) {
              //  return v == null || v.isEmpty ? null : "用户名不能为空";
                if(v == null || v.isEmpty)
                {
                  return "用户名不能为空";
                }
                return null;
              }),
          TextFormField(
              autofocus: false,
              controller: pwdController,
              decoration: const InputDecoration(
                  labelText: "密码", hintText: "您的登录密码", icon: Icon(Icons.lock)),
              obscureText: true,
              //校验密码
              validator: (v) {
                if(v == null || v.isEmpty)
                  {
                    return "密码不能为空";
                  }
                else if(v.trim().length <5)
                  {
                    return "密码不能少于6位";
                  }
                return null;
               }),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(login),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      //在这里不能通过此方式获取FormState，context不对
                      //print(Form.of(context));
                      // 通过_formKey.currentState 获取FormState后，
                      // 调用validate()方法校验用户名密码是否合法，校验
                      // 通过后再提交数据。
                      if ((formKey.currentState as FormState).validate()) {
                        //验证通过提交数据
                        //_login();
                        getHttp();
                        _saveLoginMsg();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}

