import 'package:flutter/material.dart';
import 'package:full_throttle_assignment/ui/todo_screen.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Assignment - FT Labs"),
        backgroundColor: Colors.teal,
      ),
      body: ToDoScreen(),
    );
  }
}
