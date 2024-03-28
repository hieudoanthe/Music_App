// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/screens/home_screen.dart';
import 'package:music_player_app/screens/now_playing_screen.dart';
import 'package:music_player_app/screens/podcast_screen.dart';
import 'package:music_player_app/screens/personal_settings_screen.dart';
import 'package:music_player_app/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDJUzfywNCVBK6qWHvyuoflnVP8TlXRf8c', // current_key
          appId:
              '1:903739057659:android:ee7d35fe42d159e158975e', // mobilesdk_app_id
          messagingSenderId: '903739057659', // project_number
          projectId: 'music-app-9464c' // project_id
          ));
  runApp(GetMaterialApp(
    home: const SignInScreen(),
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(name: '/', page: () => const HomeScreen()),
      GetPage(name: '/now_playing', page: () => const NowPLayingScreen()),
      // GetPage(name: '/search', page: () => SearchScreen(onTap: (){},)),
      GetPage(
          name: '/personal_settings',
          page: () => const PersonalSettingsScreen()),
      GetPage(name: '/podcast', page: () => const PodcastScreen()),
    ],
  ));
}
