import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login1/studyroom/chatroom/ChatRoom.dart';
import 'package:login1/studyroom/QnA/QuestionPage.dart';
import 'package:login1/studyroom/QnA/QAPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

String Email = '';
String Name = '';
FirebaseFirestore db = FirebaseFirestore.instance;
var uid = FirebaseAuth.instance.currentUser!.uid;

Future getUserData() async {
  await db.collection('users').doc(uid!).get().then((user) {
    Email = user.data()!['Email'];
    Name = user.data()!['Name'];
  });
}

Set ruleList = {};
Set alertList = {};

class StudyRoom extends StatefulWidget {
  const StudyRoom({Key? key, required this.studyID, required this.studyName})
      : super(key: key);

  final String studyID;
  final String studyName;

  @override
  State<StudyRoom> createState() => _StudyRoomState();
}

class _StudyRoomState extends State<StudyRoom> {
  readData() async {
    db
        .collection('studyroom')
        .doc(widget.studyID)
        .collection('rule')
        .snapshots()
        .listen(
      (QuerySnapshot qs) {
        for (var doc in qs.docs) {
          ruleList.add(doc["title"]);
        }
      },
    );
    db
        .collection('studyroom')
        .doc(widget.studyID)
        .collection('alert')
        .snapshots()
        .listen((QuerySnapshot qs) {
      for (var doc in qs.docs) {
        alertList.add(doc["title"]);
      }
    });
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            content: Container(
              width: 380,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      Text(
                        '공지사항',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: alertList
                        .map((e) => Text(
                              e,
                              style: const TextStyle(fontSize: 17),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          );
        });
  }

  void showRuleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            content: Container(
              width: 380,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      Text(
                        '스터디룸 규칙',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: ruleList
                        .map((e) => Text(
                              e,
                              style: const TextStyle(fontSize: 17),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  initState() {
    getUserData();
    readData();
    ruleList.clear();
    alertList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: const Color(0xFFE6E6E6),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(45.0),
                  child: AppBar(
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    // 앱바 투명
                    elevation: 0.0,
                    leading: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
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
                ),
                endDrawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: AssetImage('assets/boo.png'),
                        ),
                        accountName: Text('${Name}'),
                        accountEmail: Text('${Email}'),
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
                body: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: const Text('프로필 부분'),
                      ),
                      RichText(
                          text: TextSpan(
                              text: '안녕하세요.',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text:
                                    '\n${widget.studyName} 스터디룸에 오신 것을 환영합니다.',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17))
                          ])),
                      Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: const Text(
                          '링크 부분',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        width: MediaQuery.of(context).size.width,
                        height: 110,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QuestionPage(studyID: widget.studyID)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD9D9D9),
                                      fixedSize: const Size(55, 55),
                                      shape: const CircleBorder()),
                                  child: const Text(
                                    '❓',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => QAPage(
                                                studyID: widget.studyID,
                                                studyName: widget.studyName
                                            )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD9D9D9),
                                      fixedSize: const Size(55, 55),
                                      shape: const CircleBorder()),
                                  child: const Text('📝',
                                      style: TextStyle(fontSize: 24)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                studyID: widget.studyID,
                                                name: widget.studyName)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD9D9D9),
                                      fixedSize: const Size(55, 55),
                                      shape: const CircleBorder()),
                                  child: const Text('👋🏻',
                                      style: TextStyle(fontSize: 25)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '질문\n등록하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 57.0),
                                Text(
                                  '답변하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 57.0),
                                Text(
                                  '채팅방\n입장하기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Text('공지사항',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog();
                        },
                        child: Container(
                            padding: const EdgeInsets.only(top: 10.0),
                            width: MediaQuery.of(context).size.width,
                            height: 63,
                            decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    for (var item in alertList)
                                      Text(
                                        item,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      )
                                  ]),
                            )),
                      ),
                      const Text('스터디룸 규칙',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          showRuleDialog();
                        },
                        child: Container(
                            padding: const EdgeInsets.only(top: 10.0),
                            width: MediaQuery.of(context).size.width,
                            height: 63,
                            decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    for (var item in ruleList)
                                      Text(
                                        item,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      )
                                  ]),
                            )),
                      ),
                    ],
                  ),
                ));
          }
        });
  }
}
