import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:latest_collage_p/controllers/auth_controller.dart';
import 'package:latest_collage_p/views/screens/add_video_screen.dart';
import 'package:latest_collage_p/views/screens/message_screen.dart';
import 'package:latest_collage_p/views/screens/profile_screen.dart';
import 'package:latest_collage_p/views/screens/search_screen.dart';
import 'package:latest_collage_p/views/screens/video_screen.dart';

//Screen content
List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  MessagesScreen(),
  ProfileScreen(uid: authController.user.uid),
];

//Colors
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//Database Storage
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebase = FirebaseFirestore.instance;

//Controllers
var authController = AuthController.instance;
