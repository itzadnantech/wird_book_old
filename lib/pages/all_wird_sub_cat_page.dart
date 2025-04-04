import 'package:flutter/material.dart';
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/pages/all_wirds_page.dart';
import 'package:wird_book/data/all_wird_sub_cats.dart';
import 'package:wird_book/model/wird_sub_category.dart';
import 'package:wird_book/pages/setting_page.dart';
import 'package:wird_book/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

class AllWirdSubCatPage extends StatefulWidget {
  final String wird_cat_id;
  final String wird_cat_title;
  const AllWirdSubCatPage(this.wird_cat_id, this.wird_cat_title);

  @override
  _AllWirdSubCatPageState createState() => _AllWirdSubCatPageState();
}

class _AllWirdSubCatPageState extends State<AllWirdSubCatPage> {
  List<Wird_Sub_Category> subwirds;

  double _value = config.fontSize_min;
  double _prevScale = config.prevScale;
  double _scale = config.scale;

  @override
  void initState() {
    super.initState();
    fontSize();
    _scale = config.scale;
    _prevScale = config.prevScale;
    subwirds = all_wird_sub_cats
        .where((medium) => medium.wird_cat_id == widget.wird_cat_id)
        .toList();
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
          title:
              Text(getTranslated(context, 'wird_cat_id_' + widget.wird_cat_id)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingPage()));
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subwirds.length,
                itemBuilder: (context, index) {
                  final subwird = subwirds[index];
                  String sub_wird_title = "wird_sub_cat_id_" +
                      widget.wird_cat_id +
                      "_" +
                      subwird.wird_sub_cat_id;
                  return buildBook(subwird, sub_wird_title, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBook(Wird_Sub_Category list, sub_wird_title, context) =>
      Container(
        // margin: EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 8),
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
          contentPadding:
              EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
          trailing: Icon(
            // Icons.arrow_circle_right,
            Icons.arrow_forward_rounded,
            color: Color(config.colorPrimary),
            size: 20,
          ),
          leading: Text(
            getTranslated(context, sub_wird_title),
            // list.wird_sub_cat_title,
            style: TextStyle(
                fontSize: fontSize(),
                color: Color(config.colorPrimary),
                fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllWirdsPage(
                        list.wird_cat_id,
                        list.wird_sub_cat_id,
                        list.wird_sub_cat_title,
                        list.wird_audio_link)));
          },
        ),
      );
}
