import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wird_book/config/fontSize.dart' as GlobalsFont;
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/classes/language.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 20, 97),
        centerTitle: true,
        title: Text(getTranslated(context, 'SettingPage')),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Column(children: <Widget>[
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.9),
                    blurRadius: 2.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                title: Text(
                  getTranslated(context, 'FontSize'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize:
                          Provider.of<FontSizeController>(context, listen: true)
                              .value,
                      color: Color.fromARGB(255, 6, 20, 97),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Flexible(
                  flex: 2,
                  child: ElevatedButton(
                    // onPressed: () {},
                    onPressed: () {
                      Provider.of<FontSizeController>(context, listen: false)
                          .decrement();
                    },
                    child: Icon(
                      Icons.remove,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(5),
                        backgroundColor: Color.fromARGB(255, 6, 20, 97)),
                  )),
              Flexible(flex: 12, child: buildSlider(context)),
              Flexible(
                flex: 2,
                child: ElevatedButton(
                  // onPressed: () {},
                  onPressed: () {
                    Provider.of<FontSizeController>(context, listen: false)
                        .increment();
                  },
                  child: Icon(
                    Icons.add,
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      backgroundColor: Color.fromARGB(255, 6, 20, 97)),
                ),
              )
            ]),
            Divider(),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.9),
                    blurRadius: 2.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                title: Text(
                  getTranslated(context, 'LanguageSetting'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize:
                          Provider.of<FontSizeController>(context, listen: true)
                              .value,
                      color: Color.fromARGB(255, 6, 20, 97),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ])),
    );
  }

  @override
  Widget buildSlider(BuildContext context) {
    double _currentSliderValue =
        Provider.of<FontSizeController>(context, listen: true).value;
    return Slider(
      value: Provider.of<FontSizeController>(context, listen: true).value,
      activeColor: Color.fromARGB(255, 6, 20, 97),
      max: 30,
      min: 14,
      divisions: 8,
      label: Provider.of<FontSizeController>(context, listen: true)
          .value
          .round()
          .toString(),
      onChanged: (double value) {
        if (value < _currentSliderValue) {
          Provider.of<FontSizeController>(context, listen: false).decrement();
        } else {
          Provider.of<FontSizeController>(context, listen: false).increment();
        }
        setState(() {
          _currentSliderValue = value;
          print(_currentSliderValue);
        });
      },
    );
  }
}

class FontSizeController with ChangeNotifier {
  double _value = GlobalsFont.fontSize;
  double get value => _value;
  void increment() {
    // _value++;
    _value = _value + 2;
    if (_value > 30) {
      _value = 30;
    }
    notifyListeners();
  }

  void decrement() {
    // _value--;
    _value = _value - 2;
    if (_value < 14) {
      _value = 14;
    }
    notifyListeners();
  }
}
