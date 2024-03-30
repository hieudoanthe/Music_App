// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_final_fields, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:music_player_app/screens/home_screen.dart';

class NameDisplayScreenState extends StatefulWidget {
  @override
  _NameDisplayScreenStateState createState() => _NameDisplayScreenStateState();
}

class _NameDisplayScreenStateState extends State<NameDisplayScreenState> {
  String? _email;
  String? _username;
  TextEditingController _usernameController = TextEditingController();
  bool _disposed = false; // Thêm biến để theo dõi trạng thái dispose

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  @override
  void dispose() {
    _disposed = true; // Đánh dấu rằng widget đã dispose
    _usernameController.dispose();
    super.dispose();
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
        if (!_disposed) {
          // Kiểm tra trước khi gọi setState()
          setState(() {
            _username = event.snapshot.value as String?;
          });
        }
      });
    }
  }

  Future<void> _updateUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Cập nhật username vào Firebase Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(user.uid)
          .child('username');
      await userRef.set(_usernameController.text);

      // Cập nhật _username để hiển thị trên giao diện
      if (!_disposed) {
        // Kiểm tra trước khi gọi setState()
        setState(() {
          _username = _usernameController.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          'Your Name',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: MyColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _username != null
                  ? Column(
                      children: [
                        Text(
                          'Hello, $_username!',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Enter a new name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _updateUsername,
                          child: Text('Save'),
                        ),
                      ],
                    )
                  : Text('Loading...'),
            ],
          ),
        ),
      ),
    );
  }
}
