import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  String _username = ''; // Biến để lưu trữ username
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('Users');

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username khi màn hình khởi tạo
  }

  Future<void> _loadUsername() async {
    User? user = _auth.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      _database.child(uid).child('username').onValue.listen((event) {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          setState(() {
            _username = snapshot.value.toString();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username'),
      ),
      body: Center(
        child: Text(
          'Username: $_username',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
