import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks_screen/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  // const HomeLayout({Key? key}) : super(key: key);
  late Database dataBase;
  bool isbottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  GlobalKey<ScaffoldState> scafflodKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentIndex = 0;
  List<Map> databaseList = [];
  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  @override
  void initState() {
    super.initState();
    createDatebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafflodKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
              ),
              label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outline,
              ),
              label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: "Archived"),
        ],
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        currentIndex: currentIndex,
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isbottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                setState(() {
                  isbottomSheetShown = false;
                  fabIcon = Icons.edit;
                  Navigator.pop(context);
                });
              });
            }
          } else {
            scafflodKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultTextFormField(
                          label: "Title Task",
                          controller: titleController,
                          prefixIcon: Icons.title,
                          type: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter the text";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                          label: "Task Time",
                          controller: timeController,
                          prefixIcon: Icons.watch_later_outlined,
                          type: TextInputType.datetime,
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              timeController.text =
                                  value!.format(context).toString();
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter the Time";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                          label: "Task Date",
                          controller: dateController,
                          prefixIcon: Icons.calendar_today,
                          type: TextInputType.datetime,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2022-08-29'),
                            ).then((value) {
                              dateController.text =
                                  DateFormat.yMMMd().format(value!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter the Date";
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
              ),
              elevation: 20.0,
            ).closed.then((value){
              isbottomSheetShown = false;
              fabIcon = Icons.edit;
              setState(() {
              });
            });

            setState(() {
              isbottomSheetShown = true;
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
    );
  }

  void createDatebase() async {
    dataBase = await openDatabase("todo.db", version: 1,
        onCreate: (database, version) {
      print("database is created");
      database
          .execute(
              "create table tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT )")
          .then((value) => print("the table is created"))
          .catchError((onError) {
        print(onError.toString());
      });
    }, onOpen: (database) {
      print("database is opened");
      getDatabase(database).then((value) {
        databaseList = value;
        print(databaseList);
      });
    });
  } //method createDatebase

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await dataBase.transaction((txn) async {
      txn
          .rawInsert(
              "insert into tasks (title, date, time, status ) values ('$title', '$date', '$time', 'new')  ")
          .then((value) => print("$value inserted successfully"))
          .catchError((onError) {
        print(onError.toString());
      });
    });
  } //method insertToDatabase

  Future<List<Map>> getDatabase(dataBase) async {
    return await dataBase.rawQuery("select * from tasks");
  }
}
