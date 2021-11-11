import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail.dart';
import 'package:notes_app/screens/note_view.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/screens/search_note.dart';
import 'package:notes_app/utils/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';


class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListView();
    }

    updateListView();

    Widget myAppBar() {
      return AppBar(
        title: Text('My Notes', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade900,
        actions: <Widget>[
          noteList.length == 0
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      final Note result = await showSearch(
                          context: context,
                          delegate: NotesSearch(notes: noteList));
                      if (result != null) {
                        navigateToView(result, 'View Note');
                      }
                    },
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  )),
        ],
        leading: noteList.length == 0
            ? Container()
            : IconButton(
                icon: Icon(
                  axisCount == 2
                      ? Icons.view_agenda_outlined
                      : Icons.grid_view_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    axisCount = axisCount == 2 ? 4 : 2;
                  });
                },
              ),
      );
    }

    return Scaffold(
      appBar: myAppBar(),
      body: noteList.length == 0
          ? Container(
              color: Colors.blueGrey.shade900,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text('No Notes',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                ),
              ),
            )
          : Container(
              color: Colors.blueGrey.shade900,
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 3, 0), 'Add Note');
        },
        tooltip: 'Add Note',
        shape: CircleBorder(
            side: BorderSide(color: Color.fromRGBO(42, 38, 56, 1), width: 2.0)),
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey.shade900,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey.shade900),
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Material(
                            child: Image.asset(
                          'assets/myicon.png',
                          height: 65,
                          width: 65,
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("My Notes",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text("© 2021 Aldy Revi",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                )),
              ),
              Divider(
                height: 1,
                color: Colors.grey[400],
                indent: 15,
                endIndent: 15,
                thickness: 1,
              ),
              // Divider(height: 1,color: Colors.grey[400],indent: 20, endIndent: 20,thickness: 1,),
              
              CustomDelete(),
              CustomAbout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToView(this.noteList[index], 'View Note');
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: colors[this.noteList[index].color],
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                              child: Text(this.noteList[index].date,
                                  style:
                                      Theme.of(context).textTheme.subtitle2))),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                        child: Image.asset(
                          getPriorityText(this.noteList[index].priority),
                          width: 17,
                          height: 17,
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 12),
                        child: Text(
                          this.noteList[index].title,
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 5, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            this.noteList[index].description == null
                                ? ''
                                : this.noteList[index].description,
                            style: Theme.of(context).textTheme.headline1),
                      )
                    ],
                  ),
                ),
                if (this.noteList[index].imagePath != null)
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: FileImage(
                              File(this.noteList[index].imagePath),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red[500];
        break;
      case 2:
        return Colors.yellow[800];
        break;
      case 3:
        return Colors.green[500];
        break;

      default:
        return Colors.green[500];
    }
  }

  getPriorityText(int priority) {
    if (priority == 1) {
      return 'assets/1 (2).png';
    }
    if (priority == 2) {
      return 'assets/1 (3).png';
    }
    if (priority == 3) {
      return 'assets/1 (1).png';
    }
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,MaterialPageRoute(builder: (context) => NoteDetail(note, title)), );
    // bool result = await Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NoteDetail(note,title)));

    if (result == true) {
      updateListView();
    }
  }

  void navigateToView(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteView(note, title)));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

class CustomAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey.shade900,
      child: InkWell(
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon: Padding(
              padding: const EdgeInsets.all(5),
              child: Material(
                child: Image.asset(
                  'assets/splash2.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            applicationVersion: '1.0.0',
            applicationLegalese: "© 2021 Aldy Revi",
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                // child: Text("Source Code", style: TextStyle(color: Colors.black),),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      style: TextStyle(color: Colors.black),
                      text:
                          "Flutter is an early-stage, open-source project to help developers build high performance, high-fidelity, mobile apps for iOS and Android from a single codebase. Learn more about Flutter at "),
                  TextSpan(
                    style: TextStyle(color: Colors.blue),
                    text: "Flutter Dev",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(
                            'https://flutter.dev/');
                      },
                  ),  
                ])),
              )
            ],
          );
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Icon(Icons.info_outline, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("About",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomDelete extends StatefulWidget {
  @override
  _CustomDeleteState createState() => _CustomDeleteState();
}

class _CustomDeleteState extends State<CustomDelete> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey.shade900,
      child: InkWell(
        onTap: () {
          showDeleteAllDialog(context);
        },

        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Icon(Icons.delete_forever, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("Delete All",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete All Notes?",
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20),
          ),
          content: Text("Are you sure you want to delete all notes?",
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text(
                "No",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),              
              onPressed: () {
                databaseHelper.deleteAllNote();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}