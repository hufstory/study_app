import 'package:flutter/material.dart';
import 'package:login1/loginpage.dart';
import 'package:login1/mainpage.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
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
                      //Navigator.pop(context);
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
                                  decoration: InputDecoration(
                                      labelText: 'Re enter password',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: 40.0,),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //회원가입이 완료된 후 이동하는 페이지
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
