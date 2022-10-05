import 'package:flutter/material.dart';


class modifypage extends StatefulWidget {
  const modifypage({Key? key}) : super(key: key);

  @override
  State<modifypage> createState() => _modifypageState();
}

class _modifypageState extends State<modifypage> {

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
                  },
                  child: Text('Back'),
                ),

                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 120.0,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('assets/mimoticon.png'),
                                    radius: 100.0,
                                  ))),

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
                                        labelText: 'Modify Password',
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
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 40.0,),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text('modify'),
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
                ),
              ],
            ),
          ),
        ));
  }
}