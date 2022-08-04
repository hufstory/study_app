import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<int> addStudyGroup(leader, groupName, subject, capacity, schedule, rules) async {
  var isExist = await FirebaseFirestore.instance.collection('studyGroup').doc(groupName).get();
  if(isExist.exists) return -1;
  FirebaseFirestore.instance.collection('studyGroup').doc(groupName).set({
    "leader": leader,
    "subject": subject,
    "capacity": capacity,
    "schedule": schedule,
    "rules": rules,
    "members": [leader],
  });
  return 0;
}