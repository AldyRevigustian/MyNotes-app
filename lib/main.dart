import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
          headline5: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 24),
          headline2: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 20),    
          headline6: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24),
          bodyText2: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20),
          bodyText1: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 18),
          subtitle2: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14),
          headline1: TextStyle(
            fontFamily: 'Quicksand',
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 16
          )
        ),
      ),
      home: NoteList(),
    );
  }
}
