import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail.dart';
import 'package:notes_app/utils/widgets.dart';

class NoteView extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteView(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteViewState(this.note, this.appBarTitle);
  }
}

class NoteViewState extends State<NoteView> {
  DatabaseHelper helper = DatabaseHelper();
  File _image;
  String appBarTitle;
  Note note;
  int color;

  NoteViewState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    if (note.imagePath != null) {
      _image = File(note.imagePath);
    }

    color = note.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          appBarTitle,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Colors.blueGrey.shade900,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              moveToLastScreen();
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToDetail(this.note, 'Edit Note');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDeleteDialog(context);
            },
          )
        ],
      ),
      body: Container(
        color: colors[color],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(this.note.date,
                                style: Theme.of(context).textTheme.subtitle2))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
                      child: Text(
                        getPriorityText(this.note.priority),
                        style: TextStyle(
                            color: getPriorityColor(this.note.priority),
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Text(
                note.title,
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25),
              ),
            ),
          
              Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
                child: Text(
                  note.description,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 20),
                ),
              ),
          
            if (this.note.imagePath != null)
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.file(_image)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text("Are you sure you want to delete this note?",
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(this.context, true);
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }

  void navigateToDetail(Note note, String title) async {
    await Navigator.push(this.context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));
  }

  getPriorityText(int priority) {
    if (priority == 1) {
      return 'Very High Priority';
    }
    if (priority == 2) {
      return 'High Priority';
    }
    if (priority == 3) {
      return 'Low Priority';
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red[500];
        break;
      case 2:
        return Color(0xFFF49136);
        break;
      case 3:
        return Colors.green[500];
        break;

      default:
        return Colors.green[500];
    }
  }
}
