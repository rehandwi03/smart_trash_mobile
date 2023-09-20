import 'package:flutter/material.dart';
import 'package:smart_trash_mobile/utils/constants/colors.dart';

Widget inputText(String hint, TextEditingController ctrl,
    {bool obsecure = false}) {
  return TextField(
    controller: ctrl,
    obscureText: obsecure,
    decoration: InputDecoration(
      // labelText: "Masukan email",
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColors
                .greenPrimaryColor), // Set the focused border line color
        borderRadius: const BorderRadius.all(
            Radius.circular(10.0)), // Optional: Set border radius
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColors
                .greenPrimaryColor), // Set the focused border line color
        borderRadius: const BorderRadius.all(
            Radius.circular(10.0)), // Optional: Set border radius
      ),
    ),
  );
}
