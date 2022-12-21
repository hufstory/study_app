import 'package:flutter/material.dart';
import 'QuestionList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class QAPage extends StatefulWidget {
  const QAPage({Key? key, required this.studyID, required this.studyName}) : super(key: key);
  final String studyID;
  final String studyName;

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

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
      body: Column(children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 130,
              decoration: const BoxDecoration(color: Color(0xFFE37E7E)),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                '${widget.studyName} 질문 답변',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 60.0),
              child: Row(
                children: [
                  Container(
                    alignment: AlignmentDirectional.center,
                    width: MediaQuery.of(context).size.width - 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFEDED),
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 18
                        ),
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.search, color: Colors.black, size: 25,),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        backgroundColor: const Color(0xFFFFEDED),
                        fixedSize: const Size(30, 40)
                      ),
                      child: const Text(
                        '검색',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
        QuestionList(studyID: widget.studyID)
      ]),
    );
  }
}
