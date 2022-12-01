import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/studyroom/OnQuestion/OnQuestionAnswerList.dart';

class OnQuestion extends StatefulWidget {
  final String studyID;
  final String documentID;
  final String title;
  final String description;
  final String author;
  const OnQuestion({Key? key, required this.studyID, required this.documentID, required this.title, required this.description, required this.author}) : super(key: key);

  @override
  State<OnQuestion> createState() => _OnQuestionState();
}

class _OnQuestionState extends State<OnQuestion> {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFE37E7E),
          // 앱바 투명
          elevation: 0.0,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          actions: [
            Builder(
              // Drawer 아이콘 색 지정 위해 Builder 위젯 사용
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Drawer 열음
                },
              ),
            )
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/boo.png'),
                ),
                accountName: Text('BOO'),
                accountEmail: Text('boo@hufs.ac.kr'),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffe5cdde), Color(0xff9b7fc1)],
                    ),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0))),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.grey[850],
                ),
                title: const Text('계정 정보'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.people,
                  color: Colors.grey[850],
                ),
                title: const Text('스터디 게시판'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.mail,
                  color: Colors.grey[850],
                ),
                title: const Text('문의하기'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.book,
                  color: Colors.grey[850],
                ),
                title: const Text('자주하는 질문(가이드)'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Column(children: [
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xFFE37E7E)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${widget.author}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        '${widget.description}',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          OnQuestionAnswerList(studyID: widget.studyID, documentID: widget.documentID)
        ]),
    );
  }
}

