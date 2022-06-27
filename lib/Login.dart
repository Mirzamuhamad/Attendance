import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Attendance/FadeAnimation/FadeAnimation.dart';
import 'package:Attendance/ip.dart';
import 'package:Attendance/main.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_information/device_information.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

// ignore: must_be_immutable
class _LoginState extends State<Login> {
  String empNo = "";
  @override
  void initState() {
    //untuk menjalankan class tanpa triger
    super.initState();
    _initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 20,
                          width: 100,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          ),
                        ),
                        Positioned(
                          right: 70,
                          top: 10,
                          width: 200,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          width: 80,
                          height: 120,
                          child: FadeAnimation(
                              1.3,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-2.png'))),
                              )),
                        ),
                        Positioned(
                            top: 100,
                            left: 100,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, right: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.8,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Employee number harus di isi';
                                        }
                                        return null;
                                      },
                                      controller: controllerEmPNumber,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Employee Number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                  // TextField Password
                                  // Container(
                                  //   padding: EdgeInsets.all(8.0),
                                  //   child: TextField(
                                  //     controller: controllerPassword,
                                  //     obscureText: true,

                                  //     decoration: InputDecoration(

                                  //         // prefixIcon: Icon(
                                  //         //   Icons.lock_outline_rounded,
                                  //         //   size: 20,
                                  //         //   color: Colors.black,
                                  //         // ),

                                  //         border: InputBorder.none,
                                  //         hintText: "Password",
                                  //         hintStyle: TextStyle(
                                  //             color: Colors.grey[400])),
                                  //   ),
                                  // )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 90,
                        ),
                        FadeAnimation(
                          2,
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: SizedBox(
                              height: 55,
                              width: double.infinity,
                              child: FlatButton(
                                // color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () async {
                                  _showLoaderDialog(context);
                                  // saveDataLogin();
                                  getSharepref();
                                  // getDeviceInfo();
                                  getLogin();

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => HomePage()),
                                  // );
                                },

                                child: Text(
                                  "Login",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // RaisedButton(
                        //   child: Text("Remove"),
                        //   onPressed: () {
                        //     getempNo().then((s) {
                        //       controllerEmPNumber.text = s;
                        //       setState(() {});
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      // backgroundColor: Color.fromRGBO(111, 0, 0, 0),
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child: CircularProgressIndicator()),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//funtion
  TextEditingController controllerEmPNumber = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();

  String uniqueId = "Unknown";
  // ignore: missing_return
  Future<List> getLogin() async {
    // ignore: unused_local_variable
    String platformImei;
    // ignore: unused_local_variable
    String idunique;
    try {
      //untuk get multi imei jika nomor imei lebih dari
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    //fungsi untuk login
    // ignore: unused_local_variable
    String _platformVersion, imeiNo = "null";
    try {
      imeiNo = await DeviceInformation.deviceIMEINumber;
    } on PlatformException {
      _platformVersion = "null" ?? "oke nih"; //'${e.message}';
    } //untuk mengambil imei pada handphone

    final getEmployee = await http.post("http://$ip/getEmployee.php", body: {
      "Emp_Number": controllerEmPNumber.text,
    });

    // print(getEmployee.body);
    var cekimei = json.decode(getEmployee.body);
    if (cekimei.length == 0) {
      print("tidak ada data");
    } else {
      if (cekimei[0]['Imei'] == "" || cekimei[0]['Imei'] == null) {
        var url = Uri.parse("http://$ip/UpdateEmployee.php");
        var request = http.MultipartRequest("POST", url);
        request.fields['Emp_Number'] = controllerEmPNumber.text;
        request.fields['Imei'] = imeiNo;
        await request.send(); // untuk send data to database
      } else {
        print("Imei sudah Terisi");
      }
    }

    if (imeiNo != "null") {
      print(
          imeiNo); //Jika imei sedah terisi maka akan menjalankan perintah di bawah

      if (controllerEmPNumber.text == "" && controllerPassword.text == "") {
        // jika form masih kosong
        Navigator.pop(context);
        _onBasicAlertFormkosong(context);
        print("Login gagal");
      } else {
        // jika form sudah di isi maka cek ke database apakah data emp number yang di masukan sudah benar atau belum dan apakah imei sudah ada atau belum
        final response =
            await http.post("http://$ip/getCekEmployee.php", body: {
          "Emp_Number": controllerEmPNumber.text,
          "Imei": '$imeiNo',
        });

        print(response.body);
        var dataEmployee = json.decode(response.body);
        //pengecekan apkah data dari emp number dan imei dari msEmpployee ada atu tidak
        if (dataEmployee.length == 0) {
          Navigator.pop(context);
          setState(() {
            _onBasicAlertPressed(context); // massage jika data tidak ketemu
          });
          SharedPreferences prefData = await SharedPreferences.getInstance();
          prefData.remove('empNo');
          print("login gagal blogggg!!!!");
        } else {
          // jika data ketemu makan akan menjakankan perintah di bawah
          SharedPreferences prefData = await SharedPreferences.getInstance();
          prefData.setString("empNo",
              controllerEmPNumber.text); //simpan data ke share preference
          prefData.setString("empName", dataEmployee[0]['Emp_Name']);
          String empNumberPref = '';
          empNumberPref =
              prefData.getString('empNo'); // get data from sharepreference
          print(empNumberPref);

          Navigator.pushReplacementNamed(context, '/home_page');
          setState(() {
            empNumber = '$empNumberPref';
            empName = dataEmployee[0]['Emp_Name'];
            //dataEmployee[0]['Emp_Number'];
            print(empName);
          });

          return dataEmployee;
        }
      }
    } else {
      //jika permision hp belum di munculkan tampilkan permision
      print("gagal blogggggg !!!!!");
      await Permission.phone.request();
    }
  }

  // _onTimeout() => print("Time Out occurs");

  void _initState() async {
    // try {
    //   var response = await http
    //       .head("http://$ip/conn.php")
    //       .timeout(const Duration(seconds: 10), onTimeout: () => _onTimeout());
    // } on TimeoutException catch (_) {
    //   print("The connection has timed out, Please try again!");
    // } on SocketException catch (e) {
    //   print(e);
    //   print("ga connect");
    // }

    SharedPreferences prefData = await SharedPreferences.getInstance();
    print(prefData.getString('empNo'));
    if (prefData.getString('empNo') != null) {
      // Jika data di share preference sudah ada maka langsung masuk ke home page dan get data dari server untuk identifikasi siapa yang login
      final getDataEMP = await http.post("http://$ip/getEmployee.php", body: {
        "Emp_Number": prefData.getString("empNo"),
      });

      print(getDataEMP.body);

      var dataEmployee = json.decode(getDataEMP.body);
      // var dataEmployee = await json.decode(json.encode(getDataEMP.body));
      if (dataEmployee.length == 0) {
        setState(() {});
      } else {
        setState(() {
          Navigator.pushReplacementNamed(context, '/home_page');
          empNumber = dataEmployee[0]['Emp_Number'];
          empName = dataEmployee[0]['Emp_Name'];
          setState(() {});
        });
        // } else {
        //
        //  Navigator.pushReplacementNamed(context, '/Login');
      }
    }
    prefData.getString('empNo');
  }

  //UNTUK GET DEVICE INFO
  Future<String> getDeviceInfo() async {
    // ignore: unused_local_variable
    String _platformVersion, imeiNo = "null";
    try {
      imeiNo = await DeviceInformation.deviceIMEINumber;
    } on PlatformException {
      _platformVersion = "null" ?? "oke nih"; //'${e.message}';
    }

    if (imeiNo != "null") {
      print(imeiNo);
    } else {
      print("gagal blogggggg !!!!!");

      return exit(hashCode);
    }

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String model;
    String id;
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      id = androidInfo.androidId;
    }
    print(id + model);
    return model;
  }

  void getSharepref() async {
    //simpan data emp number ke local hanphone
    SharedPreferences prefData = await SharedPreferences.getInstance();
    prefData.setString("empNo", controllerEmPNumber.text);
  }

  Future<String> getempNo() async {
    //get data emp number dari local hp
    SharedPreferences prefData = await SharedPreferences.getInstance();
    return prefData.getString("empNo") ??
        "data gada"; //jika empno nya null maka munculkan data gada
  }
}

