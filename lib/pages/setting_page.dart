import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double fontSize = 20;
  void changeFontSize() async {
    setState(() {
      fontSize += 2;
    });
  }

  void decreaseFontSize() async {
    setState(() {
      fontSize -= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 20, 97),
        centerTitle: true,
        title: Text("Setting"),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Text(
          'Welcome to Flutter Tutorial',
          style: TextStyle(fontSize: fontSize),
        ),
        ElevatedButton(
          onPressed: () {
            changeFontSize();
          },
          child: Text('Increase Font'),
        ),
        ElevatedButton(
          onPressed: () {
            decreaseFontSize();
          },
          child: Text('Decrease Font'),
        ),
      ])),
    );
  }
}
