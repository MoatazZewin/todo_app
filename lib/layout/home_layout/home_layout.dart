import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/todo_cubit.dart';

import '../../shared/components/constants.dart';
import '../../shared/cubit/todo_states.dart';

class HomeLayout extends StatelessWidget {
  // const HomeLayout({Key? key}) : super(key: key);



  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  GlobalKey<ScaffoldState> scafflodKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDatebase(),
      child:BlocConsumer<TodoCubit, TodoStates>(
        listener:(context, state){
          if(state is TodoInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context, state){
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scafflodKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
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
                cubit.changeIndex(index);

              },
              currentIndex: cubit.currentIndex,
            ),
            body:cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbottomSheetShown) {
                  // bool? valid = formKey.currentState?.validate()==null?false:true;
                  // print(valid);
                  // print('befor${cubit.fabIcon.toString()}');
                  // print('befor${cubit.isbottomSheetShown}');
                  //
                  // print('after${cubit.isbottomSheetShown}');
                  // print('after${cubit.fabIcon.toString()}');


                  if ( formKey.currentState!.validate()) {
                    cubit.insertToDatabase(title: titleController.text,
                        date:dateController.text ,
                        time: timeController.text);
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   setState(() {
                    //     isbottomSheetShown = false;
                    //     fabIcon = Icons.edit;
                    //     Navigator.pop(context);
                    //   });
                    //
                    //
                    //
                    // });
                    print("inside if");


                  }
                } else {
                  scafflodKey.currentState
                      ?.showBottomSheet(
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
                  ).closed
                      .then((value) {
                    // cubit.isbottomSheetShown = false;
                    // fabIcon = Icons.edit;
                    cubit.changFloatingButton();
                  });

                  // setState(() {
                  //   isbottomSheetShown = true;
                  //   fabIcon = Icons.add;
                  // });


                  cubit.changFloatingButton();
                }

              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
          );
        },
      ),

    );
  }


}



