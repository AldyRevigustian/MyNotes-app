import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/utils/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int color;

  File _image;
  final picker = ImagePicker();

  bool isEdited = false;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;

    if (note.imagePath != null) {
      _image = File(note.imagePath);
    }

    color = note.color;
    return WillPopScope(
        onWillPop: () async {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
          return false;
        },
        child: Scaffold(
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
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  titleController.text.length == 0 ||
                          descriptionController.text.length == 0
                      ? showEmptyDialog(context)
                      : _save();
                },
              ),
            ],
          ),
          body: Container(
            color: colors[color],
            child: ListView(
              children: <Widget>[
                PriorityPicker(
                  selectedIndex: 3 - note.priority,
                  onTap: (index) {
                    isEdited = true;
                    note.priority = 3 - index;
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextField(
                    // autofocus: true,
                    controller: titleController,
                    // maxLength: 255,
                    style: Theme.of(context).textTheme.bodyText2,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 20),
                      labelText: "Title",
                      // hintText: "Description",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 16, 8),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      // maxLength: 255,
                      controller: descriptionController,
                      style: Theme.of(context).textTheme.bodyText1,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.normal,
                            color: Colors.black54,
                            fontSize: 18),
                        labelText: "Description",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_image != null)
                  Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.file(_image)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _image = null;
                                note.imagePath = null;
                              });
                              updateImage();
                            },
                            icon: Icon(Icons.close,
                                size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey.shade900,
                          ),
                          child: IconButton(
                            onPressed: () {
                              cropImage(_image);
                            },
                            icon:
                                Icon(Icons.crop, size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ]),
              ],
            ),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            curve: Curves.bounceIn,
            backgroundColor: Colors.blueGrey.shade900,
            overlayOpacity: 0,
            children: [
              SpeedDialChild(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onTap: () {
                  showColorDialog(context);
                },
                child: Icon(
                  Icons.format_color_fill,
                ),
              ),
              SpeedDialChild(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                onTap: () {
                  getImage(ImageSource.gallery);
                },
                child: Icon(Icons.image),
              ),
              SpeedDialChild(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onTap: () {
                  getImage(ImageSource.camera);
                },
                child: Icon(Icons.photo_camera),
              )
            ],
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text("Are you sure you want to discard changes?",
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
                moveToFirstScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Title And Description",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: Text('Title and description must be filled.',
              style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text("Ok",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  void moveToFirstScreen() {
    Navigator.popUntil(this.context, (Route<dynamic> route) => route.isFirst);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  void updateImage() {
    isEdited = true;
    note.imagePath = _image != null ? _image.path : null;
  }

  // Save data to database
  void _save() async {
    // moveToLastScreen();
    moveToFirstScreen();

    note.imagePath = _image != null ? _image.path : null;

    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }

  void showColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Choose Color",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: ColorPicker(
            selectedIndex: note.color,
            onTap: (index) {
              setState(() {
                color = index;
              });
              isEdited = true;
              note.color = index;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getImage(ImageSource imageSource) async {
    XFile imageFile =
        await picker.pickImage(source: imageSource, imageQuality: 20);
    // XFile imageFile = await picker.pickImage(source: imageSource, imageQuality:20);
    // PickedFile imageFile = await picker.getImage(
    //   source: imageSource,
    //   imageQuality: 25,
    // );
    if (imageFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          compressQuality: 80,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.blueGrey.shade900,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      if (croppedFile != null) {
        File tmpFile = File(croppedFile.path);

        final appDir = await getApplicationDocumentsDirectory();
        final fileName = basename(croppedFile.path);

        tmpFile = await tmpFile.copy('${appDir.path}/$fileName');
        setState(() {
          _image = tmpFile;
        });
        updateImage();
      }
    }
    if (imageFile == null) return;
  }

  cropImage(image) async {
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          // compressQuality: 80,

          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.blueGrey.shade900,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      if (croppedFile != null) {
        File tmpFile = File(croppedFile.path);

        final appDir = await getApplicationDocumentsDirectory();
        final fileName = basename(croppedFile.path);

        tmpFile = await tmpFile.copy('${appDir.path}/$fileName');
        setState(() {
          _image = tmpFile;
        });
        updateImage();
      }
    }

    if (image == null) return;
  }
}
