import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:Attendance/Login.dart';
import 'package:page_transition/page_transition.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Clean Code',
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill)),
          child: AnimatedSplashScreen(
              duration: 3000,
              splash: Icons.home,
              nextScreen: Login(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.scale,
              backgroundColor: Colors.blue),
        ));
  }
}
