import 'dart:async';
import 'dart:convert';
import 'package:Attendance/ip.dart';
import 'package:Attendance/main.dart';
import 'package:Attendance/warna/color.dart';
import 'package:http/http.dart'
    as http; //tambah dependensi dahulu di folder pubspec.yaml
import 'package:flutter/material.dart';
import 'detail.dart';

// void main() {
//   runApp(new MaterialApp(
//     title: "sampel Get Data",
//     home: new Home(),
//   ));
// }

class History extends StatefulWidget {
  final String
      empNumber; // untuk menampung nilai emp Number pada saat pilih history di home page
  const History({Key key, this.empNumber}) : super(key: key);

  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<History> {
  Future<List> getData() async {
    // final response = await http.get("http://192.168.18.8/absen/getData.php");
    final response = await http
        .post("http://$ip/getData.php", body: {"Emp_Number": '$empNumber'});
    // //untuk mengambil ip dan folder get data dari database mysql
    // var dataEmployee = json.decode(response.body);

    print('$empNumber');
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: [
            Text(
              "History Absen", // ${widget.empNumber}
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF8E93F9),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/light-1.png'),
          // fit: BoxFit.fill,
        )),
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
    );
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
          padding: const EdgeInsets.all(6.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Detail(
                    list: list,
                    index: i) //new detail adalah Class page saat di tambah
                )),
            child: Card(
              color: bakground,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
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
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Jam : " + list[i]["Jam_Absen"],
                            style: (TextStyle(
                                color: purpleMuda,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 0),
                            height: 19,
                            width: 80,
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
                                  list[i]["Remark"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.check_circle_sharp,
                                  size: 10,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ],
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
