import 'package:flutter/material.dart';
import 'package:tba/pages/home.dart';
import 'package:tba/styles/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     final ThemeData myTheme = ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme.copyWith(
        colorScheme: myTheme.colorScheme.copyWith(
          primary: myBlue, 
          secondary: myBlue,),
      ),
      /* theme: ThemeData(
        primaryColor: myBlue,
        accentColor: myBlue,
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity, 
      ), */
      home: HomePage(),
    );
  }
}
