import 'package:flutter/material.dart';

class OnQuestionAnswerList extends StatefulWidget {
  const OnQuestionAnswerList({Key? key}) : super(key: key);

  @override
  State<OnQuestionAnswerList> createState() => _OnQuestionAnswerListState();
}

class _OnQuestionAnswerListState extends State<OnQuestionAnswerList> {
  @override
  Widget build(BuildContext context) {
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
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text( // 유저 닉네임이 들어갈 부분입니다
                              'USER',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text( // 질문 내용이 들어갈 부분입니다
                          '테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다테스트용 문장입니다',
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
          itemCount: 4),
    );
  }
}
