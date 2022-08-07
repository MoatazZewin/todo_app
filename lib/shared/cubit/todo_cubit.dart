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
  List<Map> databaseNewTasks = [];
  List<Map> databaseDoneTasks = [];
  List<Map> databaseArchivedTasks = [];

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
          getDatabase(dataBase);
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
        getDatabase(dataBase);

      } )
          .catchError((onError) {
        print(onError.toString());
      });
    });
  } //method insertToDatabase

   getDatabase(dataBase)  {
      databaseNewTasks = [];
      databaseDoneTasks = [];
      databaseArchivedTasks = [];


     dataBase.rawQuery("select * from tasks").then((value){
       value.forEach((element){
         if(element["status"] == "new")
           {
             databaseNewTasks.add(element);

           }else if(element["status"] == "done")
             {
               databaseDoneTasks.add(element);
             }else
               databaseArchivedTasks.add(element);
       });
       print(databaseNewTasks);
       emit(TodoGetDatabaseState());

     });
  }

  updateData({
    required String status,
    required int id
})
  {
    dataBase.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status,  id]).then((value) {
          getDatabase(dataBase);
         emit(TodoUpdateDataBase());
    });

  }


  deleteData({
    required int id
  })
  {
    dataBase.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      emit(TodoDeleteDateBase());
      getDatabase(dataBase);

    });

  }


}