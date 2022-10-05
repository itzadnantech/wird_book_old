// ignore_for_file: prefer_const_constructors, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wird_book/main.dart';
import 'package:wird_book/config.dart' as config;
import 'package:wird_book/localization/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double _value = config.fontSize_min;
  double _prevScale = config.prevScale;
  double _scale = config.scale;
  late String selected_lng;

  @override
  void initState() {
    super.initState();
    fontSize();
    _scale = config.scale;
    _prevScale = config.prevScale;
    getLanguage();
  }

  void getLanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      selected_lng = _prefs.getString(LAGUAGE_CODE) ?? "ar";
    });
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getDouble('value') ?? config.fontSize_min;
      _value = _value * _scale;
      if (_value > config.fontSize_max) {
        _value = config.fontSize_max;
      }

      if (_value < config.fontSize_min) {
        _value = config.fontSize_min;
      }

      // prefs.setDouble('value', _value);
    });
  }

  double fontSize() {
    init();
    return _value;
  }

  void fontSizeSlider_async() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getDouble('value') ?? config.fontSize_min;
      if (_value > config.fontSize_max) {
        _value = config.fontSize_max;
      }

      if (_value < config.fontSize_min) {
        _value = config.fontSize_min;
      }

      // prefs.setDouble('value', _value);
    });
  }

  double fontSizeSlider() {
    fontSizeSlider_async();
    return _value;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = (_prevScale * (details.scale));
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() {
          _prevScale = _scale;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(config.colorPrimary),
          centerTitle: true,
          title: Text(getTranslated(context, 'SettingPage')),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
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
                        color: Color(config.colorPrimary),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Flexible(
                    flex: 2,
                    child: ElevatedButton(
                      // onPressed: () {},
                      onPressed: () {
                        Provider.of<FontSizeController>(context, listen: false)
                            .decrement();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(5),
                          backgroundColor: Color(config.colorPrimary)),
                      child: Icon(
                        Icons.remove,
                      ),
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
                        backgroundColor: Color(config.colorPrimary)),
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
                        color: Color(config.colorPrimary),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Language_Card(context),
            ])),
      ),
    );
  }

  Widget buildSlider(BuildContext context) {
    double _currentSliderValue = fontSizeSlider();
    return Slider(
      value: fontSizeSlider(),
      activeColor: Color(config.colorPrimary),
      max: config.fontSize_max,
      min: config.fontSize_min,
      divisions: config.fontSize_devisions,
      label: fontSizeSlider().round().toString(),
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
              selected_lng = 'en';
              Locale _locale = await setLocale('en');
              MyApp.setLocale(context, _locale);
            },
            child: Text('English'),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: BorderSide(color: Color(config.colorPrimary))),
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 15),
                backgroundColor: selected_lng == 'en'
                    ? Color(config.colorPrimary)
                    : Colors.white,
                foregroundColor: selected_lng == 'en'
                    ? Colors.white
                    : Color(config.colorPrimary)),
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
          child: Text('العربية'.trim()),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(100, 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(config.colorPrimary))),
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 15),
              backgroundColor: selected_lng == 'ar'
                  ? Color(config.colorPrimary)
                  : Colors.white,
              foregroundColor: selected_lng == 'ar'
                  ? Colors.white
                  : Color(config.colorPrimary)),
        ),
      ),
    ]);
  }
}

class FontSizeController with ChangeNotifier {
  double _value = config.fontSize_min;
  // Obtain shared preferences.

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = prefs.getDouble('value') ?? config.fontSize_min;
  }

  double fontSize() {
    init();
    return _value;
  }

  double get value => fontSize();
  void increment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = ((prefs.getDouble('value') ?? config.fontSize_min) + 0.02);
    if (_value > config.fontSize_max) {
      _value = config.fontSize_max;
    }
    prefs.setDouble('value', _value);

    notifyListeners();
  }

  void decrement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = ((prefs.getDouble('value') ?? config.fontSize_min) - 0.02);
    if (_value < config.fontSize_min) {
      _value = config.fontSize_min;
    }
    prefs.setDouble('value', _value);

    notifyListeners();
  }
}
