import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz/screen/google_login_service.dart';


class Profile extends StatefulWidget
              {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
                }



class _ProfileState extends State<Profile> {
  final GoogleSignIn _googleSignIn=GoogleSignIn();
  Future<void> _signOut(BuildContext context) async{
    try
        {
          if(await _googleSignIn.isSignedIn())
            {
              await _googleSignIn.signOut();
            }
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context)=>GoogleLoginScreen()));
        }
        catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      Text("Error Signing Out :$e")),);
    }
  }
  Future<int> _getHigh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return 0;
    final snapshot = await FirebaseFirestore.instance
        .collection('quiz_scores')
        .where('uid', isEqualTo: user.uid)
        .get();
    int highScore = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      int score = data['score'] ?? 0;
      if (score > highScore) highScore = score;
    }
    return highScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor:Colors.lightBlue.shade900,
        title: Text("Movie Bluff",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle:true,
      ),
      body: Stack(
        children: [
          Image.asset('assets/back.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
           Padding(
            padding:EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
                backgroundImage: NetworkImage("${FirebaseAuth.instance.currentUser!
                .photoURL??Icon(Icons.account_circle_sharp)}"),
            ),
            SizedBox(height: 10,),
            Text("Name:${FirebaseAuth.instance.currentUser!.displayName}",
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,
                color: Colors.yellow),),
            SizedBox(height: 10,),
            Text("Email:${FirebaseAuth.instance.currentUser!.email}",style: TextStyle(
              fontSize: 16,fontWeight:FontWeight.w600,color: Colors.yellow
            ),),
SizedBox(height: 50,),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width*1,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade900,
                border: Border.all(color: Colors.cyan.shade200),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: FutureBuilder<int>
                (
                  future: _getHigh(),
                  builder:(context,snapshot)
              {
                if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(
                    child:   Text("Fetching score..."),
                    );    }
                else if(snapshot.hasError)
                  {
                    return Text("Error:${snapshot.error}");
                  }
                else
                  {
                    int highScore=snapshot.data??0;
                    return Center(
                      child:
                      Text("Your Highest Score:$highScore",style:
                      TextStyle(fontSize: 18,color: Colors.yellow.shade600),),);
                  }
              }
              )

            ),
            SizedBox(height: 30,),
            Align(
                alignment:Alignment.bottomCenter,
           child:  ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),

                ),
              minimumSize: Size(300, 30)),
                onPressed: () async
                {
                  await _signOut(context);
                },
                icon: Icon(Icons.logout,color: Colors.white,),
              label: Text('Sign Out', style:
              TextStyle(color: Colors.white, fontSize: 18)),
            )),
              ],
         ),
        ),],
      ),
    );
  }
}
