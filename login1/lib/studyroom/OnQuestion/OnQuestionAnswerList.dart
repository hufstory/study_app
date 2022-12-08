import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnQuestionAnswerList extends StatefulWidget {
  final String studyID;
  final String documentID;
  const OnQuestionAnswerList({Key? key, required this.studyID, required this.documentID}) : super(key: key);

  @override
  State<OnQuestionAnswerList> createState() => _OnQuestionAnswerListState();
}

class _OnQuestionAnswerListState extends State<OnQuestionAnswerList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AnswerModel>>(
        stream: streamAnswers(widget.studyID, widget.documentID),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return const Center(child: Text("오류가 발생했습니다."));
          } else {
            List<AnswerModel> answers = asyncSnapshot.data!;
            return Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFFFEDED),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Container( // 프로필 사진이 들어갈 부분입니다
                                    width: 45,
                                    height: 45,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text( // 유저 닉네임이 들어갈 부분입니다
                                      '${answers[index].author}',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text( // 질문 내용이 들어갈 부분입니다
                                  '${answers[index].description}',
                                  style:
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Divider(
                        color: Colors.transparent,
                        thickness: 1.0,
                        height: 1.0,
                      ),
                    );
                  },
// itemCount -> DB에 저장된 질문 개수에 따라 동적인 조정 필요
                  itemCount: answers.length),
            );
          }
        });
  }
}

class AnswerModel {
  final String description;
  final String author;

  AnswerModel({
    this.description = '',
    this.author = '',
  });

  factory AnswerModel.fromMap({required Map<String, dynamic> map}) {
    return AnswerModel(
      description: map['description'] ?? '',
      author: map['author'] ?? '',
    );
  }
}

Stream<List<AnswerModel>> streamAnswers(String studyID, String documentID) {
  final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
      .collection("studyroom")
      .doc(studyID)
      .collection("question")
      .doc(documentID)
      .collection('answer')
      .snapshots();
  return snapshots.map((querySnapshot) {
    List<AnswerModel> answers = [];
    querySnapshot.docs.forEach((element) {
      answers.add(
          AnswerModel.fromMap(map: element.data() as Map<String, dynamic>));
    });
    return answers;
  });
}