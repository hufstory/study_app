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
                  color: Color(0xFFFFEDED),
                ),
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            color: Colors.blue,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'USER',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const Text(
                        '테스트용 문장입니다',
                        style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          itemCount: 4),
    );
  }
}
