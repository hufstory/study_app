import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  final String studyID;
  const Messages({Key? key, required this.studyID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat timeFormat = DateFormat.jm();

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("studyroom").doc(studyID).collection("talk")
          .orderBy("time", descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text(chatDocs[index]["Nickname"]),
                Row(
                  children: [
                    Text(chatDocs[index]["text"]),
                    const SizedBox(width: 20.0),
                    // Text(timeFormat.format(chatDocs[index]["time"])),
                  ],
                ),
              ],
            );
          }
        );
      },
    );
  }
}
