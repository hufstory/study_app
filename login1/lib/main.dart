import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login1/mainpage.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

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
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String Email = '';
  String PW = '';
  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if(isValid) {
      _formKey.currentState!.save();
    }
  }
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
                    key: _formKey,
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
                                TextFormField(
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
                                TextFormField(
                                  key: ValueKey(2),
                                  validator: (value) {
                                    if(value!.isEmpty || value.length < 6) {
                                      return '암호는 최소 6자입니다.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    PW = value!;
                                  },
                                  onChanged: (value) {
                                    PW = value;
                                  },
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
                                    onPressed: () async {
                                      _tryValidation();
                                      try {
                                        final User = await _authentication.signInWithEmailAndPassword(
                                          email: Email,
                                          password: PW,
                                        );
                                        if(User.user != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return mainPage();
                                                  }));
                                        }
                                      } catch(err) {
                                        print(err);
                                      }
                                    },
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
                                        onPressed: () async {
                                          _tryValidation();
                                          try {
                                            final newUser = await _authentication
                                                .createUserWithEmailAndPassword(
                                              email: Email,
                                              password: PW,
                                            );
                                            if(newUser.user == null) {print('계정 등록 실패');}
                                          } catch(err) {
                                            print(err);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content:
                                                    Text('이메일과 암호가 올바른 형식인지 확인해 주세요'),
                                                  backgroundColor: Colors.blue,
                                                )
                                            );
                                          }
                                        },
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