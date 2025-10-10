import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.lightBlue.shade900,
          title: Text("LeaderBoard",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          centerTitle:true,
        ),
      body:Stack(
        children: [
          Image.asset('assets/back.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
      StreamBuilder<QuerySnapshot>
  (
    stream: FirebaseFirestore.instance
    .collection('quiz_scores')
    .orderBy('score',descending: true)
    .snapshots(),
     builder: (context,snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
         return const Center(child: CircularProgressIndicator(color: Colors.blue,));
       }
       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
         return const Center(child: Text("No scores yet."));
       }
       final scores = snapshot.data!.docs;
       return ListView.builder(
           itemCount: scores.length,
           itemBuilder: (context, index) {
             final data = scores[index].data() as Map<String, dynamic>;
             final email=data['email']??'Unknown';
             final score=data['score']??0;
             final total=data['total']??0;
             return Card(
               margin: EdgeInsets.symmetric(horizontal: 16,vertical: 18),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(15),
                 ),
               color: Colors.lightBlue.shade900,
               child: ListTile(
                 leading: CircleAvatar(
                   backgroundColor: Colors.white,
                   child: Text('${index+1}',
                     style: TextStyle(color: Colors.indigo),),
                 ),
                 title: Text(email,style: TextStyle(
                   color: Colors.yellow.shade600,fontWeight: FontWeight.bold
                 ),),
                 trailing: Text('$score/$total',style: TextStyle(
                   color: Colors.yellow.shade600
                 ),),
               ),
             );

           }
       );
     },
) ])

  );
}
}
