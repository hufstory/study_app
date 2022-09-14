import 'package:flutter/material.dart';
import 'package:login1/bar_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class statistics extends StatefulWidget {
  const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateFormat month_dayFormatter = DateFormat('M/d');
  DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  List<int> studyTimes = [];
  List<String> studyDates = [];

  get data => null;

  @override
  Widget build(BuildContext context) {
    final start = formatter.format(dateRange.start);
    final end = formatter.format(dateRange.end);

    return Scaffold(
        backgroundColor: const Color.fromARGB(239, 230, 230, 230),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  primary: Colors.black,
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
              const SizedBox(height: 30),

              Container(//달력 부분
                decoration: BoxDecoration(
                  color: const Color.fromARGB(239, 217, 217, 217),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TableCalendar(
                  rowHeight: 35.0,
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(1999,01,01), //사용자가 접근할 수 있는 첫 번째 날짜
                  lastDay: DateTime(9999,12,31),
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    headerPadding: EdgeInsets.symmetric(vertical: 4.0),
                    leftChevronIcon: Icon(
                      Icons.arrow_left,
                      size: 40.0,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_right,
                      size: 40.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(239, 217, 217, 217),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    child: Text('${start} ~ ${end}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                    ),
                    ),
                  onPressed: pickDateRange,
                )
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 108, 141, 255),
                  onPrimary: Colors.black,
                ),

                child: const Text('Search'),
                onPressed: () async {
                  studyDates = [];
                  studyTimes = [];
                  
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  List<String> dates = [];
                  int duration = dateRange.duration.inHours;
                  
                  while(duration >= 0) {
                    dates.add(formatter.format(dateRange.end.subtract(new Duration(hours: duration))));
                    studyDates.add(month_dayFormatter.format(dateRange.end.subtract(new Duration(hours: duration))));
                    duration -= 24;
                  }

                  List<int> times = [];
                  for(int i = 0; i < dates.length; i++) {
                    await FirebaseFirestore.instance.collection('users').doc(uid).collection('studyTime').doc(dates[i]).get().then(
                        (doc) => {
                          if(doc.data() != null) {times.add(doc.data()!['studyTime'])}
                          else{times.add(0)}
                        }
                    );
                  }
                  studyTimes = times;
                  print(studyDates);
                  print(studyTimes);
                }
              ),
              // Container(
              //   child: Column(
              //     children: [
              //       SizedBox(
              //         height: 40.0,
              //       ),
              //       Container(
              //         color: Colors.black,
              //         margin: EdgeInsets.symmetric(vertical: 20.0),
              //         child: SingleChildScrollView(
              //             scrollDirection: Axis.horizontal,
              //             child: Container(
              //               child: CustomPaint(
              //                 size: Size(300, 300),
              //                 foregroundPainter: BarChart(
              //                   data: studyTimes,
              //                   labels: studyDates,
              //                 ),
              //               ),
              //             )
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      )
    );
  }
  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      initialDateRange: dateRange
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}


