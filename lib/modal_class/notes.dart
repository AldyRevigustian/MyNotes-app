class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority, _color;
  String _imagePath;

  Note(this._title, this._date, this._priority, this._color,
      [this._description,this._imagePath]);

  Note.withId(this._id, this._title, this._date, this._priority, this._color,
      [this._description, this._imagePath]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get priority => _priority;
  int get color => _color;
  String get date => _date;

  String get imagePath => _imagePath;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
      this._description = newDescription;

  }
  // set description(String newDescription) {
  //   if (newDescription.length <= 255) {
  //     this._description = newDescription;
  //   }
  // }

  set imagePath(String newImage){
    this._imagePath = newImage;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 3) {
      this._priority = newPriority;
    }
  }

  set color(int newColor) {
    if (newColor >= 0 && newColor <= 9) {
      this._color = newColor;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['color'] = _color;
    map['date'] = _date;
    map['imagePath'] = _imagePath;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._color = map['color'];
    this._date = map['date'];

    this._imagePath = map['imagePath'];
  }
}
