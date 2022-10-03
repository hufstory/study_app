import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_charts/flutter_charts.dart';



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
  int averageStudyTime = 0;
  int maxStudyTime = 0;

  get data => null;

  @override
  Widget build(BuildContext context) {
    final start = formatter.format(dateRange.start);
    final end = formatter.format(dateRange.end);

    return Scaffold(
        backgroundColor: const Color.fromARGB(239, 230, 230, 230),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),

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
              ), //달력

              const SizedBox(height: 20),

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
              ), //날짜를 선택할 수 있는 박스

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 108, 141, 255),
                    onPrimary: Colors.black,
                  ),

                  child: const Text('Search'),
                  onPressed: () async {
                    List<String> study_dates = [];

                    final uid = FirebaseAuth.instance.currentUser!.uid;
                    List<String> dates = [];
                    int duration = dateRange.duration.inHours;

                    while(duration >= 0) {
                      dates.add(formatter.format(dateRange.end.subtract(new Duration(hours: duration))));
                      study_dates.add(month_dayFormatter.format(dateRange.end.subtract(new Duration(hours: duration))));
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

                    int total = 0;
                    int max = 0;

                    for(int i = 0; i < times.length; i++) {
                      total += times[i];
                      if(max < times[i]) max = times[i];
                    }

                    setState(() {
                      studyDates = study_dates;
                      studyTimes = times;
                      averageStudyTime = (total / times.length).round();
                      maxStudyTime = max;
                    });

                    print(studyDates);
                    print(studyTimes);

                  }
                ),
              ),  //search 버튼

              const SizedBox(height: 20),

              Container(
                //alignment: Alignment.center,
                height: 330.0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(studyTimes.isNotEmpty && studyDates.isNotEmpty)...[
                        Expanded(child: chartToRun(studyTimes, studyDates))
                      ]
                      else...[
                        SizedBox(height: 30.0),
                      ]
                    ],
                  )
                ),
              ),  //도표

              const SizedBox(height: 20),
              
              Container(
                width:double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      //width: 160,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(239, 217, 217, 217),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        child: Text('평균 공부시간 : ${(averageStudyTime / 60).floor()}H ${averageStudyTime % 60}M',
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 13
                        ),),
                        onPressed: (){},

                      )
                      ),

                    const SizedBox(width: 10),

                    Container(
                        //width: 160,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(239, 217, 217, 217),
                            borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        child: Text('최대 공부시간 : ${(maxStudyTime / 60).floor()}H ${maxStudyTime % 60}M',
                          style: TextStyle(
                          color: Colors.black,
                            fontSize: 13
                        ),),
                        onPressed: (){},
                      ),
                    ),
                  ],
                ),
              )
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
Widget chartToRun(List<int> data, List<String> xLabel) {
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();
  // Example with side effects cannot be simply pasted to your code, as the _ExampleSideEffects is private
  // This example shows the result with sufficient space to show all labels
  chartData = ChartData(
    dataRowsColors: const[Colors.blue],
    dataRows: [data.map((element) => element.toDouble()).toList()],
    xUserLabels: xLabel,
    dataRowsLegends: const [
      '사용 시간',
    ],
    chartOptions: chartOptions,
  );
  // exampleSideEffects = _ExampleSideEffects()..leftSqueezeText=''.. rightSqueezeText='';
  var verticalBarChartContainer = VerticalBarChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var verticalBarChart = VerticalBarChart(
    painter: VerticalBarChartPainter(
      verticalBarChartContainer: verticalBarChartContainer,
    ),
  );
  return verticalBarChart;
}


