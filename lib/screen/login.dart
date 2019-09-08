import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/ScreenHelper.dart';
import './home.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  bool _validate_email = false;
  bool _validate_password = false;
  String back_image = "assets/bg.png";
  String token = "";

  void initState() {
    super.initState();
  }

  void showLoading(context, b) async {
    if (b)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading"),
              ],
            ),
          );
        },
      );
    else
      Navigator.pop(context);
  }

  Future<void> showAlert(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future fetchPost(String url, Map<String, String> params) async {
    final response = await http.post(url, body: params);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      //throw Exception('Failed to load post');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;

    return Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image(
                image: AssetImage(back_image),
                fit: BoxFit.cover,
              ),

              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: hp(93),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: hp(2),
                          ),
                          IconButton(
                            padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                            icon: Icon(Icons.arrow_back),
                            color: Colors.deepOrange,
                            iconSize: 30,
                            alignment: Alignment.bottomLeft,

                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    height: hp(2.5),
                                  ),
                                  Text("Login", style: TextStyle(color: Colors.deepOrange, fontSize: 33),),
                                  SizedBox(
                                    height: hp(2.5),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Aplikasi ", style: TextStyle(fontSize: 33, color: Colors.white),),
                                      Text("Edu", style: TextStyle(fontSize: 33, color: Colors.greenAccent),),
                                      Text("Prog ", style: TextStyle(fontSize: 33, color: Colors.blue),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: (_validate_email || _validate_password) ? hp(1) : hp(2.5),
                                  ),
                                  Form(
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Email",
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                              enabledBorder: const UnderlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                              ),
                                              errorText: _validate_email ? 'Value Can\'t Be Empty' : null
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                          controller: txtEmail,
                                        ),
                                        SizedBox(
                                          height: _validate_email ? 0 : hp(5),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              hintText: "Password",
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                              enabledBorder: const UnderlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                              ),
                                              errorText: _validate_password ? 'Value Can\'t Be Empty' : null
                                          ),
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                          controller: txtPassword,
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _validate_password? 0 : hp(2.7),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                          child: Text("Lupa password?", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                                          onTap: () {
                                            print("Lupa password");
                                          }
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: hp(5),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      if (txtEmail.text.length <= 0 || txtPassword.text.length <= 0){
                                        setState(() {
                                          if (txtEmail.text.length <= 0){
                                            _validate_email = true;
                                          }
                                          if (txtPassword.text.length <= 0){
                                            _validate_password = true;
                                          }
                                        });
                                      }else {
                                        String url = "http://192.168.0.102/eduprog/eduprog_flutter_login_php_backend/service.php";
                                        showLoading(context, true);
                                        fetchPost(url, {
                                          "cmd":"login",
                                          "u": txtEmail.text,
                                          "p": txtPassword.text
                                        }).then((onValue){
                                          showLoading(context, false);
                                          var jObject = json.decode(onValue);
                                          if (jObject != null){
                                            int v_code = jObject["code"];
                                            String v_desc = jObject["desc"];
                                            String v_cmd = jObject["cmd"];

                                            if (v_code == 1){ //. success
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HomePage(),
                                                ),
                                              );
                                            }else{
                                              showAlert(context, v_desc);
                                            }
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      //width: 100.0,
                                      height: hp(10),
                                      decoration: new BoxDecoration(
                                        color: Colors.deepOrange,
                                        border: Border.all(color: Colors.deepOrange, width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Center(child: Text('Login', style: new TextStyle(fontSize: 18.0, color: Colors.white, fontWeight:FontWeight.bold),),),
                                    ),
                                  ),
                                  SizedBox(
                                    height: hp(3.3),

                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: ShapeDecoration(shape: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.5) )),

                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text("OR", style: TextStyle(color: Colors.grey, fontSize: 16),),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: ShapeDecoration(shape: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.5) )),

                                          )
                                      )


                                    ],
                                  ),
                                  SizedBox(
                                      height: hp(3.3)
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: InkWell(
                                            onTap: () {
                                              print("Untuk login via google (misalnya)");
                                            },
                                            child: new Container(
                                              //width: 100.0,
                                              height: hp(8),
                                              decoration: BoxDecoration(
                                                color: Colors.red[800],
                                                border: Border.all(color: Colors.red[800], width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: Center(child: Text('G', style: TextStyle(fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold),),),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: InkWell(
                                            onTap: () async {
                                              print("Untuk login via facebook (misalnya)");
                                            },
                                            child: Container(
                                              //width: 100.0,
                                              height: hp(8),
                                              decoration: new BoxDecoration(
                                                color: Colors.lightBlue[900],
                                                border: Border.all(color: Colors.lightBlue[900], width: 2.0),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: Center(child: Text('f', style: TextStyle(fontSize: 35.0, color: Colors.white, fontWeight: FontWeight.bold),),),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: hp(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Belum punya akun? ", style: TextStyle(color: Colors.grey, fontSize: 16),),
                          GestureDetector(
                              child: Text("Daftar", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                              onTap: () {
                              }
                          )

                        ],
                      ),
                    )

                  ],
                ),
              )

            ]
        )
    );
  }
}