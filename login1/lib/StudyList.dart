import 'package:flutter/material.dart';
import 'package:login1/AddStudy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUpPage.dart';

String? studyName;
String? members;
String? memberLimit;

class StudyList extends StatefulWidget {
  const StudyList({Key? key}) : super(key: key);

  @override
  State<StudyList> createState() => _StudyListState();
}

class _StudyListState extends State<StudyList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StudyRoomModel>>(
        stream: streamQuestions(),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return const Center(child: Text("오류가 발생했습니다."));
          } else {
            List<StudyRoomModel> studyRooms = asyncSnapshot.data!;
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 50),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: const BoxDecoration(color: Color(0XFFF7B5B5)),
                    child: Column(
                      children: [
                        Container(
                          width: 370,
                          height: 70,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          color: const Color(0XFFFFEDED),
                          child: Column(
                            children: [
                              Text('과목명: ${studyName ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              Text('참여인원: ${members ?? ''}/${memberLimit ?? ''} (명)',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                            onPressed: () {

                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0XFFE37E7E),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                fixedSize: const Size(100, 40)),
                            child: const Text('추가하기',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(10),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 25,
                                  ),
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
                                elevation: 0.5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: const Color(0xFFFFEDED),
                                fixedSize: const Size(30, 40)),
                            child: const Text(
                              '검색',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 268,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    decoration: const BoxDecoration(color: Color(0XFFFFEDED)),
                    child: Stack(
                      children: [
                        ListView.separated(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // 탭하면 위에 과목명, 참여인원 출력
                                  List<String> studyList = [];

                                  await db
                                      .collection('users')
                                      .doc(uid!)
                                      .get()
                                      .then((user) {
                                    studyList = user
                                        .data()!['participatingStudyGroup']
                                        ?.cast<String>();
                                  });

                                  studyList.add(studyRooms[index].studyID);

                                  await db
                                      .collection('users')
                                      .doc(uid!)
                                      .update({
                                    'participatingStudyGroup': studyList,
                                  });
                                  setState(() {
                                    studyName = studyRooms[index].subjectName;
                                    members = studyRooms[index].members;
                                    memberLimit = studyRooms[index].memberLimit;
                                  });
                                  showSnackBar(context, "스터디그룹에 가입했습니다.");
                                  print(studyRooms[index].studyID.runtimeType);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0XFFF7B5B5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '과목명 : ${studyRooms[index].subjectName}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17)),
                                            Text(
                                                '참여인원: ${studyRooms[index].members}/${studyRooms[index].memberLimit} (명)',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17))
                                          ]),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 6, top: 3, bottom: 3),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 29,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                            '${studyRooms[index].studyIntro}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Padding(
                                  padding: EdgeInsets.only(top: 15));
                            },
                            itemCount: studyRooms.length),
                        Positioned(
                          right: -13,
                          top: -13,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(3),
                                  alignment: Alignment.center,
                                  fixedSize: const Size(20, 20),
                                  minimumSize: const Size(20, 20),
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (context) => AddStudy()));
                              },
                              child: const Icon(Icons.add,
                                  color: Colors.black, size: 15)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}

class StudyRoomModel {
  final String subjectName;
  final String members;
  final String memberLimit;
  final String studyIntro;
  final String studyID;

  StudyRoomModel({
    this.subjectName = '',
    this.members = '',
    this.memberLimit = '',
    this.studyIntro = '',
    this.studyID = '',
  });

  factory StudyRoomModel.fromMap({required Map<String, dynamic> map}) {
    return StudyRoomModel(
      subjectName: map['subjectName'] ?? '',
      members: map['members'] ?? '',
      memberLimit: map['memberLimit'] ?? '',
      studyIntro: map['studyIntro'] ?? '',
      studyID: map['studyID'] ?? '',
    );
  }
}

Stream<List<StudyRoomModel>> streamQuestions() {
  final Stream<QuerySnapshot> snapshots =
      FirebaseFirestore.instance.collection("studyroom").snapshots();
  return snapshots.map((querySnapshot) {
    List<StudyRoomModel> questions = [];
    querySnapshot.docs.forEach((element) {
      questions.add(
          StudyRoomModel.fromMap(map: element.data() as Map<String, dynamic>));
    });
    return questions;
  });
}
