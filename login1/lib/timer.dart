import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final int time = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: time,
        stream: timer(),
        builder: (context, snapshot) {
          final hour = (snapshot.data! ~/ 60).toString();
          final minute = (snapshot.data! % 60).toString();
          return RichText(
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
          );
        }
    );
  }

  Stream<int> timer() {
    return Stream<int>.periodic(
      Duration(seconds: 1),
      (count) {
        // FirebaseFirestore.instance.collection('user').doc("유저 아이디".user!.uid).set({
        //   'studyTime': time,
        // });
        return time + count;
      }
    );
  }
}
