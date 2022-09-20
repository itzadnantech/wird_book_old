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
        Divider(),
        Text(
          'Test Font Size',
          style: TextStyle(
              fontSize:
                  Provider.of<FontSizeController>(context, listen: true).value),
        ),
        Divider(),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Color.fromARGB(255, 6, 20, 97)),
          ),
          onPressed: () {
            Provider.of<FontSizeController>(context, listen: false).increment();
          },
          child: Text('Increase Font'),
        ),
        Divider(),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Color.fromARGB(255, 6, 20, 97)),
          ),
          onPressed: () {
            Provider.of<FontSizeController>(context, listen: false).decrement();
          },
          child: Text('Decrease Font'),
        ),
      ])),
    );
  }
}

class FontSizeController with ChangeNotifier {
  double _value = 15.0;

  double get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }

  void decrement() {
    _value--;
    notifyListeners();
  }
}