_onBasicAlertPressed(context) {
  // Alert(
  // image: Image.asset("assets/image/clock.png"),

  Alert(
    context: context,
    title: "",
    image: Image.asset("assets/images/clock.png"),
    content: Column(
      children: <Widget>[
        Text(
          "Employee ID is not valid !",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange[300]),
        ),
        // Text(
        //   "not valid !",
        //   style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.deepOrange[300]),
        // )
      ],
    ),
    buttons: [
      DialogButton(
        child: Text(
          "Back",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(143, 120, 225, .7),
          Color.fromRGBO(143, 148, 251, 1),
        ]),
        radius: BorderRadius.circular(10),
      ),
    ],
    alertAnimation: fadeAlertAnimation,
  ).show();
}

_onBasicAlertFormkosong(context) {
  // Alert(
  // image: Image.asset("assets/image/clock.png"),

  Alert(
    context: context,
    title: "",
    closeIcon: Icon(
      Icons.exit_to_app,
      color: Colors.black54,
    ),
    content: Column(
      children: <Widget>[
        // Icon(Icons.close),
        Text(
          "Employee ID must have value !!",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange[300]),
        ),
        // Text(
        //   "must have value !!",
        //   style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.deepOrange[300]),
        // )
      ],
    ),
    buttons: [
      DialogButton(
        child: Text(
          "Back",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(143, 120, 225, .7),
          Color.fromRGBO(143, 148, 251, 1),
        ]),
        radius: BorderRadius.circular(10),
      ),
    ],
    alertAnimation: fadeAlertAnimation,
  ).show();
}

Widget fadeAlertAnimation(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
