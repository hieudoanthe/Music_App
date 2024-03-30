// ignore_for_file: prefer_const_constructors, avoid_print, unused_import, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_app/core/controllers.dart';
import 'package:music_player_app/screens/home_screen.dart';
import 'package:music_player_app/screens/profile_screen.dart';
import 'package:music_player_app/screens/signin_screen.dart';
import 'package:music_player_app/shared_widgets/song_item_card.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({Key? key, required this.onTap, String? uid}) : super(key: key);

  final Function() onTap;

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  final AudioPlayerController audioPlayerController = Get.find();
  //
  String? _srcimg;
  String? _uid;
  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  Future<void> _getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _uid = user.uid; // Lưu trữ UID vào biến _uid
      });
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('Users_Profile')
          .child(user.uid)
          .child('avatar');
      userRef.onValue.listen((event) {
        setState(() {
          _srcimg = event.snapshot.value as String?;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("_srcimg: $_srcimg");
    print("_uid: $_uid");
    return Obx(
      () => ListView.builder(
        itemCount: audioPlayerController.listOfSongs.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            print("Profile");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          icon: Stack(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 45,
                              ),
                              if (_srcimg != null)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.brightness_1,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          'All Songs',
                          style: GoogleFonts.poppins(
                            color: MyColors.tertiaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Obx(
            () => SongItemCard(
              song: audioPlayerController.listOfSongs[index - 1],
              onTap: () {
                audioPlayerController.setInSearchMode(false);
                if (audioPlayerController.song.value != null) {
                  if (audioPlayerController.song.value ==
                      audioPlayerController.listOfSongs[index - 1]) {
                    audioPlayerController.resume();
                  }
                }
                audioPlayerController.currentIndex = (index - 1).obs;
                audioPlayerController
                    .setSong(audioPlayerController.listOfSongs[index - 1]);
                audioPlayerController.play();
                widget.onTap();
              },
            ),
          );
        },
      ),
    );
  }
}
