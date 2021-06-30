import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Password"
        ),
      ),
    );
  }
}
