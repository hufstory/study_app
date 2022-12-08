import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login1/SignUpPage.dart';

class AnswerPage extends StatefulWidget {
  final String studyID;
  final String questionID;
  const AnswerPage({Key? key, required this.studyID, required this.questionID}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TextEditingController _answerController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String _answer = '';

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Positioned(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                    )),
                Positioned(
                    left: 40,
                    top: 20,
                    width: 350,
                    height: 55,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(50, 10, 0, 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFEDED),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        '답변하기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )),
                Positioned(
                    left: 10,
                    width: 65,
                    height: 65,
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xFFE37E7E),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Text('📨',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 40))))
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('답변',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
              child: Container(
                alignment: AlignmentDirectional.center,
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEDED),
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 240,
                  child: TextField(
                    controller: _answerController,
                    onChanged: (value) {
                      setState(() {
                        _answer = value;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('사진 업로드',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 4.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEDED),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed:  _answerController.text.isEmpty ? null : () async {
                    String userName = '';
                    await db.collection("users").doc(uid).get().then((value) => userName = value.data()!['Name']);
                    await db.collection("studyroom").doc(widget.studyID).collection("question").doc(widget.questionID).collection("answer").doc().set({
                      "description": _answer,
                      "author": userName,
                    }).onError((error, stackTrace) => print(error));

                    showSnackBar(context, "답변을 등록했습니다.");
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFE37E7E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: const Text(
                    "제출하기",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
