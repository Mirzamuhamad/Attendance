// import 'dart:async';
// import 'package:slide_popup_dialog/slide_popup_dialog.dart' as sliderPopup;
// import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:Attendance/Popup/menu.dart';
import 'package:Attendance/profile.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart' as path;
// import 'package:async/async.dart';
import 'package:Attendance/warna/color.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Attendance/history.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'ip.dart';
import 'package:geolocator/geolocator.dart';
import 'main.dart';
import 'package:Attendance/Popup/gagal.dart';
import 'package:Attendance/Popup/berhasil.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({this.empNumber, this.empNumberLogin, this.empName});
  final String empNumber, empNumberLogin, empName;

  @override
  _HomePage createState() => new _HomePage();
}

// ignore: must_be_immutable
class _HomePage extends State<HomePage> {
  String _timeString;
  String fotoProfil = "";
  Timer _timer;
  double _progress;

  @override //untuk jam realtime berjalan
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    getData();

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.showSuccess('Use in initState');
    super.initState();
  }

  Future<List> getData() async {
    final response = await http
        .post("http://$ip/getEmployee.php", body: {"Emp_Number": '$empNumber'});

    print('$empNumber');
    var employee = json.decode(response.body);
    fotoProfil = employee[0]['fotoProfil'];
    print(fotoProfil);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);

    if (this.mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // untuk generate format tanggal dan waktu
    return DateFormat.jm().format(dateTime);
  }

  // final Function togScreen;
  var dateToday = new DateTime.now();
  var dataTime = new DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  var tanggal = new DateFormat('dd MMM yyyy').format(DateTime.now());
  var jam = new DateFormat('HH:mm').format(DateTime.now());
  var jamMasuk = new DateFormat('HH:mm:ss').format(DateTime.now());

  File uploadImage;
  Future getImage() async {
    var picImage = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );

    if (picImage != null) {
      setState(() {
        EasyLoading.showSuccess('Berhasil Pilih Foto');
        uploadImage = File(picImage.path);
        print(uploadImage);
      });
    } else {
      print("belom pilih image bloggggg !!!");
    }
  }

  void addData(BuildContext context) async {
    if (uploadImage != null) {
      print("bisa");

      //for geolocator
      final PermissionStatus locationPerms =
          await Permission.locationWhenInUse.status;
      if (locationPerms != PermissionStatus.granted) {
        await Permission.locationWhenInUse.request();
      } else {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Berhasil()));
        // _onBasicWaitingAlertPressed(context);

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double latitude = position.latitude.toDouble();
        double longitude = position.longitude.toDouble();
        print(position.latitude.toString() +
            ', ' +
            position.longitude.toString());

        final coordinates = new Coordinates(latitude, longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        // print("${first.featureName} : ${first.addressLine}");
        print(first.addressLine.toString());

        String koordinat =
            position.latitude.toString() + ', ' + position.longitude.toString();
        String alamat = first.addressLine.toString();

        try {
          //insert code ver 2
          var stream = http.ByteStream(uploadImage.openRead());
          var lenght = await uploadImage.length();
          var url = Uri.parse("http://$ip/ClockIn.php");
          var request = http.MultipartRequest("POST", url);
          var multipartFile = http.MultipartFile("image", stream, lenght,
              filename: path.basename(uploadImage.path));
          request.fields['Emp_Number'] = '$empNumber';
          request.fields['Remark'] = "Masuk";
          request.fields['Koordinat'] = koordinat;
          request.fields['Tempat_Absen'] = alamat;
          request.files.add(multipartFile);
          // await request.send(); // untuk send data to database
          //Untuk loading update data
          _progress = 0;
          _timer?.cancel();
          _timer =
              Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
            EasyLoading.showProgress(_progress,
                status:
                    'Verify ClockIn : ${(_progress * 100).toStringAsFixed(0)}%');
            _progress += 0.03;

            if (_progress >= 1) {
              _timer?.cancel();
              EasyLoading.dismiss();
            }
          });
          //--------------
          var response = await request.send();
          if (response.statusCode == 200) {
            EasyLoading.showSuccess('Yey ClockIn Kamu Berhasil');
            print("Clock In Berhasil");
            EasyLoading.dismiss();
          }
          // print(response);
          // response.stream.transform(utf8.decoder).listen((value) {});
        } catch (e) {
          debugPrint("Error $e");
        }
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Gagal()));
      print("pilih foto dulu njingggggg !!!!!");
    }
  }

  void addClockOut(BuildContext context) async {
    if (uploadImage != null) {
      print("bisa");

      //for geolocator
      final PermissionStatus locationPerms =
          await Permission.locationWhenInUse.status;
      if (locationPerms != PermissionStatus.granted) {
        await Permission.locationWhenInUse.request();
      } else {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Berhasil()));

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double latitude = position.latitude.toDouble();
        double longitude = position.longitude.toDouble();
        print(position.latitude.toString() +
            ', ' +
            position.longitude.toString());

        final coordinates = new Coordinates(latitude, longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        print("${first.featureName} : ${first.addressLine}");
        // print(first.addressLine.toString());

        String koordinat =
            position.latitude.toString() + ', ' + position.longitude.toString();
        String alamat = first.addressLine.toString();

        try {
          //insert code ver 2
          var stream = http.ByteStream(uploadImage.openRead());
          var lenght = await uploadImage.length();
          var url = Uri.parse("http://$ip/ClockIn.php");
          var request = http.MultipartRequest("POST", url);
          var multipartFile = http.MultipartFile("image", stream, lenght,
              filename: path.basename(uploadImage.path));
          request.fields['Emp_Number'] = '$empNumber';
          request.fields['Remark'] = "Keluar";
          request.fields['Koordinat'] = koordinat;
          request.fields['Tempat_Absen'] = alamat;
          request.files.add(multipartFile);
          //Untuk loading update data
          _progress = 0;
          _timer?.cancel();
          _timer =
              Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
            EasyLoading.showProgress(_progress,
                status:
                    'Verify Clock Out : ${(_progress * 100).toStringAsFixed(0)}%');
            _progress += 0.03;

            if (_progress >= 1) {
              _timer?.cancel();
              EasyLoading.dismiss();
            }
          });
          //--------------
          var response = await request.send();
          if (response.statusCode == 200) {
            EasyLoading.showSuccess('Yey ClockOut Berhasil!');
            print("berhasil");
            EasyLoading.dismiss();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Berhasil()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Gagal()));
            print("gagal");
          }
          // await request.send(); // untuk send data to database

          // var response = await request.send();
          // print(response);
          // response.stream.transform(utf8.decoder).listen((value) {});
        } catch (e) {
          debugPrint("Error $e");
        }
      }

      // try {
      //   final coordinates = new Coordinates(latitude, longitude);
      //   var addresses =
      //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
      //   var first = addresses.first;
      //   print("${first.featureName} : ${first.addressLine}");
      // } catch (e) {
      //   print("Error occured: $e");
      // }

      //untuk cek tanggal hari ini udah absen atau belum
      // final response = await http.post("http://$ip/Cek.php", body: {
      //   "Emp_Number": '$empNumber',
      //   "Remark": "Masuk",
      // });

      // print(response.body);
      // var dataEmployee = json.decode(response.body);
      // if (dataEmployee.length == 0) {
      //   var url = "http://$ip/ClockIn.php";
      //   var dataArray = {
      //     "Emp_Number": '$empNumber',
      //     "Jam_Absen": jamMasuk,
      //     "Remark": "Masuk",
      //     "Tanggal": dataTime
      //   };
      //   // print(dataArray);

      //   http.post(url, body: dataArray);
      //   print("bisa input");
      // } else {
      //   print("Ga bisa input");
      // }

    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Gagal()));
      print("pilih foto dulu njingggggg !!!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill)),
              padding: const EdgeInsets.only(
                  top: 35,
                  left: 20,
                  right: 20), //mengatur padiing di dalam body container
              // height: 250,
              // width: 360,

              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 5, top: 5),
                        height: 40,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                        child: Text(
                          "Attendance",
                          style: TextStyle(
                              fontSize: 25,
                              color: purpleMuda,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushReplacementNamed(context, '/menu');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                      empNumber: '$empNumber',
                                    )),
                          );
                        },
                        child: Icon(
                          Icons.menu_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Profile(
                    //               empNumber: '$empNumber',
                    //             )),
                    //   );
                    // },
                    child: Row(
                      children: <Widget>[
                        if (fotoProfil != "")
                          Container(
                            height: 35,
                            width: 35,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2, color: Colors.white),
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    "http://$ip/Employee/$fotoProfil",
                                  )),

                              // image:
                              //     AssetImage("assets/images/addPhoto.png")),
                            ),
                          )
                        else
                          Container(
                            height: 35,
                            width: 35,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2, color: Colors.white),
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  // image: NetworkImage(
                                  //     "http://$ip/Employee/$fotoProfil")),
                                  image:
                                      AssetImage("assets/images/addPhoto.png")),
                            ),
                          ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Hi, " '$empName',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //konten di dalam kontainer
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 4 * 1.7,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, 1),
                        ]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          //untukbox shadow
                          BoxShadow(
                              offset: Offset(1, 5),
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.4))
                        ]),

                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, //untuk membuat text rata kanan
                        children: [
                          Text(
                            "Employee ID :",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$empNumber',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 20, color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                tanggal,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Icon(Icons.access_time_sharp,
                                  size: 20, color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                _timeString,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              // Icon(Icons.timer, size: 25, color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(),
                              ),

                              SizedBox(
                                width: 5,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => History(
                                              empNumber: '$empNumber',
                                            )),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 5, top: 0),
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "History",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: purpleMuda,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: purpleMuda,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      //konten foto
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3 * 1.5,
                      decoration: BoxDecoration(
                          color: Colors.white,

                          // gradient: LinearGradient(colors: [
                          //   Color.fromRGBO(143, 148, 251, 1),
                          //   Color.fromRGBO(143, 148, 251, 1),
                          // ]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            //untukbox shadow
                            BoxShadow(
                                offset: Offset(1, 5),
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.4))
                          ]),

                      child: Column(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2 * 1.8,
                          height: MediaQuery.of(context).size.height / 3 * 1.5,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: uploadImage == null
                                  ? Container(
                                      padding: EdgeInsets.only(top: 45),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/images/addPhoto.png',
                                              height: 220,
                                              width: 210,
                                            ),
                                            Text(
                                              'Tap Untuk Foto Selfie',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: purpleMuda),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Image.file(
                                        uploadImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   elevation: 2,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Add a task'),
      //   onPressed: () {},
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        // hasNotch: false,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 65,
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // SizedBox(
              //   width: 15,
              // ),
              Container(
                height: 50,
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 120, 225, 1),
                      Color.fromRGBO(143, 148, 251, 1),
                    ]),
                    boxShadow: [
                      //untukbox shadow
                      BoxShadow(
                          offset: Offset(1, 3),
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.4))
                    ]),
                child: SizedBox(
                  height: 55,
                  // width: double.infinity,
                  child: FlatButton(
                    // color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home_page');
                      addData(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Clock In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Spacer(),
                        Icon(
                          Icons.timer,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 50,
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 120, 225, 1),
                      Color.fromRGBO(143, 148, 251, 1),
                    ]),
                    boxShadow: [
                      //untukbox shadow
                      BoxShadow(
                          offset: Offset(1, 3),
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.4))
                    ]),
                child: SizedBox(
                  height: 55,
                  // width: double.infinity,
                  child: FlatButton(
                    // color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home_page');
                      addClockOut(context);
                    },

                    child: Row(
                      children: [
                        Text(
                          "Clock Out",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Spacer(),
                        Icon(
                          Icons.timer_off_outlined,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void remove() async {
  SharedPreferences prefData = await SharedPreferences.getInstance();
  prefData.remove('empNo');
}
// _onBasicWaitingAlertPressed(context) async {
//   var jamMasuk = new DateFormat('HH:mm:ss').format(DateTime.now());
//   var tanggal = new DateFormat('dd MMMM yyyy').format(DateTime.now());
//   Alert(
//     context: context,
//     title: "", //"Clock in Berhasil",
//     // desc: jamMasuk,
//     image: Image.asset("assets/images/clock.png"),
//     content: Column(
//       children: <Widget>[
//         Text(
//           "Clock In Berhasil",
//           style: TextStyle(
//               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
//         ),
//         Text(
//           jamMasuk,
//           style: TextStyle(
//               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
//         ),
//       ],
//     ),
//     buttons: [
//       DialogButton(
//         child: Text(
//           tanggal,
//           style: TextStyle(
//               color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//         ),
//         onPressed: () => Navigator.pop(context),
//         gradient: LinearGradient(colors: [
//           Color.fromRGBO(143, 120, 225, .7),
//           Color.fromRGBO(143, 148, 251, 1),
//         ]),
//         radius: BorderRadius.circular(10),
//       ),
//     ],
//     // alertAnimation: fadeAlertAnimation,
//   ).show();
// }

// _onBasicClockOutAllert(context) async {
//   var jamOut = new DateFormat('HH:mm:ss').format(DateTime.now());
//   var tanggalOut = new DateFormat('dd MMMM yyyy').format(DateTime.now());
//   Alert(
//     context: context,
//     title: "", //"Clock in Berhasil",
//     // desc: jamMasuk,
//     image: Image.asset("assets/images/clock.png"),
//     content: Column(
//       children: <Widget>[
//         Text(
//           "Clock Out Berhasil",
//           style: TextStyle(
//               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
//         ),
//         Text(
//           jamOut,
//           style: TextStyle(
//               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
//         ),
//       ],
//     ),
//     buttons: [
//       DialogButton(
//         child: Text(
//           tanggalOut,
//           style: TextStyle(
//               color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//         ),
//         onPressed: () => Navigator.pop(context),
//         gradient: LinearGradient(colors: [
//           Color.fromRGBO(143, 120, 225, .7),
//           Color.fromRGBO(143, 148, 251, 1),
//         ]),
//         radius: BorderRadius.circular(10),
//       ),
//     ],
//     // alertAnimation: fadeAlertAnimation,
//   ).show();
// }

//untuk remove share preference saat logout

// _showDialog(context) async {
//   //untuk memanggil show dialog
//   sliderPopup.showSlideDialog(
//     context: context,
//     barrierColor: Colors.white.withOpacity(0.7),
//     pillColor: Colors.white,
//     backgroundColor: Colors.blueAccent,
//     child: Icon(
//       Icons.android,
//       size: 100.0,
//       color: Colors.white,
//     ),
//   );
// }
