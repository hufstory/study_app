import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login1/SignUpPage.dart';

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

class AddStudy extends StatefulWidget {
  const AddStudy({Key? key}) : super(key: key);

  @override
  State<AddStudy> createState() => _AddStudyState();
}

List<String> dropdown = [for (var i = 2; i <= 100; i++) i.toString()];
String selectedDropdown = '2';

class _AddStudyState extends State<AddStudy> {
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _studyRuleController = TextEditingController();
  final TextEditingController _studyIntroController = TextEditingController();
  String _subjectName = '';
  String _studyRule = '';
  String _studyIntro = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }
  
  @override
  void dispose() {
    _subjectNameController.dispose();
    _studyRuleController.dispose();
    _studyIntroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(dropdown);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              builder: (context) =>
                  IconButton(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Stack(
                children: [
                  Positioned(
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
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
                            color: const Color(0xFFF7B5B5),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          '과목 추가하기',
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
                          child: const Text('📝️',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30))))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('과목명',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
              child: Container(
                alignment: AlignmentDirectional.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEDED),
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 30,
                  child: TextField(
                    controller: _subjectNameController,
                    onChanged: (value) {
                      setState(() {
                        _subjectName = value;
                      });
                    },
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
              child: Text('정원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
              child: Container(
                alignment: AlignmentDirectional.center,
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEDED),
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonFormField(
                        alignment: Alignment.center,
                        menuMaxHeight: 250,
                        value: selectedDropdown,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDropdown = newValue!;
                          });
                        },
                        items: dropdown.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value)
                              );
                            }
                        ).toList(),
                      ),
                    )
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('스터디 규칙',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
              child: Container(
                alignment: AlignmentDirectional.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 200,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEDED),
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 30,
                  height: 190,
                  child: TextField(
                    controller: _studyRuleController,
                    onChanged: (value) {
                      setState(() {
                        _studyRule = value;
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
              child: Text('스터디 한 줄 소개',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
              child: Container(
                alignment: AlignmentDirectional.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEDED),
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 30,
                  child: TextField(
                    controller: _studyIntroController,
                    onChanged: (value) {
                      setState(() {
                        _studyIntro = value;
                      });
                    },
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
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () async {
                    await db.collection("studyroom").doc().set({
                      "subjectName": _subjectName,
                      "studyRule": _studyRule,
                      "studyIntro": _studyIntro,
                      "memberLimit": selectedDropdown,
                    });

                    showSnackBar(context, "스터디그룹을 등록했습니다.");
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0XFFE37E7E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(100, 40)),
                  child: const Text('저장하기',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }
}
