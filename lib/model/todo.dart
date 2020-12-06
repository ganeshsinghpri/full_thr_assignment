import 'package:flutter/material.dart';

class ToDo extends StatelessWidget {
  String _title;
  String _description;
  int _id;

  ToDo(this._title, this._description);

  ToDo.map(dynamic obj) {
    this._title = obj["title"];
    this._description = obj["description"];
    this._id = obj["id"];
  }

  ToDo.fromMap(Map<String, dynamic> map) {
    this._title = map["title"];
    this._description = map["description"];
    this._id = map["id"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["title"] = this._title;
    map["description"] = this._description;
    if (_id != null) {
      map["id"] = this._id;
    }
    return map;
  }

  String get title => _title;
  String get description => _description;
  int get id => _id;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Title : $_title",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
          Container(
            margin: EdgeInsets.only(top: 5,bottom: 5),
            child: Text(
              "Description : $_description",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
