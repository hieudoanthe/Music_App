// ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, unused_import, avoid_print, deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/reuseable_widgets/reuseable_widget.dart';
import 'package:music_player_app/screens/home_screen.dart';
import 'package:music_player_app/utils/color_utils.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  final databaseReference =
      FirebaseDatabase.instance.reference().child("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  // Lưu email vào Firebase Authentication
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((UserCredential userCredential) {
                    print("Created New Account ");
                    // Lấy UID của người dùng từ UserCredential
                    String userUid = userCredential.user!.uid;
                    // Lưu tên người dùng và email vào Firebase Database
                    databaseReference.child(userUid).set({
                      'username': _userNameTextController.text,
                      'email': _emailTextController.text,
                      'address': 'null'
                    }).then((_) {
                      print("Đã lưu thông tin người dùng vào Firebase.");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }).catchError((error) {
                      print("Lỗi khi lưu tên người dùng vào Firebase: $error");
                    });
                  }).catchError((error) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
