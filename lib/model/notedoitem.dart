import 'package:flutter/material.dart';

//ignore: must_be_immutable
class NoDoItem extends StatelessWidget {
  String _itemName, _dateCreate;
  int _id;

  NoDoItem(this._itemName, this._dateCreate);

  NoDoItem.map(dynamic obj) {
    this._itemName = obj["itemname"];
    this._dateCreate = obj["datecreate"];
    this._id = obj["id"];
  }

  String get itemname => _itemName;
  String get datecreate => _dateCreate;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemname"] = this._itemName;
    map["datecreate"] = this._dateCreate;
    if (_id != null) {
      map["id"] = this._id;
    }
    return map;
  }

  NoDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemname"];
    this._dateCreate = map["datecreate"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First col
              new Text(_itemName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5,
                  )),

              //Second col

              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  "Created on :$_dateCreate",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.4,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
