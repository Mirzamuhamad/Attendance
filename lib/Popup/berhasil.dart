import 'package:Attendance/home_page.dart';
import 'package:Attendance/warna/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Berhasil extends StatefulWidget {
  @override
  _BerhasilState createState() => _BerhasilState();
}

class _BerhasilState extends State<Berhasil> {
  var tanggal = new DateFormat('yyyy-MMM-dd HH:mm:ss').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/berhasil.png',
                                height: 300,
                                width: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Yeyy Berhasil',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: purpleMuda),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Absen kamu telah berhasil silahkan Tap',
                                style: TextStyle(
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                    color: purpleMuda),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'untuk kembali ke home page',
                                style: TextStyle(
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                    color: purpleMuda),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '$tanggal',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: purpleMuda),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
