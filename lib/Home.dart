import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:quiz/LeaderBoard.dart';
import 'package:quiz/profile.dart' show Profile;
import 'package:quiz/ques1.dart';

 class Home extends StatefulWidget
 {
   const Home({super.key});
   @override
  State<Home> createState() => _HomeState();
  }
  class _HomeState extends State<Home>
  {
  int _selectedIndex = 0;
  List <dynamic> questions = [];
  bool isLoading=true;
  late final List<Widget> _screens;
  @override
  void initState() {
    super.initState();
    _fetchQuestion();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future <void> _fetchQuestion() async
  {
    try {
      final response = await http.get
        (
          Uri.parse
            (
          'https://opentdb.com/api.php?amount=10&category=11&type=multiple')
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          questions = data['results'];
          isLoading=false;
          _screens = [
            HomeScreen(fetchQuestions: questions,),
            const LeaderBoard(),
            const Profile(),
          ];
        }
        );
      }
      else
      {
        throw Exception('Failed to load products');
      }
    }
    catch (e)
    {
      print('Failed to fetch questions');
    }
  }
  Widget build(BuildContext context)
  {
    if (isLoading)
    {
      return const Scaffold(
        body: Center
          (
          child: CircularProgressIndicator(color: Colors.blue),),
      );
    }
    return Scaffold
      (
      body:
      _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue.shade900,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.cyan.shade200,
          unselectedItemColor: Colors.white70,
          items: const
          [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: "LeaderBoard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            )
          ]
      ),
    );
  }
}
  class HomeScreen extends StatelessWidget
  {
    final List<dynamic> fetchQuestions;
     HomeScreen({super.key,required this.fetchQuestions});

    Widget build(BuildContext context)
  {
  return Scaffold
    (
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
  Center(
  child:
  SizedBox(
    height: 200,
    width: MediaQuery.of(context).size.width*0.8,
    child: Container(
    decoration: BoxDecoration(
color: Colors.lightBlue.shade900,
      border: Border.all(color: Colors.cyan.shade200),
      borderRadius: BorderRadius.circular(30.0),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Interesting QUIZ",style:
          TextStyle(color: Colors.cyan.shade200,fontSize: 30,fontWeight: FontWeight.bold),),
          Text("Awaits You",style:
          TextStyle(color: Colors.cyan.shade200,fontSize: 30,fontWeight: FontWeight.bold),),
         SizedBox(height: 5,),
          Text("play quizzes with your friends",style: TextStyle(
            color: Colors.white,fontSize: 15),),
            Text("and get various prizes",style: TextStyle(
                color: Colors.white,fontSize: 15),),
          SizedBox(height: 10,),
            BouncingArrow(
            onPressed: (){
Navigator.push(context,MaterialPageRoute(builder:
    (context)=>Ques1(questions: fetchQuestions,)));
            },
            ),

        ],
      ),

  ),
  )

  ),
    ]
  ),
  );
  }

  }

  class BouncingArrow extends StatefulWidget {
   final VoidCallback onPressed;
    const BouncingArrow({super.key,required this.onPressed});

    @override
    State<BouncingArrow> createState() => _BouncingArrowState();
  }

  class _BouncingArrowState extends State<BouncingArrow>with SingleTickerProviderStateMixin
  {
    late AnimationController _controller;
    late Animation<double> _animation;
    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600),
      )
        ..repeat(reverse: true);

      _animation=Tween<double>(begin: 0,end: 10).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
    void dispose()
    {
      _controller.dispose();
      super.dispose();
    }
    Widget build(BuildContext context) {
      return AnimatedBuilder
        (animation: _animation,
          builder: (context,child)
      {
        return Transform.translate(
            offset: Offset(0, _animation.value),
        child: CircleAvatar(
          backgroundColor: Colors.cyan,
          child: IconButton(onPressed: widget.onPressed,
              icon: Icon(Icons.arrow_forward,color: Colors.white,)),
        ),);
      });
    }
  }


