import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz/screen/google_login_service.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 5),
        ()
    {
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context)=>GoogleLoginScreen()));
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body:
      Container(
        alignment: Alignment.center,

        child: Image.asset('assets/tur.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      )
    );
  }
}
