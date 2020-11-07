import 'package:flutter/material.dart';
import 'package:notepad/ui/notodoscreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Note Pad"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: new NotoDoScreen(),
    );
  }
}
