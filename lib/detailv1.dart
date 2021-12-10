import 'package:Attendance/ip.dart';
import 'package:flutter/material.dart';
import 'package:Attendance/History.dart';

import 'FadeAnimation/FadeAnimation.dart';
import 'warna/color.dart';

// ignore: must_be_immutable
class Detail extends StatefulWidget {
  List list;
  int index;

  Detail({this.index, this.list});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 160, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "${widget.list[widget.index]['Emp_Name']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 10, right: 50),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History()),
                            );
                          },
                          child: Center(
                            child: Text(
                              "Detail absen kamu",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 200,
              width: 100,
              height: 150,
              child: FadeAnimation(
                  1.3,
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'))),
                  )),
            ),
            Positioned(
              right: 0,
              width: 80,
              height: 100,
              child: FadeAnimation(
                  1.3,
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'))),
                  )),
            ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 15, top: 160, right: 15, bottom: 15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: 690,
                  // height: MediaQuery.of(context).size.height *
                  //     2 /
                  //     2.2 *
                  //     1.2, // 3 * 2.1,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, //untuk membuat text rata kanan
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                            size: 15,
                          ),
                          Text(
                            "Employee ID :",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 0),
                            height: 19,
                            width: 140,
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
                                  "Sukses Absen ${widget.list[widget.index]['Remark']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: purpleMuda,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.check_circle_sharp,
                                  size: 10,
                                  color: purpleMuda,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.list[widget.index]['Emp_Number']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 15,
                          ),
                          Text(
                            "Jam Absen:",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.list[widget.index]['Jam_Absen']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 15,
                          ),
                          Text(
                            " Tanggal : ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.list[widget.index]['Tanggal']}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width / 2 * 1.8,
                        // height: MediaQuery.of(context).size.height / 2 * 1.3,
                        width: MediaQuery.of(context).size.width,
                        height: 455,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 5, color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                                "http://$ip/image/${widget.list[widget.index]['image']}",
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            }, fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //For button
            Positioned(
              top: 775,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  height: 70,
                  width: 70,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        // BoxShadow(
                        //     color: Colors.black.withOpacity(.3),
                        //     spreadRadius: 2,
                        //     blurRadius: 2,
                        //     offset: Offset(0, 1))
                      ]),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => History()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [purpleMuda, purPuleTua],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
