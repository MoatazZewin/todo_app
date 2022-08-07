import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/todo_states.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/todo_cubit.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<TodoCubit, TodoStates>(
        listener:(BuildContext context, state){} ,
        builder: (BuildContext context, state){
          return ListView.separated(
              itemBuilder: (context, index )=> defaultListItem(TodoCubit.get(context).databaseDoneTasks[index],context),
              separatorBuilder: (context, index ) => Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 30.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
              itemCount: TodoCubit.get(context).databaseDoneTasks.length);

        },

      );
  }
}
