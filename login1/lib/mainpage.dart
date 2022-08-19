import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:login1/showStudyRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login1/loginpage.dart';

import 'timer.dart';

import 'package:intl/intl.dart';

String getToday() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  var strToday = formatter.format(now);
  return strToday;
}

FirebaseFirestore db = FirebaseFirestore.instance;
Set<String> subjectList = {};
List docList = [];
List scheduleList = [];

var user = FirebaseAuth.instance.currentUser;
var uid = user?.uid;
var _auth = FirebaseAuth.instance;

readStudyData() {
  db.collection('users').doc(uid!).snapshots().listen((DocumentSnapshot ds) {
    // docList.add(ds.get('study'));
    List temp = ds.get('study') as List;
    temp.forEach((element) {
      docList.add(element);
    });
    print('len: ${docList.length}');
    print('UID: $uid');
    readScheduleData();
    readSubjectData();
  });
}

readScheduleData() {
  for (int i = 0; i < docList.length; i++) {
    db
        .collection('studyroom')
        .doc(docList[i])
        .collection('schedule')
        .snapshots()
        .listen((QuerySnapshot qs) {
      qs.docs.forEach((doc) => scheduleList.add(doc.data()));
    });
  }
}

readSubjectData() {
  for (int i = 0; i < docList.length; i++) {
    db
        .collection('studyroom')
        .doc(docList[i])
        .collection('schedule')
        .snapshots()
        .listen((QuerySnapshot qs) {
      qs.docs.forEach((doc) => subjectList.add(doc['studyName'].toString()));
      print(subjectList);
    });
  }
}

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  initState() {
    super.initState();
    readStudyData();
    print(docList);
    setState(() {});
    // setState(() {});
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 가로방향 못돌리게
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/background.png'))),
      child: MaterialApp(
        title: 'mainpage',
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(27.0),
        child: AppBar(
          title: const Text(' '),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          // 앱바 투명
          elevation: 0.0,
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
      backgroundColor: Colors.transparent,
      body: StreamBuilder<DocumentSnapshot>(
          stream: db.collection('users').doc(uid!).snapshots().asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    getToday(),
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 25)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // 스터디 목록 부분
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        image: DecorationImage(
                          image: AssetImage('assets/grass.png'),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subjectList
                                .map((e) => Text(
                                      e,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ))
                                .toList()),
                      ),
                    ),
                    Stack(// 타이머 부분
                        children: [
                      Container(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, right: 25.0),
                        alignment: Alignment.bottomRight,
                        width: 180,
                        height: 180,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Timer(),
                      ),
                      // Image.asset(
                      //     'assets/flower.png', width: 120, height: 120)
                    ]),
                  ],
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       signOut();
                //       Navigator.of(context).pop(LogIn());
                //     },
                //     child: Text("logout")),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      // 시간표
                      width: 377.1,
                      height: 330,
                      padding: const EdgeInsets.all(5.7),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TimeTable(
                        subjectList1: [...subjectList],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}

class TimeTable extends StatefulWidget {
  TimeTable({Key? key, required this.subjectList1}) : super(key: key);

