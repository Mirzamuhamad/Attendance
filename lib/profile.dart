import 'dart:async';
import 'dart:convert';
import 'package:Attendance/EditProfile.dart';
import 'package:Attendance/Login.dart';
import 'package:Attendance/home_page.dart';
import 'package:Attendance/ip.dart';
import 'package:Attendance/main.dart';
import 'package:Attendance/warna/color.dart';
import 'package:http/http.dart'
    as http; //tambah dependensi dahulu di folder pubspec.yaml
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(new MaterialApp(
//     title: "sampel Get Data",
//     home: new Home(),
//   ));
// }

class Profile extends StatefulWidget {
  final String
      empNumber; // untuk menampung nilai emp Number pada saat pilih Profile di home page
  const Profile({Key key, this.empNumber}) : super(key: key);

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<List> getData() async {
    final response = await http
        .post("http://$ip/getEmployee.php", body: {"Emp_Number": '$empNumber'});

    print('$empNumber');
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Profile Kamu", // ${widget.empNumber}
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: black),
            ),
          ],
        ),
        elevation: 1,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios_rounded,
            color: black,
            size: 17,
          ),
          onPressed: () {
            // Navigator.pop(context);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          empNumber: empNumber,
                          empName: empName,
                        )),
                (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: putih,
      ),
      body: Container(
        child: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? new ItemList(
                    list: snapshot.data,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 2,
        backgroundColor: purpleMuda,
        label: Row(
          children: [
            const Text(
              'Logout                           ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
            Icon(
              Icons.logout,
              size: 15,
            )
          ],
        ),
        // onPressed: () {
        //   remove();
        //   // Navigator.pushReplacementNamed(context, '/Login');

        //   Navigator.of(context).pushAndRemoveUntil(
        //       MaterialPageRoute(builder: (context) => Login()),
        //       (Route<dynamic> route) => false);
        // },
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Anda yakin ingin Logout .?',
              style: TextStyle(fontSize: 17),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  remove();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void remove() async {
    SharedPreferences prefData = await SharedPreferences.getInstance();
    prefData.remove('empNo');
    prefData.remove('empName');
  }

  void dataEmp() async {
    String empName;
    String empNumber;
    SharedPreferences prefData = await SharedPreferences.getInstance();
    empName = prefData.get('empName');
    empNumber = prefData.get('empNo');

    print(empNumber);
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      //Menampilkan data dari database listview
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        // return new Text(list[i]["Emp_Number"]);

        return new Container(
          padding:
              const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 100),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new EditProfile(
                    list: list,
                    index: i) //new detail adalah Class page saat di tambah
                )),
            child: Card(
              elevation: 1,
              color: bakground,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      list[i]["fotoProfil"] == ""
                          ? Container(
                              height: 80,
                              width: 80,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2, color: purpleMuda),
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  // image:NetworkImage("assets/images/berhasil.png")),
                                  image:
                                      AssetImage("assets/images/addPhoto.png"),
                                ),
                              ),
                            )
                          : Container(
                              // height: MediaQuery.of(context).size.height / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // border: Border.all(width: 4, color: purpleMuda),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    "http://$ip/Employee/${list[i]["fotoProfil"]}",
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Container(
                                      // padding:
                                      //     EdgeInsets.only(top: 100, bottom: 50),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: 25,
                                          bottom: 25,
                                          left: 80,
                                          right: 80,
                                        ),
                                        decoration: BoxDecoration(
                                          color: purpleMuda.withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            CircularProgressIndicator(
                                              backgroundColor: purpleMuda,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Loading Image . . .",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: putih),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }, fit: BoxFit.fill),
                              ),
                              // height: 80,
                              // width: 80,
                              // decoration: new BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   border: Border.all(width: 2, color: purpleMuda),
                              //   image: new DecorationImage(
                              //       fit: BoxFit.fill,
                              //       image: NetworkImage(
                              //           "http://$ip/Employee/${list[i]["fotoProfil"]}",
                              //          )),
                              //   // image: AssetImage(
                              //   //     "assets/images/addPhoto.png")),
                              // ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            list[i]["Emp_Name"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15,
                            color: black,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.camera_front_rounded,
                            size: 16,
                            color: purpleMuda,
                          ),
                          Text(
                            list[i]["Emp_Number"],
                            style: (TextStyle(
                                color: purpleMuda,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Telp : " + list[i]["Telp"],
                            style: (TextStyle(
                                color: purpleMuda,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 5, top: 0),
                            height: 25,
                            width: 90,
                            decoration: BoxDecoration(
                              color: purpleMuda,
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
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.edit_rounded,
                                  size: 10,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
