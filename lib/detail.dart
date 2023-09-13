import 'package:Attendance/ip.dart';
import 'package:flutter/material.dart';
import 'package:Attendance/History.dart';

// import 'FadeAnimation/FadeAnimation.dart';
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
              top: -50,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      //untukbox shadow
                      BoxShadow(
                        spreadRadius: 3,
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.4),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        "http://$ip/image/${widget.list[widget.index]['image']}",
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 200, bottom: 150),
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 25,
                              bottom: 25,
                              left: 80,
                              right: 80,
                            ),
                            decoration: BoxDecoration(
                              color: purpleMuda.withOpacity(1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: purpleMuda,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
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
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 0,
              left: -290,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: purpleMuda.withOpacity(.5),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: []),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => History()),
                      );
                    },
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 490, right: 10, bottom: 15),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  // width: MediaQuery.of(context).size.width,
                  // height: 690,
                  // height: MediaQuery.of(context).size.height *
                  //     2 /
                  //     2.2 *
                  //     1.2, // 3 * 2.1,
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(colors: [
                  //       Color.fromRGBO(143, 148, 251, 1),
                  //       Color.fromRGBO(143, 148, 251, 1),
                  //     ]),
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(20),
                  //       topRight: Radius.circular(20),
                  //       bottomLeft: Radius.circular(20),
                  //       bottomRight: Radius.circular(20),
                  //     ),
                  //     boxShadow: [
                  //       //untukbox shadow
                  //       BoxShadow(
                  //           offset: Offset(1, 5),
                  //           blurRadius: 10,
                  //           color: Colors.black.withOpacity(0.4))
                  //     ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, //untuk membuat text rata kanan
                    children: [
                      Row(
                        children: [
                          Text(
                            "Employee Name",
                            style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 0),
                            height: 19,
                            width: 160,
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
                                  "Sukses Absen ${widget.list[widget.index]['Remark']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: putih,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.person_pin,
                                  size: 10,
                                  color: putih,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person_pin,
                            size: 15,
                            color: purpleMuda,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${widget.list[widget.index]['Emp_Name']}",
                            style: TextStyle(
                              fontSize: 15,
                              color: purpleMuda,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Employee ID",
                            style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.fingerprint_outlined,
                            size: 15,
                            color: purpleMuda,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${widget.list[widget.index]['Emp_Number']}",
                            style: TextStyle(
                              fontSize: 15,
                              color: purpleMuda,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Tanggal",
                            style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 15,
                            color: purpleMuda,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${widget.list[widget.index]['Tanggal']}",
                            style: TextStyle(
                              fontSize: 15,
                              color: purpleMuda,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Jam",
                            style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_sharp,
                            size: 15,
                            color: purpleMuda,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${widget.list[widget.index]['Jam_Absen']}",
                            style: TextStyle(
                              fontSize: 15,
                              color: purpleMuda,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Tempat Absen",
                            style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person_pin_circle_outlined,
                            size: 15,
                            color: purpleMuda,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Text(
                              "${widget.list[widget.index]['Tempat_Absen']}",
                              style: TextStyle(
                                fontSize: 15,
                                color: purpleMuda,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1))
                            ]),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History()),
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
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
