import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_throttle_assignment/model/todo.dart';
import 'package:full_throttle_assignment/dbUtil/database_client.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final List<ToDo> _itemList = <ToDo>[];
  TextEditingController _titleTextEditController = TextEditingController();
  TextEditingController _descTextEditController = TextEditingController();
  var db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _readToDoItems();
  }

  _readToDoItems() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(ToDo.map(item));
      });
    });
  }

  void _handleSubmit(String text,String text2) async {
    ToDo toDoItem = ToDo(text, text2);
    int savedItemId = await db.saveItem(toDoItem);
    ToDo addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  void _showFormDialog() {
    _titleTextEditController.clear();
    _descTextEditController.clear();
    var alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
         TextField(
              controller: _titleTextEditController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter Title",
              ),
            ),

          TextField(
              controller: _descTextEditController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Enter Description",
              ),
            ),

        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmit(_titleTextEditController.text,_descTextEditController.text);
            _titleTextEditController.clear();
            _descTextEditController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _updateItem(ToDo toDoItem, int index) async {
    var alert = AlertDialog(
      title: Text("Update Todo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           TextField(
            controller: _titleTextEditController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Title",
              hintText: "Enter Title",
            ),
          ),
           TextField(
                controller: _descTextEditController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter Description",
                ),
              )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              ToDo updatedItem = ToDo.fromMap({
                "title": _titleTextEditController.text,
                "description": _descTextEditController.text,
                "id": toDoItem.id
              });
              _handleSubmitUpdated(updatedItem, index);
              await db.updateItem(updatedItem);
              setState(() {
                _readToDoItems();
              });
              _titleTextEditController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
      ],
    );

    _titleTextEditController.text= toDoItem.title;
    _descTextEditController.text= toDoItem.description;
    showDialog(context: context, builder: (_) => alert);
  }

  _handleSubmitUpdated(ToDo toDoItem, int index) async {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].title == toDoItem.title;
      });
    });

  }

  _deleteItem(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.teal,
                  child: ListTile(
                    title: _itemList[index],
                    onTap: () => {},
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(

                         onTap: () => _updateItem(_itemList[index], index),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: () => _deleteItem(_itemList[index].id, index),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )

                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add ToDo",
        onPressed: _showFormDialog,
        backgroundColor: Colors.redAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }
}
