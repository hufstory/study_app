import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
List<String> subjectList = [];
List<String> dayList = [];
List docList = [];
var user = FirebaseAuth.instance.currentUser;
var uid = user?.uid;

readData() async {
  // 과목명 불러오기
  db.collection(uid!).snapshots().listen(
        (QuerySnapshot qs) {
      qs.docs.forEach((doc) => subjectList.add(doc["subject"]));
      qs.docs.forEach((doc) => dayList.add(doc["day"]));
    },
  );
  db.collection(uid!).snapshots().listen((QuerySnapshot qs) {
    qs.docs.forEach((doc) => docList.add(doc.data()));
    print(docList[0]);
  });

  print(subjectList);
}

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);


  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  void initState() {
    super.initState();
    readData();
  }
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 가로방향 못돌리게
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/background.png'))
      ),
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
      backgroundColor: Colors.transparent,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
                      children: subjectList.map((e) => Text(e)).toList()),
                ),
              ),
              Stack(// 타이머 부분
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 15.0, right: 25.0),
                      alignment: Alignment.bottomRight,
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: RichText(
                        text: const TextSpan(
                            text: '3',
                            style: TextStyle(
                                color: Color(0xff645E5E),
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: 'H',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' 47',
                                  style: TextStyle(
                                      color: Color(0xff645E5E),
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'M',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ),
                    Image.asset('assets/flower.png', width: 120, height: 120)
                  ]),
            ],
          ),
          Container(
            // audio player
            width: 377.1,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        fixedSize: const Size(30, 30),
                        shape: const CircleBorder(),
                        elevation: 0.0),
                    child: const Icon(Icons.play_arrow)),
                const Text(
                  '비 내리는 소리.mp3',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                // 시간표
                width: 377.1,
                height: 330,
                padding: EdgeInsets.all(5.7),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                child: subjectList.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : TimeTable(
                  subjectList1: [...subjectList],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeTable extends StatefulWidget {
  TimeTable({Key? key, required this.subjectList1}) : super(key: key);

  final List subjectList1; // 스터디 과목 리스트

  List<String> dayList = ['월', '화', '수', '목', '금'];

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
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
  }

  List<TableEvent> _buildTableEvent() {
    return [
      TableEvent(
          title: widget.subjectList1[0].toString(),
          start: TableEventTime(
              hour: docList[0]["startHour"], minute: docList[0]["startMin"]),
          end: TableEventTime(
              hour: docList[0]["endHour"], minute: docList[0]["endMin"]),
          decoration: BoxDecoration(color: Colors.blue),
          textStyle: TextStyle(fontSize: 12),
          padding: EdgeInsets.all(3.0))
    ];
  }

  List<LaneEvents> _buildLaneEvents() {
    return [
      LaneEvents(
          lane: Lane(
              name: widget.dayList[0].toString(),
              width: 60,
              textStyle: TextStyle(color: Colors.grey)),
          events: _buildTableEvent()),
      LaneEvents(
          lane: Lane(
              name: widget.dayList[1].toString(),
              width: 60,
              textStyle: TextStyle(color: Colors.grey)),
          events: _buildTableEvent()),
      LaneEvents(
          lane: Lane(
              name: widget.dayList[2].toString(),
              width: 60,
              textStyle: TextStyle(color: Colors.grey)),
          events: _buildTableEvent()),
      LaneEvents(
          lane: Lane(
              name: widget.dayList[3].toString(),
              width: 60,
              textStyle: TextStyle(color: Colors.grey)),
          events: _buildTableEvent()),
      LaneEvents(
          lane: Lane(
              name: widget.dayList[4].toString(),
              width: 60,
              textStyle: TextStyle(color: Colors.grey)),
          events: _buildTableEvent()),
    ];
  }
}