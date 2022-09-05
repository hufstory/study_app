import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class statistics extends StatefulWidget {
  const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  get data => null;

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

    return Scaffold(
        backgroundColor: Color.fromARGB(239, 230, 230, 230),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 18),
                  primary: Colors.black,
                ),
                onPressed: (){
                  //Navigator.pop(context);
                },
                child: Text('Back'),
              ),
              SizedBox(height: 30,),

              Container(//달력 부분
                decoration: BoxDecoration(
                  color:Color.fromARGB(239, 217, 217, 217),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TableCalendar(
                  rowHeight: 35.0,
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(1999,01,01), //사용자가 접근할 수 있는 첫 번째 날짜
                  lastDay: DateTime(9999,12,31),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    leftChevronIcon: const Icon(
                      Icons.arrow_left,
                      size: 40.0,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.arrow_right,
                      size: 40.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color:Color.fromARGB(239, 217, 217, 217),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    child: Text('${start.year}.${start.month}.${start.day} ~ ${end.year}.${end.month}.${end.day}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                    ),
                    ),
                  onPressed: pickDateRange,
                )
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 108, 141, 255),
                  onPrimary: Colors.black,
                ),

                child: Text('Search'),
                onPressed: (){
                }
              ),
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

