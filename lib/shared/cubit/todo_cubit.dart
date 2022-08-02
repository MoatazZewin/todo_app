import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/todo_states.dart';

import '../../modules/archived_tasks_screen/archived_tasks_screen.dart';
import '../../modules/done_tasks_screen/done_tasks_screen.dart';
import '../../modules/new_tasks_screen/new_tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit():super(TodoInitailaState());

 static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  bool isbottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  late Database dataBase;
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

  changeIndex(int index)
  {
    currentIndex = index;
    emit(TodoChangBottomNavBarState());

  }
  changFloatingButton()
  {
    isbottomSheetShown = !isbottomSheetShown;
    fabIcon = fabIcon == Icons.edit? Icons.add: Icons.edit;
    emit(TodoFloatingButtonState());
  }

  void createDatebase()  {
     openDatabase("todo.db", version: 1,
        onCreate: (database, version) {
          print("database is created");
          database.execute(
              "create table tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT )")
              .then((value) {
            print("the table is created");
            emit(TodoCreateDatabaseState());
          } )
              .catchError((onError) {
            print(onError.toString());
          });
        }, onOpen: (database) {
           dataBase =database;
          print("database is opened");
          getDatabase(database).then((value) {
            databaseList = value;
            print(databaseList);
            emit(TodoGetDatabaseState());
          });
        }).then((value) => dataBase =value);
  } //method createDatebase

   insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
     await dataBase.transaction((txn) async {
      txn
          .rawInsert(
          "insert into tasks (title, date, time, status ) values ('$title', '$date', '$time', 'new')  ")
          .then((value) {
        print("$value inserted successfully");
        emit(TodoInsertDatabaseState());
        getDatabase(dataBase).then((value) {
          databaseList = value;
          print(databaseList);
          emit(TodoGetDatabaseState());
        });
      } )
          .catchError((onError) {
        print(onError.toString());
      });
    });
  } //method insertToDatabase

  Future<List<Map>> getDatabase(dataBase) async {

     emit(TodoGetDataBaseLoading());
    return await dataBase.rawQuery("select * from tasks");
  }


}