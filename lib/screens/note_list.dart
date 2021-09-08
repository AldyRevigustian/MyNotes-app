import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail.dart';

import 'package:notes_app/screens/note_view.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/screens/search_note.dart';
import 'package:notes_app/utils/widgets.dart';
import 'package:sqflite/sqflite.dart';

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
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  final Note result = await showSearch(
                      context: context, delegate: NotesSearch(notes: noteList));
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
      body: 
      noteList.length == 0
            ? Container(
                color: Colors.blueGrey.shade900,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                              padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
                              child: Text(this.noteList[index].date,
                                  style:
                                      Theme.of(context).textTheme.subtitle2))),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
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
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 10),
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
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

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
