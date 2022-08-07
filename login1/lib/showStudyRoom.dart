import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudyRoom extends StatefulWidget {
  const StudyRoom({Key? key}) : super(key: key);

  @override
  State<StudyRoom> createState() => _StudyRoomState();
}

class _StudyRoomState extends State<StudyRoom> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          '✅ 스터디룸 규칙',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                          '💖 공지사항',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Positioned(
                            top: -5,
                            right: 10,
                            child: TextButton(
                              onPressed: (){},
                              child: Text('+더 보기', style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15
                              ),),
                            )
                        )
                      ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            '💖 질문',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Positioned(
                            top: -5,
                            right: 10,
                            child: TextButton(
                              onPressed: (){},
                              child: Text('+더 보기', style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15
                              ),),
                            )
                        )
                      ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            '💖 수다',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Positioned(
                            top: -5,
                            right: 10,
                            child: TextButton(
                              onPressed: (){},
                              child: Text('+더 보기', style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15
                              ),),
                            )
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }
}
