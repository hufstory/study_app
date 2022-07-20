import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 가로방향 못돌리게
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffe5cdde), Color(0xff9b7fc1)],
          )),
      child: const MaterialApp(
        title: 'mainpage',
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(27.0),
        child: AppBar(
          title: const Text(' '),
          centerTitle: true,
          backgroundColor: Colors.transparent, // 앱바 투명
          elevation: 0.0,
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
                    children: const [
                      Text('자료구조',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('알고리즘',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('컴퓨팅사고',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('수리통계학',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('선형대수',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              Stack( // 타이머 부분
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
          Stack(alignment: Alignment.center, children: [
            Container(
              // 시간표
              width: 377.1,
              height: 330,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
            ),
            Container(
              // 시간표 안쪽
              width: 365,
              height: 320,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.grey,
                      width: 0.6
                  ),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: const [ // 시간표 가로줄
                  SizedBox(height: 15.0),
                  Divider(thickness: 0.6, color: Colors.grey),
                  SizedBox(height: 25.5),
                  Divider(thickness: 0.6, color: Colors.grey),
                  SizedBox(height: 25.5),
                  Divider(thickness: 0.6, color: Colors.grey),
                  SizedBox(height: 25.5),
                  Divider(thickness: 0.6, color: Colors.grey),
                  SizedBox(height: 25.5),
                  Divider(thickness: 0.6, color: Colors.grey),
                  SizedBox(height: 25.5),
                  Divider(thickness: 0.6, color: Colors.grey),
                  SizedBox(height: 25.5),
                  Divider(thickness: 0.6, color: Colors.grey),
                ],
              ),
            ),
            Container(
              // 시간표 세로선
              width: 365,
              height: 320,
              child: Row(children: const [
                SizedBox(width: 15.0),
                VerticalDivider(color: Colors.grey, thickness: 0.6),
                SizedBox(width: 52),
                VerticalDivider(color: Colors.grey, thickness: 0.6),
                SizedBox(width: 52),
                VerticalDivider(color: Colors.grey, thickness: 0.6),
                SizedBox(width: 52),
                VerticalDivider(color: Colors.grey, thickness: 0.6),
                SizedBox(width: 52),
                VerticalDivider(color: Colors.grey, thickness: 0.6),
              ]),
            ),
            Positioned(
                left: 55,
                top: 6.5,
                child: Container(
                  child: Text('월', style: TextStyle(color: Colors.grey)),
                )
            ),
            Positioned(
                left: 125,
                top: 6.5,
                child: Container(
                  child: Text('화', style: TextStyle(color: Colors.grey)),
                )
            ),
            Positioned(
                left: 192,
                top: 6.5,
                child: Container(
                  child: Text('수', style: TextStyle(color: Colors.grey)),
                )
            ),
            Positioned(
                left: 260,
                top: 6.5,
                child: Container(
                  child: Text('목', style: TextStyle(color: Colors.grey)),
                )
            ),
            Positioned(
                left: 330,
                top: 6.5,
                child: Container(
                  child: Text('금', style: TextStyle(color: Colors.grey)),
                )
            ),
            Positioned(
              left: 20,
              top: 30,
              child: Container(
                child: Text('9', style: TextStyle(color: Colors.grey),),
              ),
            ),
            Positioned(
              left: 12,
              top: 70,
              child: Container(
                child: Text('10', style: TextStyle(color: Colors.grey),),
              ),
            ),
            Positioned(
              left: 12,
              top: 112,
              child: Container(
                child: Text('11', style: TextStyle(color: Colors.grey),),
              ),
            ),
            Positioned(
              left: 12,
              top: 153,
              child: Container(
                child: Text('12', style: TextStyle(color: Colors.grey),),
              ),
            ),
            Positioned(
              left: 20,
              top: 194,
              child: Container(
                child: Text('1', style: TextStyle(color: Colors.grey),),
              ),
            ),
            Positioned(
              left: 19,
              top: 235,
              child: Container(
                child: Text('2', style: TextStyle(color: Colors.grey),),
              ),
            ),
            Positioned(
              left: 19,
              top: 277,
              child: Container(
                child: Text('3', style: TextStyle(color: Colors.grey),),
              ),
            ),
          ],
          ),
        ],
      ),
    );
  }
}
