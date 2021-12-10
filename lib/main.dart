import 'package:Attendance/Popup/menu.dart';
import 'package:Attendance/profile.dart';
import 'package:flutter/material.dart';
import 'package:Attendance/Login.dart';
import 'package:Attendance/history.dart';
import 'package:Attendance/home_page.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

String empNumber;
String empName;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //untuk menjalankan class tanpa triger
    super.initState();
    _askPermission();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.purpleAccent),
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/home_page': (BuildContext context) => new HomePage(
              empNumber: empNumber,
              empName: empName,
            ),
        '/history': (BuildContext context) => new History(
              empNumber: empNumber,
            ),
        '/profile': (BuildContext context) => new Profile(
              empNumber: empNumber,
            ),
        '/Login': (BuildContext context) => new Login(),
      },
    );
  }

  Future<void> _askPermission() async {
    try {
      final PermissionStatus locationPerms =
          await Permission.locationWhenInUse.status;
      if (locationPerms != PermissionStatus.granted) {
        await Permission.locationWhenInUse.request();
      }

      final PermissionStatus cameraPerms = await Permission.camera.status;
      if (cameraPerms != PermissionStatus.granted) {
        await Permission.camera.request();
      }

      // final PermissionStatus storagePerms = await Permission.storage.status;
      // if (storagePerms != PermissionStatus.granted) {
      //   await Permission.storage.request();
      // }

      final PermissionStatus phonePerms = await Permission.phone.status;
      if (phonePerms != PermissionStatus.granted) {
        await Permission.phone.request();
      }

      // final PermissionStatus notificationPerms =
      //     await Permission.notification.status;
      // if (notificationPerms != PermissionStatus.granted) {
      //   await Permission.notification.request();
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
