import 'package:flutter/material.dart';
import 'package:notepad/model/helper.dart';
import 'package:notepad/model/notedoitem.dart';

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
    // TODO: implement initState
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
                      onLongPress: () => debugPrint("hells"),
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
}
