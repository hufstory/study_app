import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:login1/studyroom/showStudyRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login1/StudyList.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

import 'timer.dart';
import 'dart:math';

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
bool isPlayerOn = false;

String Email = '';
String Name = '';
String songTitle = '비 오는 소리';

Future getUserData() async {
  await db.collection('users').doc(uid!).get().then((user) {
    Email = user.data()!['Email'];
    Name = user.data()!['Name'];
  });
}

var user = FirebaseAuth.instance.currentUser;
var uid = user?.uid;
// var _auth = FirebaseAuth.instance;

Future readStudyData() async {
  await db.collection('users').doc(uid!).get().then((DocumentSnapshot ds) {
    List temp = ds.get('participatingStudyGroup') as List;
    for (var element in temp) {
      docList.add(element);
    }
    readScheduleData();
    readSubjectData();
  });
}

Future readScheduleData() async {
  for (int i = 0; i < docList.length; i++) {
    await db
        .collection('studyroom')
        .doc(docList[i])
        .collection('schedule')
        .get()
        .then((QuerySnapshot qs) {
      for (var doc in qs.docs) {
        scheduleList.add(doc.data());
      }
    });
  }
}

Future readSubjectData() async {
  for (int i = 0; i < docList.length; i++) {
    await db
        .collection('studyroom')
        .doc(docList[i])
        .collection('schedule')
        .get()
        .then((QuerySnapshot qs) {
      for (var doc in qs.docs) {
        subjectList.add(doc['studyName'].toString());
      }
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
    readStudyData();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 가로방향 못돌리게
    return Container(
      // decoration: const BoxDecoration(
      //     image: DecorationImage(image: AssetImage('assets/background.png'))),
      child: const MaterialApp(
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
  String? email = "example.com";
  final player = AudioPlayer();

  playMusic() async {
    // await player.setSource(AssetSource('rain.mp3'));
    if (isPlayerOn) {
      switch (songTitle) {
        case '비 오는 소리' :
          await player.play(AssetSource('rain.mp3'));
          break;
        case '모닥불 소리':
          await player.play(AssetSource('fire.mp3'));
          break;
      }
    } else {
      await player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readStudyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 500)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(27.0),
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
                                  Scaffold.of(context)
                                      .openEndDrawer(); // Drawer 열음
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      backgroundColor: const Color(0xFFF7B5B5),
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
                                    colors: [
                                      Color(0xffe5cdde),
                                      Color(0xff9b7fc1)
                                    ],
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
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 25)),
                            child: Text(
                              getToday(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                // 스터디 목록 부분
                                width: 170,
                                height: 170,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: StreamBuilder<DocumentSnapshot>(
                                      stream: db
                                          .collection('users')
                                          .doc(uid!)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child: Text(
                                            '등록된 스터디가 없습니다.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ));
                                        }
                                        return SingleChildScrollView(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                for (var item in subjectList)
                                                  Text(
                                                    item,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  )
                                              ]),
                                        );
                                      }),
                                ),
                              ),
                              Stack(// 타이머 부분
                                  children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 170,
                                  height: 170,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: Timer(),
                                ),
                              ]),
                            ],
                          ),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       signOut();
                          //       Navigator.of(context).pop(LogIn());
                          //     },
                          //     child: Text("logout")),
                          Container(
                            width: 367.1,
                            height: 40,
                            padding: const EdgeInsets.only(left: 15.0, right: 3.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('📢', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Text(songTitle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 95),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          isPlayerOn = !isPlayerOn;
                                        });
                                        playMusic();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          visualDensity: const VisualDensity(horizontal: -2.0),
                                          elevation: 0.0,
                                          backgroundColor: const Color(0XFFEFEFEF),
                                          shape: const CircleBorder(),
                                          fixedSize: const Size(25, 25)
                                      ),
                                      child: isPlayerOn ? const Icon(Icons.pause, color: Colors.black) : const Icon(Icons.play_arrow, color: Colors.black)),
                                    ElevatedButton(
                                        onPressed: (){
                                          showAdaptiveActionSheet(
                                              context: context,
                                              androidBorderRadius: 30,
                                              actions: <BottomSheetAction>[
                                                BottomSheetAction(title: const Text('비 오는 소리'), onPressed: (context){
                                                  setState(() {
                                                    songTitle = '비 오는 소리';
                                                  });
                                                  Navigator.of(context).pop();
                                                }),
                                                BottomSheetAction(title: const Text('모닥불 소리'), onPressed: (context){
                                                  setState(() {
                                                    songTitle = '모닥불 소리';
                                                  });
                                                  Navigator.of(context).pop();
                                                }),
                                              ],
                                              cancelAction: CancelAction(title: const Text('닫기'))
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            backgroundColor: const Color(0XFFEFEFEF),
                                            shape: const CircleBorder(),
                                            fixedSize: const Size(25, 25)
                                        ),
                                        child: const Icon(Icons.more_horiz, color: Colors.black))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Container(
                                // 시간표
                                width: 367.1,
                                height: 330,
                                padding: const EdgeInsets.all(5.7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: TimeTable(
                                  subjectList1: [...subjectList],
                                ),
                              ),
                              Positioned(
                                left: 6,
                                top: -9,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        fixedSize: const Size(20, 20),
                                        minimumSize: const Size(20, 20),
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const StudyList()));
                                    },
                                    child: const Icon(Icons.add,
                                        color: Colors.black, size: 15)),
                              ),
                            ],
                          ),
                        ],
                      ));
                });
          }
        });
  }
}

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key, required this.subjectList1}) : super(key: key);

  final List subjectList1; // 스터디 과목 리스트
  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: db.collection('users').doc(uid!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (subjectList.isEmpty) {
            return const Center(
                child: Text(
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
                              studyID: docList[i],
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
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
              textStyle: const TextStyle(fontSize: 12, color: Colors.white),
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
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => StudyRoom(
                              studyID: docList[i],
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
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
              textStyle: const TextStyle(fontSize: 12, color: Colors.white),
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
                              studyID: docList[i],
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
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
              textStyle: const TextStyle(fontSize: 12, color: Colors.white),
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
                              studyID: docList[i],
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
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
              textStyle: const TextStyle(fontSize: 12, color: Colors.white),
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
                              studyID: docList[i],
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
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
              textStyle: const TextStyle(fontSize: 12, color: Colors.white),
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


