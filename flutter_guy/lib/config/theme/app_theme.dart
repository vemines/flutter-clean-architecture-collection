import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Muli',
  appBarTheme: appBarTheme,
);

AppBarTheme appBarTheme = AppBarTheme(
  color: Colors.white,
  elevation: 0,
  centerTitle: true,
  iconTheme: IconThemeData(color: Color(0XFF8B8B8B)),
  titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
);
