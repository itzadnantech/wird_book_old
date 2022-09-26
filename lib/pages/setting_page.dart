import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wird_book/main.dart';
import 'package:wird_book/config/fontSize.dart' as GlobalFont;
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/classes/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _value = GlobalFont.fontSize_min;

  String selected_lng = '';

  // void _changeLanguage(Language language) async {
  //   Locale _locale = await setLocale(language.languageCode);
  //   MyApp.setLocale(context, _locale);
  // }

  @override
  void initState() {
    super.initState();
    fontSize();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getDouble('value') ?? GlobalFont.fontSize_min;
    });
  }

  double fontSize() {
    init();
    return _value;
  }

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
                      fontSize: fontSize(),
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
              margin: EdgeInsets.only(top: 8, bottom: 20, left: 8, right: 8),
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
                      fontSize: fontSize(),
                      color: Color.fromARGB(255, 6, 20, 97),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Language_Card(context),
          ])),
    );
  }

  @override
  Widget buildSlider(BuildContext context) {
    double _currentSliderValue = fontSize();
    return Slider(
      value: fontSize(),
      activeColor: Color.fromARGB(255, 6, 20, 97),
      max: 30,
      min: 14,
      divisions: 8,
      label: fontSize().round().toString(),
      onChanged: (double value) {
        if (value < _currentSliderValue) {
          Provider.of<FontSizeController>(context, listen: false).decrement();
        } else {
          Provider.of<FontSizeController>(context, listen: false).increment();
        }
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  @override
  // Language Card Section
  Widget Language_Card(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Flexible(
          flex: 2,
          child: ElevatedButton(
            onPressed: () async {
              selected_lng = 'ar';
              Locale _locale = await setLocale('en');
              MyApp.setLocale(context, _locale);
            },
            child: Text('English'),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                backgroundColor: Color.fromARGB(255, 6, 20, 97)),
          )),
      SizedBox(width: 30),
      Flexible(
        flex: 2,
        child: ElevatedButton(
          onPressed: () async {
            selected_lng = 'ar';
            Locale _locale = await setLocale('ar');
            MyApp.setLocale(context, _locale);
          },
          child: Text('العربية'),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
              backgroundColor: Color.fromARGB(255, 6, 20, 97)),
        ),
      ),
    ]);
  }
}

class FontSizeController with ChangeNotifier {
  double _value = GlobalFont.fontSize_min;
  // Obtain shared preferences.

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = prefs.getDouble('value') ?? GlobalFont.fontSize_min;
  }

  double fontSize() {
    init();
    return _value;
  }

  double get value => fontSize();
  void increment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = ((prefs.getDouble('value') ?? GlobalFont.fontSize_min) + 2);
    if (_value > GlobalFont.fontSize_max) {
      _value = GlobalFont.fontSize_min;
    }
    prefs.setDouble('value', _value);
    notifyListeners();
  }

  void decrement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = ((prefs.getDouble('value') ?? GlobalFont.fontSize_min) - 2);
    if (_value < GlobalFont.fontSize_min) {
      _value = GlobalFont.fontSize_min;
    }
    prefs.setDouble('value', _value);
    notifyListeners();
  }
}
