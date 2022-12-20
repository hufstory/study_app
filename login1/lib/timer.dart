// import 'dart:js_util';

import 'package:flutter/cupertino.dart';
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
  var data = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('studyTime')
      .doc(now)
      .get()
      .then((doc) => {
            print(doc.data()!['studyTime']),
            time = doc.data()!['studyTime'],
          });
  print("time: ${time}");
  print(uid);
}

// var time1= 0;
class _TimerState extends State<Timer> {
  var goStop = true;

  Stream<int> timer(uid) {
    studyTimer();
    return Stream<int>.periodic(Duration(seconds: 1), (count) {
      if (goStop == true) {
        return time;
      } else {
        time += 1;
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('studyTime')
            .doc(now)
            .set({
          'studyTime': time,
        });
        return time;
      }
    });
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: const Color(0XFFE37E7E),
                    fixedSize: const Size(90, 5),
                    minimumSize: const Size(90, 30)),
                onPressed: () {
                  if (goStop == false) {
                    goStop = true;
                  } else {
                    goStop = false;
                  }
                  print(goStop);
                },
                child: goStop
                    ? const Text('START',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))
                    : const Text('STOP',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17)),
              ),
              const Text(
                '오늘 나의 공부시간',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
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
                      text: 'H ',
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
                      text: 'M ',
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
            ],
          );
        });
  }
}
