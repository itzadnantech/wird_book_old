import 'package:flutter/material.dart';
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/config.dart' as config;
import 'package:wird_book/pages/all_wird_sub_cat_page.dart';
import 'package:wird_book/widget/search_widget.dart';
import 'package:wird_book/data/all_wird_cats.dart';
import 'package:wird_book/model/wird_category.dart';
import 'package:wird_book/pages/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AthkarsPage extends StatefulWidget {
  const AthkarsPage({Key key}) : super(key: key);

  @override
  _AthkarsPageState createState() => _AthkarsPageState();
}

class _AthkarsPageState extends State<AthkarsPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<Wird_Category> list_wird_category;
  String query = '';
  double _value = config.fontSize_min;
  double _prevScale = config.prevScale;
  double _scale = config.scale;

  @override
  void initState() {
    super.initState();
    fontSize();
    list_wird_category = all_wird_cats;
    _scale = config.scale;
    _prevScale = config.prevScale;
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
          title: Text(getTranslated(context, 'homePage')),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  _navigateToSettingPage(context);
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(6),
                child: TextField(
                  onChanged: searchWirdCategory,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    hintText: getTranslated(context, 'search'),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(config.colorPrimary),
                    ),
                    // prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(config.colorPrimary)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list_wird_category.length,
                  // scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final single_wird_category = list_wird_category[index];
                    return buildWirdCategoryList(single_wird_category, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch(context) => SearchWidget(
        text: query,
        hintText: getTranslated(context, 'search'),
        onChanged: searchWirdCategory,
      );

  Widget buildWirdCategoryList(Wird_Category single_wird_category, context) =>
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
          contentPadding:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
          leading: Text(
            getTranslated(
                context, 'wird_cat_id_' + single_wird_category.wird_cat_id),
            style: TextStyle(
                // fontSize: Provider.of<FontSizeController>(context, listen: true)
                //     .value,
                fontSize: fontSize(),
                color: Color(config.colorPrimary),
                fontWeight: FontWeight.w600),
          ),
          // leading: test(single_wird_category.wird_cat_id, context),
          trailing: Icon(
            Icons.arrow_forward_rounded,
            color: Color(config.colorPrimary),
            size: 20,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllWirdSubCatPage(
                        single_wird_category.wird_cat_id,
                        single_wird_category.wird_cat_title)));
          },
        ),
      );

  void searchWirdCategory(String query) {
    final list_wird_category = all_wird_cats.where((single_wird_category) {
      // final subWirdLower = book.subWird.toLowerCase();
      final single_wird_category_Lower =
          single_wird_category.wird_cat_title.toLowerCase();
      final searchLower = query.toLowerCase();

      // return subWirdLower.contains(searchLower) ||
      //     wirdLower.contains(searchLower);
      return single_wird_category_Lower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.list_wird_category = list_wird_category;
    });
  }

  ///Setting Page
  void _navigateToSettingPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SettingPage()));
  }
}
