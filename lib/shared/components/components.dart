
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