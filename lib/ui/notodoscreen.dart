import 'package:flutter/material.dart';
import 'package:notepad/model/helper.dart';
import 'package:notepad/model/notedoitem.dart';
import 'package:notepad/util/dateformater.dart';

class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => _NotoDoScreenState();
}

class _NotoDoScreenState extends State<NotoDoScreen> {
  final _firstFieldctrl = new TextEditingController();
  var db = new DatabaseHelper();

  List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    //ignore
    super.initState();

    _readNoDoItem();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: [
          //
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false, // work on a second time
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  //
                  return new Card(
                    color: Colors.white10,
                    child: new ListTile(
                      title: _itemList[index], // called from Widget result
                      onLongPress: () => _updateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].itemname),
                        child: new Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          new Divider(
            height: 1.0,
          ),

          //
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.redAccent,
          tooltip: "Add Item",
          child: new ListTile(title: new Icon(Icons.add)),
          onPressed: _showDialog),
    );
  }

  void _showDialog() {
    var alert = new AlertDialog(
      content: new Row(
        children: [
          //
          new Expanded(
              child: new TextField(
            controller: _firstFieldctrl,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: "Item",
              hintText: "eg. Don't buy sand",
              icon: Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: [
        new FlatButton(
            onPressed: () {
              if (_firstFieldctrl.text.isNotEmpty) {
                _handleSubmit(_firstFieldctrl.text);
                _firstFieldctrl.clear();
                Navigator.pop(context);
              } else {
                print("Nothing to Do");
              }
            },
            child: Text("Save")),

        //

        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text) async {
    _firstFieldctrl.clear();

    NoDoItem data = new NoDoItem(text, DateTime.now().toIso8601String());
    int res = await db.saveData(data);

    print("Save Data id is = >> $res");
    NoDoItem addedItem = await db.getOneData(res);

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  _readNoDoItem() async {
    List ls = await db.getAlldata();
    ls.forEach((item) {
      // NoDoItem ite = new NoDoItem.map(item);

      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
      // print("Data is ==> ${ite.itemname}");
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Delete Item");
    await db.deleteData(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(NoDoItem itemList, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: [
          new Expanded(
              child: new TextField(
            controller: _firstFieldctrl, //if nul return
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item",
                hintText: "e.g Don't by some cake.",
                icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: [
        new FlatButton(
            onPressed: () async {
              //

              NoDoItem updatedItem = NoDoItem.fromMap({
                "itemname": _firstFieldctrl.text,
                "datecreate": dateFormatted(),
                "id": itemList.id
              });

              _handleSubmitedUpdate(index, itemList);
              await db.updateData(updatedItem);
              setState(() {
                _readNoDoItem();
              });

              Navigator.pop(context);
            },
            child: new Text("Update")),

        //
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text("cancel")),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList
          .removeWhere((element) => _itemList[index].itemname == item.itemname);
    });
  }
}
