import 'package:flutter/material.dart';

List<Color> colors = [
  Color(0xFFFFFFFF),
  Color(0xffFFBCBC),
  Color(0xFFFFF476),
  Color(0xFFCBFF90),
  Color(0xFFE8EAEE),
  Color(0xFFCAF0F8),
  Color(0xFFC9BCFF),
  Color(0xFFBCDBFF),
  Color.fromRGBO(255, 225, 148, 1),
  // Color(0xFFE6C9A9),
  // Color(0xFFA7FEEA),
  // Color(0xFFFFFFFF),
  // Color.fromRGBO(148, 255, 159,1),
  // Color(0xFFFCBC09),
  // Color.fromRGBO(255, 148, 231, 1),
  // Color.fromRGBO(148, 159, 255, 1),
  // Color.fromRGBO(208, 184, 223, 1),
  // Color.fromRGBO(248, 165, 165, 1),
  // Color.fromRGBO(167, 248, 165, 1),
  // Color.fromRGBO(165, 203, 248, 1),
  // Color.fromRGBO(112, 250, 217, 1),

];

class PriorityPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  PriorityPicker({this.onTap, this.selectedIndex});
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  int selectedIndex;
  List<String> priorityText = ['Low', 'High', 'Very High'];
  List<Color> priorityColor = [Colors.green, Colors.yellow[900], Colors.red];
  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null) {
      selectedIndex = widget.selectedIndex;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: EdgeInsets.all(0.0),
              width: width / 3,
              height: 70,
              child: Container(
                child: Center(
                  child: Text(priorityText[index],
                      style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? priorityColor[index]
                        : Colors.transparent,
                    // borderRadius: BorderRadius.circular(8.0),
                    border: selectedIndex == index
                        ? Border.all(width: 0, color: Colors.transparent)
                        : Border.all(width: 0, color: Colors.transparent)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  ColorPicker({this.onTap, this.selectedIndex});
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null) {
      selectedIndex = widget.selectedIndex;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              child: Container(
                child: Center(
                    child: selectedIndex == index
                        ? Icon(Icons.done)
                        : Container()),
                decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}
