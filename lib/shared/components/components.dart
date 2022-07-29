
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

Widget defaultListItem(Map task)
{
  return Padding(
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
        Column(
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
      ],
    ),
  );
}