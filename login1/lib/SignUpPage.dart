import 'package:flutter/material.dart';
import 'package:login1/loginpage.dart';
import 'package:login1/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _authentication = FirebaseAuth.instance;
  TextEditingController Name = TextEditingController();
  TextEditingController NickName = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController Password2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(239, 249, 249, 249),
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 18),
                    primary: Colors.black,
                  ),
                    onPressed: (){
                      Navigator.pop(context);
                      //네비게이터로 로그인페이지(signup버튼)와 signup페이지를 연동시킬 예정
                    },
                    child: Text('Back'),
                ),

                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(
                              primaryColor: Colors.teal,
                              inputDecorationTheme: InputDecorationTheme(
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              )),
                          child: Container(
                            child: Column(
                              children: [
                                TextField(
                                  controller: Name,
                                  decoration: InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: 40.0,),
                                TextField(
                                  controller: NickName,
                                  decoration: InputDecoration(
                                      labelText: 'NickName',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: 40.0,),
                                TextField(
                                  controller: Email,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 40.0,),
                                TextField(
                                  controller: Password,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                ),
                                SizedBox(height: 40.0,),
                                TextField(
                                  controller: Password2,
                                  decoration: InputDecoration(
                                      labelText: 'Re enter password',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                ),
                                SizedBox(height: 40.0,),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      //회원가입이 완료된 후 이동하는 페이지
                                      if(Name.text.isEmpty) {
                                        showSnackBar(context, "이름을 입력해주세요.");
                                      }
                                      else if(NickName.text.isEmpty) {
                                        showSnackBar(context, "닉네임을 입력해주세요.");
                                      }
                                      else if(Email.text.isEmpty || !Email.text.contains('@')) {
                                        showSnackBar(context, "올바른 이메일 형식이 아닙니다.");
                                      }
                                      else if(Password.text.isEmpty) {
                                        showSnackBar(context, "암호를 입력해주세요.");
                                      }
                                      else if(Password.text != Password2.text) {
                                        showSnackBar(context, "암호가 서로 일치하지 않습니다.");
                                      }
                                      else {
                                        try {
                                          final newUser = await _authentication
                                              .createUserWithEmailAndPassword(
                                            email: Email.text,
                                            password: Password.text,
                                          );
                                          if (newUser.user == null) {
                                            showSnackBar(context, '계정 등록 실패');
                                            print('계정 등록 실패');
                                            return;
                                          }
                                          // db.collection('user')
                                          //     .doc(uid!)
                                          //     .collection('study')
                                          //     .add({
                                          //       'subject': 'test',
                                          //       'day': '월',
                                          //       'startHour': 9,
                                          //       'startMin': 30,
                                          //       'endHour': 11,
                                          //       'endMin': 20
                                          //     });
                                          FirebaseFirestore.instance.collection('users').doc('${newUser.user!.uid}').set({
                                            'Email': Email.text,
                                            'Nickname': NickName.text,
                                            'Name': Name.text,
                                            'participatingStudyGroup': [],
                                          });
                                          Navigator.pop(context);
                                        } catch (err) {
                                          print(err);
                                        }
                                      }
                                    },
                                    child: Text('Sign up'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text('$msg'),
        backgroundColor: Colors.blue,
      )
  );
}