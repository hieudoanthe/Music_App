// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:music_player_app/screens/home_screen.dart';
import 'package:music_player_app/screens/name_user_sceen.dart';
import 'package:music_player_app/screens/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File? _avatarImage = null;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _imageRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    // Load avatar image when the screen initializes
    _loadAvatarImage();
  }

  Future<void> _loadAvatarImage() async {
    User? user = _auth.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      _imageRef
          .child('Users_Profile')
          .child(uid)
          .child('avatar')
          .onValue
          .listen((event) {
        String? imagePath = event.snapshot.value as String?;
        if (imagePath != null) {
          setState(() {
            _avatarImage = File(imagePath);
          });
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });

      User? user = _auth.currentUser;
      String? uid = user?.uid;

      if (uid != null) {
        _imageRef
            .child('Users_Profile')
            .child(uid)
            .child('avatar')
            .set(pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            MyColors.primaryColor, // Thay đổi màu của thanh tiêu đề
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: MyColors.primaryColor, // Đặt màu nền là màu đen
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatarImage != null
                      ? FileImage(_avatarImage!)
                      : AssetImage('assets/logo.png') as ImageProvider,
                  backgroundColor: Colors.transparent,
                  child: _avatarImage == null
                      ? Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select avatar'),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Name', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsernameScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Email', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    // Action when Email is tapped
                  },
                ),
                ListTile(
                  title:
                      Text('Mine Music', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    // Action when Email is tapped
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text('About',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text('Privacy', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    // Action when Email is tapped
                  },
                ),
                ListTile(
                  title: Text('Storage', style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    // Action when Email is tapped
                  },
                ),
                ListTile(
                  title: Text('Audio Quality',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    // Action when Email is tapped
                  },
                ),
                // Add other fields here
                SizedBox(height: 20),
                Divider(color: Colors.white),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 60.0), // Adjust the padding as needed
                  title: Center(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      print("Sign Out");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
