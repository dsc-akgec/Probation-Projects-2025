import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz/Home.dart';

import '../service/google_auth_service.dart' show FirebaseServices;

final GoogleSignIn _googleSignIn=GoogleSignIn();
class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  void initState()
  {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account)
    {
      if(mounted)
        {
          setState(() {});
          _googleSignIn.signInSilently();
        }
    }
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(

        children: [
          Image.asset('assets/back.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
      GestureDetector(
          onTap: () async
          {
           bool result=await FirebaseServices().signInWithGoogle();
           if(result)
             {
               Navigator.pushReplacement
                 (context, MaterialPageRoute(builder: (context)=>Home()));
             }
           else
             {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google SignIn Cancelled"),
               ));
             }
          },
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.google,color: Colors.white,size: 30,),
            SizedBox(width: 10),
            Text("Continue With Google",
              style: TextStyle(color: Colors.yellow.shade400,fontSize: 30),),
          ],
        ),
        ),
    ]
        )
        ]
      )
    );
  }
}
