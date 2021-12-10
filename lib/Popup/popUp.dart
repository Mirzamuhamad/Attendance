import 'package:flutter/material.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as sliderPopup;

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _showDialog() {
    sliderPopup.showSlideDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.white,
      backgroundColor: Colors.blueAccent,
      child: Icon(
        Icons.android,
        size: 100.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: RaisedButton(
        child: Text("Press to open dialog"),
        onPressed: _showDialog,
      ),
    ));
  }
}
