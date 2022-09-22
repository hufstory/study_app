// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './mainpage.dart';

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);
  @override
  State<Timer> createState() => _TimerState();
}

final uid = FirebaseAuth.instance.currentUser!.uid;
final now = getToday();
var time = 0;

void studyTimer() {
  var data = FirebaseFirestore.instance.collection('users').doc(uid).collection('studyTime')
  .doc(now).get().then(
          (doc) => {
        print(doc.data()!['studyTime']),
        time = doc.data()!['studyTime'],
      }
  );
  print("time: ${time}");
  print(uid);
}

// var time1= 0;
class _TimerState extends State<Timer> {
  var goStop = true;

  Stream<int> timer(uid) {
    studyTimer();
    return Stream<int>.periodic(
        Duration(seconds: 1),
            (count) {
                if(goStop==true){
                  return time;
                }
                else{
                  time += 1;
                  FirebaseFirestore.instance.collection('users').doc(uid).collection('studyTime').doc(now).set({
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
          final hour = (snapshot.data! ~/ 3600).toString();
          final minute = (snapshot.data! ~/ 60).toString();
          final second = (snapshot.data! % 60).toString();
          return Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: hour,
                      style: TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'H',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: minute,
                      style: TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'M',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: second,
                      style: TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: (){
                  if(goStop == false){
                    goStop = true;
                  }
                  else{
                    goStop = false;
                  }
                  print(goStop);
                },
                child: Icon(Icons.pause),
              )
            ],
          );
        }
    );
  }

}