  final List subjectList1; // 스터디 과목 리스트
  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: db.collection('users').doc(uid!).snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
                child: const Text(
              '등록된 스터디가 없습니다.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ));
          }
          return TimetableView(
            laneEventsList: _buildLaneEvents(),
            timetableStyle: const TimetableStyle(
                startHour: 9,
                endHour: 19,
                laneWidth: 62,
                laneHeight: 20,
                decorationLineBorderColor: Colors.grey,
                timeItemTextColor: Colors.grey,
                timeItemHeight: 45,
                timeItemWidth: 50),
          );
        });
  }

  _buildTableEvent1() {
    var isNull = true;
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]["day"] == "월") {
        isNull = false;
        return [
          TableEvent(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyRoom(
                              studyID: docList[0][i],
                              studyName: scheduleList[i]["studyName"],
                            )));
              },
              title: scheduleList[i]["studyName"].toString(),
              start: TableEventTime(
                  hour: scheduleList[i]["startHour"],
                  minute: scheduleList[i]["startMin"]),
              end: TableEventTime(
                  hour: scheduleList[i]["endHour"],
                  minute: scheduleList[i]["endMin"]),
              decoration: const BoxDecoration(color: Colors.blue),
              textStyle: const TextStyle(fontSize: 13),
              padding: const EdgeInsets.all(3.0)),
        ];
      }
    }
    if (isNull == true) {
      List<TableEvent> temp = [];
      return temp;
    }
  }

  _buildTableEvent2() {
    var isNull = true;
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]["day"] == "화") {
        isNull = false;
        return [
          TableEvent(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyRoom(
                              studyID: docList[0][i],
                              studyName: scheduleList[i]["studyName"],
                            )));
              },
              title: scheduleList[i]["studyName"].toString(),
              start: TableEventTime(
                  hour: scheduleList[i]["startHour"],
                  minute: scheduleList[i]["startMin"]),
              end: TableEventTime(
                  hour: scheduleList[i]["endHour"],
                  minute: scheduleList[i]["endMin"]),
              decoration: const BoxDecoration(color: Colors.blue),
              textStyle: const TextStyle(fontSize: 13),
              padding: const EdgeInsets.all(3.0))
        ];
      }
    }
    if (isNull == true) {
      List<TableEvent> temp = [];
      return temp;
    }
  }

  _buildTableEvent3() {
    var isNull = true;
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]["day"] == "수") {
        isNull = false;
        return [
          TableEvent(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyRoom(
                              studyID: docList[0][i],
                              studyName: scheduleList[i]["studyName"],
                            )));
              },
              title: scheduleList[i]["studyName"].toString(),
              start: TableEventTime(
                  hour: scheduleList[i]["startHour"],
                  minute: scheduleList[i]["startMin"]),
              end: TableEventTime(
                  hour: scheduleList[i]["endHour"],
                  minute: scheduleList[i]["endMin"]),
              decoration: const BoxDecoration(color: Colors.blue),
              textStyle: const TextStyle(fontSize: 13),
              padding: const EdgeInsets.all(3.0))
        ];
      }
    }
    if (isNull == true) {
      List<TableEvent> temp = [];
      return temp;
    }
  }

  _buildTableEvent4() {
    var isNull = true;
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]["day"] == "목") {
        isNull = false;
        return [
          TableEvent(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyRoom(
                              studyID: docList[0][i],
                              studyName: scheduleList[i]["studyName"],
                            )));
              },
              title: scheduleList[i]["studyName"].toString(),
              start: TableEventTime(
                  hour: scheduleList[i]["startHour"],
                  minute: scheduleList[i]["startMin"]),
              end: TableEventTime(
                  hour: scheduleList[i]["endHour"],
                  minute: scheduleList[i]["endMin"]),
              decoration: const BoxDecoration(color: Colors.blue),
              textStyle: const TextStyle(fontSize: 13),
              padding: const EdgeInsets.all(3.0))
        ];
      }
    }
    if (isNull == true) {
      List<TableEvent> temp = [];
      return temp;
    }
  }

  _buildTableEvent5() {
    var isNull = true;
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]["day"] == "금") {
        isNull = false;
        return [
          TableEvent(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudyRoom(
                              studyID: docList[0][i],
                              studyName: scheduleList[i]["studyName"],
                            )));
              },
              title: scheduleList[i]["studyName"].toString(),
              start: TableEventTime(
                  hour: scheduleList[i]["startHour"],
                  minute: scheduleList[i]["startMin"]),
              end: TableEventTime(
                  hour: scheduleList[i]["endHour"],
                  minute: scheduleList[i]["endMin"]),
              decoration: const BoxDecoration(color: Colors.blue),
              textStyle: const TextStyle(fontSize: 13),
              padding: const EdgeInsets.all(3.0))
        ];
      }
    }
    if (isNull == true) {
      List<TableEvent> temp = [];
      return temp;
    }
  }

  List<LaneEvents> _buildLaneEvents() {
    return [
      LaneEvents(
          lane: Lane(
              name: '월',
              width: 60,
              textStyle: const TextStyle(color: Colors.grey)),
          events: _buildTableEvent1()),
      LaneEvents(
          lane: Lane(
              name: '화',
              width: 60,
              textStyle: const TextStyle(color: Colors.grey)),
          events: _buildTableEvent2()),
      LaneEvents(
          lane: Lane(
              name: '수',
              width: 60,
              textStyle: const TextStyle(color: Colors.grey)),
          events: _buildTableEvent3()),
      LaneEvents(
          lane: Lane(
              name: '목',
              width: 60,
              textStyle: const TextStyle(color: Colors.grey)),
          events: _buildTableEvent4()),
      LaneEvents(
          lane: Lane(
              name: '금',
              width: 60,
              textStyle: const TextStyle(color: Colors.grey)),
          events: _buildTableEvent5()),
    ];
  }
}

Future signOut() async {
  try {
    return await _auth.signOut();
  } catch (e) {
    print('error: $e');
    return null;
  }
}
