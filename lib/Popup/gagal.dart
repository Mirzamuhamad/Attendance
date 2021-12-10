import 'package:Attendance/home_page.dart';
import 'package:Attendance/warna/color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Gagal extends StatefulWidget {
  @override
  _GagalState createState() => _GagalState();
}

class _GagalState extends State<Gagal> {
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
                                'assets/images/gagal.png',
                                height: 300,
                                width: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Yah Gagal !!',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: purpleMuda),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'kamu harus selfie dulu untuk absen',
                                style: TextStyle(
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
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
