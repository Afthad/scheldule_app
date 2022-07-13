import 'package:calendar_builder/calendar_builder.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/bloc/scheduler_bloc.dart';
import 'package:scheduler_app/models.dart';
import 'package:scheduler_app/widgets/time_line_widget.dart';
import 'package:scheduler_app/widgets/time_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SchedulerBLoc bloc = SchedulerBLoc();
  DateTime? selectedDate;
  List<SchedulerDTO> scheduledDatas = [];
  bool dateExists = false;
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<List<SchedulerDTO>>(
                stream: bloc.dataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: CbMonthBuilder(
                            onDateClicked: (s) {
                              if (s.selectedDate.millisecondsSinceEpoch >=
                                  DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .millisecondsSinceEpoch) {
                                selectedDate = s.selectedDate;

                                for (var e in snapshot.data!) {
                                  if (selectedDate!.difference(e.date).inDays ==
                                      0) {
                                    dateExists = true;
                                    break;
                                  }
                                }
                                if (dateExists) {
                                  dateExists = false;
                                  scheduledDatas.clear();
                                  scheduledDatas.addAll(snapshot.data!.where(
                                      (element) =>
                                          selectedDate!
                                              .difference(element.date)
                                              .inDays ==
                                          0));
                                  showModalBottomSheet<void>(
                                    backgroundColor: const Color.fromARGB(
                                        255, 171, 171, 244),
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .6,
                                          child: TimeLineWidget(
                                              data: scheduledDatas));
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('No Events')));
                                }

                                setState(() {});
                              }
                            },
                            cbConfig: CbConfig(
                              startDate: DateTime.now(),
                              endDate: DateTime(2026),
                              selectedDate: selectedDate == null
                                  ? DateTime.now()
                                  : selectedDate!,
                              selectedYear: DateTime(DateTime.now().year),
                            )));
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: TimeSelector(
                    onComplete: (s) async {
                      var res = await bloc.sendData(s);
                      if (res) {
                        bloc.addData(s);
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return AlertDialog(
                                title: const Text(
                                  "This Overlap with Another Schedule and Cant be saved",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                content:
                                    const Text("Please Modify and try again."),
                                actions: [
                                  SizedBox(
                                    width: 100,
                                    child: MaterialButton(
                                      color: Colors.blue,
                                      onPressed: () {
                                        Navigator.pop(c);
                                      },
                                      child: const Text('Okay'),
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                  ));
            },
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
