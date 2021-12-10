import 'package:Attendance/home_page.dart';
import 'package:Attendance/warna/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
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
      floatingActionButton: FloatingActionButton.extended(
        elevation: 2,
        backgroundColor: purpleMuda,
        label: Row(
          children: [
            const Text(
              'Logout                           ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.logout,
              size: 15,
            )
          ],
        ),
        onPressed: () {
          remove();
          Navigator.pushReplacementNamed(context, '/Login');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
          //     // hasNotch: false,
          //     child: Container(
          //       padding: EdgeInsets.only(left: 15, right: 15),
          //       height: 30,
          //       width: MediaQuery.of(context).size.width,
          //       child: Row(
          //         // mainAxisSize: MainAxisSize.max,
          //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           // SizedBox(
          //           //   width: 15,
          //           // ),
          //           // Container(
          //           //   height: 50,
          //           //   width: 200,
          //           //   decoration: BoxDecoration(
          //           //       borderRadius: BorderRadius.circular(20),
          //           //       gradient: LinearGradient(colors: [
          //           //         Color.fromRGBO(143, 120, 225, 1),
          //           //         Color.fromRGBO(143, 148, 251, 1),
          //           //       ]),
          //           //       boxShadow: [
          //           //         //untukbox shadow
          //           //         BoxShadow(
          //           //             offset: Offset(1, 3),
          //           //             blurRadius: 7,
          //           //             color: Colors.black.withOpacity(0.4))
          //           //       ]),
          //           //   child: SizedBox(
          //           //     height: 55,
          //           //     // width: double.infinity,
          //           //     child: FlatButton(
          //           //       // color: Theme.of(context).primaryColor,
          //           //       textColor: Colors.white,
          //           //       shape: RoundedRectangleBorder(
          //           //           borderRadius: BorderRadius.circular(12)),
          //           //       onPressed: () {
          //           //         remove();
          //           //         Navigator.pushReplacementNamed(context, '/Login');
          //           //       },
          //           //       child: Row(
          //           //         children: [
          //           //           Text(
          //           //             "Logout",
          //           //             style: TextStyle(
          //           //                 fontWeight: FontWeight.bold, fontSize: 15),
          //           //           ),
          //           //           Spacer(),
          //           //           Icon(
          //           //             Icons.timer,
          //           //             size: 15,
          //           //           ),
          //           //         ],
          //           //       ),
          //           //     ),
          //           //   ),
          //           // ),
          //         ],
          //       ),
          //     ),
          ),
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
