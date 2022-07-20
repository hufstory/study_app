import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'Hufstudy', home: LogIn());
  }
}

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(239, 249, 249, 249),
        body: Padding(
          padding: const EdgeInsets.only(top: 130.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 120.0,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/mimoticon.png'),
                          radius: 100.0,
                        ))), //프로필 사진
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 35,
                        ),
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
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.redAccent))),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
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
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Sign in'),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FlatButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Forgot password',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                        )),
                                    FlatButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.blue),
                                        ))
                                  ],
                                )
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
