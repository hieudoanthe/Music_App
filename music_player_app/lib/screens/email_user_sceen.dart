// ignore_for_file: unused_field, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:music_player_app/screens/home_screen.dart';

class EmailDisplayScreen extends StatefulWidget {
  @override
  _EmailDisplayScreenState createState() => _EmailDisplayScreenState();
}

class _EmailDisplayScreenState extends State<EmailDisplayScreen> {
  String? _email;
  String? _username;

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  Future<void> _getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Lấy email từ Firebase Authentication
      setState(() {
        _email = user.email;
      });

      // Lắng nghe sự thay đổi của dữ liệu về username từ Firebase Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(user.uid)
          .child('username');
      userRef.onValue.listen((event) {
        setState(() {
          _username = event.snapshot.value as String?;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          'Email',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: MyColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _email != null
                ? Text(
                    'Your email: $_email',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                : Text(
                    'No.',
                    style: TextStyle(color: Colors.white),
                  ),

            SizedBox(height: 20),
            // _username != null
            //     ? Text('Username của người dùng: $_username')
            //     : Text('Không có tên người dùng.'),
          ],
        ),
      ),
    );
  }
}
