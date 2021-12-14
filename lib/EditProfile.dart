// import 'package:Attendance/ip.dart';

import 'dart:async';
import 'dart:io';
import 'package:Attendance/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'FadeAnimation/FadeAnimation.dart';
import 'ip.dart';
import 'warna/color.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  List list;
  int index;

  EditProfile({this.index, this.list});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Timer _timer;
  double _progress;

  File uploadImage;
  Future getImage() async {
    var picImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (picImage != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: picImage.path,
          compressQuality: 20,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: '',
              toolbarColor: purpleMuda,
              toolbarWidgetColor: Colors.white,
              // initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true), //untuk crop bisa di atur besar kecilnya
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      setState(() {
        if (croppedFile != null) {
          EasyLoading.showSuccess('Berhasil Pilih Foto');
          uploadImage = File(croppedFile.path);
          print(uploadImage);
        } else {
          print("belom pilih image bloggggg !!!");
        }
      });
    } else {
      print("Tidak pilih foto");
    }
  }

  // Future getImage() async {
  //   var picImage = await ImagePicker()
  //       .getImage(source: ImageSource.gallery, imageQuality: 50);
  //   // var picImageGal = await ImagePicker().getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (picImage != null) {
  //       EasyLoading.showSuccess('Berhasil Pilih Foto');
  //       uploadImage = File(picImage.path);
  //       print(uploadImage);
  //     } else {
  //       print("belom pilih image bloggggg !!!");
  //     }
  //   });
  // }

  TextEditingController txtEmail,
      txtEmpNumber,
      txtEmpName,
      txtTglLahir,
      txtTelp;

  txtSetup() {
    txtEmpNumber =
        TextEditingController(text: widget.list[widget.index]['Emp_Number']);
    txtEmpName =
        TextEditingController(text: widget.list[widget.index]['Emp_Name']);
    txtTglLahir =
        TextEditingController(text: widget.list[widget.index]['Tgl_Lahir']);
    txtTelp = TextEditingController(text: widget.list[widget.index]['Telp']);
    txtEmail = TextEditingController(text: widget.list[widget.index]['email']);
  }

  void _updateFoto() async {
    print(txtEmail.text);
    if (uploadImage != null) {
      try {
        //insert code ver 2

        var stream = http.ByteStream(uploadImage.openRead());
        var lenght = await uploadImage.length();
        var url = Uri.parse("http://$ip/UpdateFoto.php");
        var request = http.MultipartRequest("POST", url);
        var multipartFile = http.MultipartFile("Employee", stream, lenght,
            filename: path.basename(uploadImage.path));
        request.fields['Emp_Number'] =
            '${widget.list[widget.index]['Emp_Number']}';
        request.fields['Emp_Name'] = txtEmpName.text;
        request.fields['Tgl_Lahir'] = txtTglLahir.text;
        request.fields['Telp'] = txtTelp.text;
        request.fields['email'] = txtEmail.text;
        request.files.add(multipartFile);
        // await request.send(); // untuk send data to database
        //Untuk loading update data
        _progress = 0;
        _timer?.cancel();
        _timer =
            Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
          EasyLoading.showProgress(_progress,
              status:
                  'Update Proses : ${(_progress * 100).toStringAsFixed(0)}%');
          _progress += 0.03;

          if (_progress >= 1) {
            _timer?.cancel();
            EasyLoading.dismiss();
          }
        });
        //--------------
        var response = await request.send();
        if (response.statusCode == 200) {
          EasyLoading.showSuccess('Update Success!');
          print("berhasil");
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        empNumber: '${widget.list[widget.index]['Emp_Number']}',
                      )),
            );
          });
          EasyLoading.dismiss();
        } else {
          EasyLoading.showError('Gagal Update Data');
          print("gagal");
        }
        // print(response);
        // response.stream.transform(utf8.decoder).listen((value) {});
      } catch (e) {
        debugPrint("Error $e");
      }
    } else {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    empNumber: '${widget.list[widget.index]['Emp_Number']}',
                  )),
        );
      });
    }
  }

  @override
  void initState() {
    //untuk menjalankan class tanpa triger
    super.initState();
    txtSetup();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.showSuccess('Use in initState');
    // EasyLoading.removeCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Edit Profile", // ${widget.empNumber}
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
            Navigator.pop(context);
          },
        ),
        backgroundColor: putih,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 15),
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, //untuk membuat text rata kanan
                  children: [
                    if (uploadImage == null)
                      if ('${widget.list[widget.index]['fotoProfil']}' != "")
                        Container(
                          height: 100,
                          width: 100,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: purpleMuda),
                            image: new DecorationImage(
                                // fit: BoxFit.fill,
                                image: NetworkImage(
                                    "http://$ip/Employee/${widget.list[widget.index]['fotoProfil']}")),
                            // image: AssetImage("assets/images/addPhoto.png")),
                          ),
                        )
                      else
                        Container(
                          height: 100,
                          width: 100,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: purpleMuda),
                            image: new DecorationImage(
                                // fit: BoxFit.fill,
                                //
                                image:
                                    AssetImage("assets/images/addPhoto.png")),
                            // image: FileImage(uploadImage)),
                          ),
                        )
                    else
                      Container(
                        height: 100,
                        width: 100,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: purpleMuda),
                          image: new DecorationImage(
                              // fit: BoxFit.fill,
                              // image:NetworkImage("assets/images/berhasil.png")),
                              image: FileImage(uploadImage)),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 0),
                            height: 20,
                            width: 100,
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
                                  "Pilih Foto",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: putih,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.camera_alt_rounded,
                                  size: 15,
                                  color: putih,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
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
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: putih,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.only(left: 0),
                        child: TextField(
                          controller: txtEmpName,
                          style: TextStyle(
                            color: purPuleTua,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                              fillColor: putih,
                              prefixIcon: Icon(
                                Icons.person_pin,
                                size: 15,
                                color: purpleMuda,
                              ),
                              border: InputBorder.none,
                              hintText: "Employee Name",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.person_pin,
                    //       size: 15,
                    //       color: purpleMuda,
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Text(
                    //       "${widget.list[widget.index]['Emp_Name']}",
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //         color: purpleMuda,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: putih,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.only(left: 0),
                        child: TextField(
                          controller: txtEmpNumber,
                          enabled: false,
                          style: TextStyle(
                            color: purPuleTua,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                              fillColor: putih,
                              prefixIcon: Icon(
                                Icons.fingerprint_outlined,
                                size: 15,
                                color: purpleMuda,
                              ),
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.fingerprint_outlined,
                    //       size: 15,
                    //       color: purpleMuda,
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Text(
                    //       "${widget.list[widget.index]['Emp_Number']}",
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //         color: purpleMuda,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: putih,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.only(left: 0),
                        child: TextField(
                          controller: txtTglLahir,
                          style: TextStyle(
                            color: purPuleTua,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                              fillColor: putih,
                              prefixIcon: Icon(
                                Icons.date_range_rounded,
                                size: 15,
                                color: purpleMuda,
                              ),
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                    Container(
                      //untuk date picker
                      child: TextButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 3, 5),
                                maxTime: DateTime(2019, 6, 7),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.id);
                          },
                          child: Text(
                            'show date time picker (Chinese)',
                            style: TextStyle(color: Colors.blue),
                          )),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.person_pin_circle_outlined,
                    //       size: 15,
                    //       color: purpleMuda,
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "${widget.list[widget.index]['Tgl_Lahir']}",
                    //         style: TextStyle(
                    //           fontSize: 15,
                    //           color: purpleMuda,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Telp",
                          style: TextStyle(
                            fontSize: 15,
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: putih,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.only(left: 0),
                        child: TextField(
                          controller: txtTelp,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: purPuleTua,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                              fillColor: putih,
                              prefixIcon: Icon(
                                Icons.phone_android_rounded,
                                size: 15,
                                color: purpleMuda,
                              ),
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.phone_android_rounded,
                    //       size: 15,
                    //       color: purpleMuda,
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Text(
                    //       "${widget.list[widget.index]['Telp']}",
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //         color: purpleMuda,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 15,
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.email_rounded,
                    //       size: 15,
                    //       color: purpleMuda,
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Text(
                    //       "${widget.list[widget.index]['email']}",
                    //       style: TextStyle(
                    //         fontSize: 15,
                    //         color: purpleMuda,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: putih,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.only(left: 0),
                        child: TextField(
                          controller: txtEmail,
                          style: TextStyle(
                            color: purPuleTua,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                              fillColor: putih,
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                size: 15,
                                color: purpleMuda,
                              ),
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 50,
                    //   width: MediaQuery.of(context).size.width,
                    //   padding: EdgeInsets.all(5),
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(50),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color: Colors.black.withOpacity(.1),
                    //             spreadRadius: 1,
                    //             blurRadius: 3,
                    //             offset: Offset(0, 1))
                    //       ]),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // Navigator.pop(
                    //       //   context,
                    //       //   MaterialPageRoute(
                    //       //       builder: (context) => History()),
                    //       // );
                    //       // getImage();
                    //       _updateFoto();
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           gradient: LinearGradient(
                    //               colors: [purpleMuda, purPuleTua],
                    //               begin: Alignment.topLeft,
                    //               end: Alignment.bottomRight),
                    //           borderRadius: BorderRadius.circular(50),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.black.withOpacity(.3),
                    //               spreadRadius: 1,
                    //               blurRadius: 1,
                    //               offset: Offset(0, 1),
                    //             ),
                    //           ]),
                    //       child: Icon(
                    //         Icons.arrow_back_ios_rounded,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 2,
        backgroundColor: purpleMuda,
        label: Row(
          children: [
            const Text(
              '                     Save                    ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
            // Icon(
            //   Icons.save_sharp,
            //   size: 15,
            // )
          ],
        ),
        onPressed: () {
          _updateFoto();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
