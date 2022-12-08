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
    return Stream<int>.periodic(Duration(minutes: 1), (count) {
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
          final hour = (snapshot.data! ~/ 60).toString();
          final minute = (snapshot.data! % 60).toString();
          return Column(
            children: [
              const Text(
                '오늘 나의 공부시간: ',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: hour,
                      style: const TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: 'H ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: minute,
                      style: const TextStyle(
                        color: Color(0xff645E5E),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
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
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 30),
                    backgroundColor: const Color(0XFFE37E7E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
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
                            fontSize: 17,
                            fontWeight: FontWeight.bold))
                    : const Text('STOP',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }
}
