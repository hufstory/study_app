import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AnswerPage.dart';
import '../OnQuestion/OnQuestion.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({Key? key}) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  final questions = FirebaseFirestore.instance.collection("studyroom").doc("7HvZizNSwWGTnlSrAGQ0").collection("question");

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context, // 질문 상세 및 전체 답변 페이지 이동
                    MaterialPageRoute(builder: (context) => OnQuestion()));
              },
              child: Container(
                height: 160,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            // 프로필 사진이 들어갈 부분입니다.
                            width: 45,
                            height: 45,
                            color: Colors.blue,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              // 유저 닉네임이 들어갈 부분입니다.
                              'USER',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const Text(
                        // 질문 내용이 들어갈 부분입니다.
                        '테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          height: 26,
                          width: MediaQuery.of(context).size.width - 20,
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        // 클릭 시 답변페이지로 이동
                                        builder: (context) => AnswerPage()));
                              },
                              style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  side: const BorderSide(color: Colors.white),
                                  backgroundColor: const Color(0xFFFFEDED)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.subdirectory_arrow_right_rounded,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '이곳을 클릭하여 답변을 해보세요.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.only(left: 7.0, right: 7.0),
              child: Divider(
                color: Color(0xFFECECEC),
                thickness: 1.0,
                height: 1.0,
              ),
            );
          },
          itemCount: 4),
    );
  }
}
