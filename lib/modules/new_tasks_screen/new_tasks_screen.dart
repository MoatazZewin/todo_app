import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/todo_cubit.dart';
import 'package:todo_app/shared/cubit/todo_states.dart';

import '../../shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<TodoCubit, TodoStates>(
        listener:(BuildContext context, state){} ,
        builder: (BuildContext context, state){
          var tasks = TodoCubit.get(context).databaseNewTasks;
          return taskBuilder(tasks: tasks);

        },

      );
  }
}
