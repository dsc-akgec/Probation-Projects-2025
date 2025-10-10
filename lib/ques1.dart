import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html_unescape/html_unescape.dart';
  class Ques1 extends StatefulWidget
  {
  final List<dynamic> questions;
  const Ques1({super.key,required this.questions});

  @override
  State<Ques1> createState() => _Ques1State();
  }
  class _Ques1State extends State<Ques1>
  {
  @override
  int currentindex=0;
  int score=0;
  String?selectedAnswer;
  late List<String> options;
  Timer? _timer;
  int timeLeft=15;

  void startTimer()
  {
    _timer?.cancel();
    timeLeft=15;
    _timer=Timer.periodic(Duration(seconds: 1), (timer)
    {
      if(timeLeft>0)
        {
          setState(() {
            timeLeft--;
          });
        }
      else
        {
          timer.cancel();
          next();
        }
    });
  }

  void initState()
  {
    super.initState();
    _setOptions();
    startTimer();
  }
  void _setOptions()
  {
    final q=widget.questions[currentindex];
    options=[...q['incorrect_answers'],q['correct_answer']]..shuffle();
  }

  void check (String selected) {
    setState(()
    {
      selectedAnswer = selected;
      final correct = widget.questions[currentindex]['correct_answer'];
      if (selected == correct)
      {
        score++;
      }
    });
  }
   void next()
   async {
        if(currentindex<widget.questions.length-1)
        {
          setState(() {
            currentindex++;
            selectedAnswer=null;
            _setOptions();
            startTimer();
          });

        }
        else {
          _timer?.cancel();
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance.collection('quiz_scores')
                  .add(
                  {
                    'uid': user.uid,
                    'email': user.email,
                    'score': score,
                    'total': widget.questions.length,
                    'timestamp': FieldValue.serverTimestamp(),
                  }
              );
            }
          }
          catch (e) {
            print("Error saving score:$e");
          }
          if (mounted) {
            Future.delayed(const Duration(microseconds: 200), () {
              showDialog(
                context: context,
                builder: (_) =>
                    AlertDialog(
                      title: const Text("Quiz Finished!"),
                      content: Text(
                          "Your Score: $score / ${widget.questions.length}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                            Navigator.pop(context); // go back to home
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
              );
            });
          }
        }
        }
    void previous()
    {
      if(currentindex>0)
      {
        setState(() {
          currentindex--;
          selectedAnswer=null;
          _setOptions();
          startTimer();
        });
      }
    }
    Widget build(BuildContext context) {
    final q=widget.questions[currentindex];
    final unescape=HtmlUnescape();
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
        appBar: AppBar(
          backgroundColor:Colors.lightBlue.shade900,
          title: Text("Questions",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          centerTitle:true,
        ),
        body: Stack
        (
          children: [
            Image.asset('assets/back.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
          Center(
            child:
          SizedBox(
            height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width*0.9,
                    child: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade900,
            border: Border.all(color: Colors.cyan.shade200),
            borderRadius: BorderRadius.circular(30.0),
          ),
        child:Padding(padding:EdgeInsets.all(10),
     child:    Column(
          children: [

            SizedBox(height: 10,),
            Text(
              "Question ${currentindex+1}/${widget.questions.length}",
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.cyan.shade200),),
          SizedBox(height: 10,),
          Text(unescape.convert(
            q['question']),style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          ...options.map((opt) {
            Color color = Colors.blue.shade900;
            if (selectedAnswer != null) {
              if (opt == q['correct_answer'])
                color = Colors.green;
              else
                color = Colors.red;
            }
            return Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:color,
                    shape: RoundedRectangleBorder(),
                  shadowColor: Colors.purple,
                minimumSize: Size(300, 40),
                ),
                onPressed: () => check(opt),
                child: Text(unescape.convert(
                  opt), style: TextStyle(color: Colors.white),),
              ),
            );
          }
          ).toList(),
            SizedBox(height: 20,),

      ],
      ),)
                    )
                )
           ,
          ),

           SizedBox(height: 20,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               ElevatedButton(
                   onPressed: next,
                   child: Text("Next",
                     style: TextStyle(color: Colors.blue.shade900),)
               ),
             ],
           ),
    SizedBox(height: 10,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$timeLeft",style: TextStyle(
          fontSize: 18,color: timeLeft<=5?Colors.red:Colors.black,
          fontWeight: FontWeight.bold,
        ),
        ),

      ], )
         ],
    )
        ]
    )
    );
  }
}
