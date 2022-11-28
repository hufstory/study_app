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
  final questions = FirebaseFirestore.instance
      .collection("studyroom")
      .doc("7HvZizNSwWGTnlSrAGQ0")
      .collection("question");

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<QuestionModel>>(
      stream: streamQuestions(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (asyncSnapshot.hasError) {
          return const Center(child: Text("오류가 발생했습니다."));
        } else {
          List<QuestionModel> questions = asyncSnapshot.data!;
          return Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, // 질문 상세 및 전체 답변 페이지 이동
                          MaterialPageRoute(
                              builder: (context) => const OnQuestion()));
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    // 유저 닉네임이 들어갈 부분입니다.
                                    '${questions[index].author}',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              // 질문 내용이 들어갈 부분입니다.
                              questions[index].description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
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
                                              builder: (context) =>
                                                  const AnswerPage()));
                                    },
                                    style: OutlinedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        side: const BorderSide(
                                            color: Colors.white),
                                        backgroundColor:
                                            const Color(0xFFFFEDED)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Icon(
                                          Icons
                                              .subdirectory_arrow_right_rounded,
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
                itemCount: questions.length),
          );
        }
      },
    );
  }
}

class QuestionModel {
  final String title;
  final String description;
  final String author;

  QuestionModel({
    this.title = '',
    this.description = '',
    this.author = '',
  });

  factory QuestionModel.fromMap({required Map<String, dynamic> map}) {
    return QuestionModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      author: map['author'] ?? '',
    );
  }
}

Stream<List<QuestionModel>> streamQuestions() {
  final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
      .collection("studyroom")
      .doc("7HvZizNSwWGTnlSrAGQ0")
      .collection("question")
      .snapshots();
  return snapshots.map((querySnapshot) {
    List<QuestionModel> questions = [];
    querySnapshot.docs.forEach((element) {
      questions.add(
          QuestionModel.fromMap(map: element.data() as Map<String, dynamic>));
    });
    return questions;
  });
}
