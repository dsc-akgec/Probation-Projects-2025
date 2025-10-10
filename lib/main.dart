import 'package:flutter/material.dart';
import 'package:quiz/Home.dart';
import 'package:quiz/LeaderBoard.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/onboarding.dart';
import 'package:quiz/profile.dart';
import 'package:quiz/ques1.dart';
import 'package:quiz/screen/google_login_service.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    initialRoute: 'Home',
    debugShowCheckedModeBanner: false,
    routes: {
      'onboarding':(context)=>Onboarding(),
      'google_login_service': (context) => GoogleLoginScreen(),
      'Home':(context)=>Home(),
      'LeaderBoard':(context)=>LeaderBoard(),
      'profile':(context)=>Profile(),




    },
  ));
}

