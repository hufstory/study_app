import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);
  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  //
  // var time = FirebaseFirestore.instance.collection('users')
  //     .doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
  //     return value['studyTime'];
  //   }) as int;

  int time = 0;
  var goStop = true;

  Stream<int> timer(uid) {
    return Stream<int>.periodic(
        Duration(seconds: 1),
            (count) {
          print(goStop);
          print(uid);
          if(goStop==true){
            return time;
          }
          else{
            time += 1;
            FirebaseFirestore.instance.collection('users').doc(uid).set({
              'studyTime': time,
            });
            return time;
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: time,
        stream: timer(uid),
        builder: (context, snapshot) {
          final hour = (snapshot.data! ~/ 60).toString();
          final minute = (snapshot.data! % 60).toString();
          return Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: hour,
                      style: TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'H',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: minute,
                      style: TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'M',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  if(goStop == false){
                    goStop = true;
                  }
                  else{
                    goStop = false;
                  }
                  print(goStop);
                },
                child: Text('Elevated Button'),
              )
            ],
          );}
    );
  }


}