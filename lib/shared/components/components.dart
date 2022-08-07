

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cubit/todo_cubit.dart';

Widget defaultTextFormField({
  required String label,
  required TextEditingController controller,
  required IconData prefixIcon,
  IconData? suffixIcon ,
  Function()? suffOnPressed,
  required TextInputType type,
  bool obscure = false ,
  Function()? onTap,
  required String? Function(String?)? validator,
})
{
  return TextFormField(
    controller: controller,
    onTap: onTap,
    keyboardType: type,
    obscureText: obscure,
    validator: validator,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      label: Text(
        label,
      ),
      prefixIcon: Icon(
        prefixIcon,
      ),
      suffixIcon:suffixIcon != null? IconButton(
        icon: Icon(
          suffixIcon,
        ),
        onPressed:suffOnPressed ,
      ):null,
    ),
  );
}

Widget defaultListItem(Map task, context)
{
  return Dismissible(
    onDismissed: (direction){
      TodoCubit.get(context).deleteData(id: task["id"]);
    },
    key: Key(task["id"].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 35.0,
            child: Text("${task['time']}",
            ),
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Text("${task['title']}",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${task['date']}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),),
              ],
            ),
          ),
          SizedBox(width: 10.0,),
          IconButton(onPressed: (){
            TodoCubit.get(context).updateData(status: "done", id: task["id"]);

          },
              icon: Icon(
            Icons.check_box,
                color: Colors.green,
          ),
          ),
          SizedBox(width: 5.0,),
          IconButton(onPressed: (){
            TodoCubit.get(context).updateData(status: "archived", id: task["id"]);
          },
            icon: Icon(
              Icons.archive,
            ),
          ),

        ],
      ),
    ),
  );
}

Widget taskBuilder({
  required List<Map> tasks,
})=>tasks.length>0?ListView.separated(
    itemBuilder: (context, index )=> defaultListItem(tasks[index],context),
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
    itemCount: tasks.length) : Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.menu,
        size: 100.0,
        color: Colors.grey,
      ),
      Text(
        'No Tasks Yet, Please Add Some Tasks',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ],
  ),
);







