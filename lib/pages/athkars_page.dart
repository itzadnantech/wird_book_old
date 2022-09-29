import 'package:flutter/material.dart';
import 'package:wird_book/classes/language.dart';
import 'package:wird_book/localization/language_constants.dart';
import 'package:wird_book/main.dart';
import 'package:wird_book/pages/all_wird_sub_cat_page.dart';
import 'package:wird_book/router/route_constants.dart';
import 'package:wird_book/widget/search_widget.dart';
import 'package:wird_book/data/all_wird_cats.dart';
import 'package:wird_book/model/wird_category.dart';
import 'package:wird_book/pages/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wird_book/config/fontSize.dart' as GlobalFont;

class AthkarsPage extends StatefulWidget {
  const AthkarsPage({Key key}) : super(key: key);

  @override
  _AthkarsPageState createState() => _AthkarsPageState();
}

class _AthkarsPageState extends State<AthkarsPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<Wird_Category> list_wird_category;
  String query = '';
  double _value = GlobalFont.fontSize_min;
  double _prevScale = GlobalFont.prevScale;
  double _scale = GlobalFont.scale;

  @override
  void initState() {
    super.initState();
    fontSize();
    list_wird_category = all_wird_cats;
    _scale = GlobalFont.scale;
    _prevScale = GlobalFont.prevScale;
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getDouble('value') ?? GlobalFont.fontSize_min;
      _value = _value * _scale;
      if (_value > GlobalFont.fontSize_max) {
        _value = GlobalFont.fontSize_max;
      }

      if (_value < GlobalFont.fontSize_min) {
        _value = GlobalFont.fontSize_min;
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
          backgroundColor: Color.fromARGB(255, 6, 20, 97),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                onChanged: searchWirdCategory,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  hintText: getTranslated(context, 'search'),
                  suffixIcon: const Icon(Icons.search),
                  // prefix: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 6, 20, 97), width: 4.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
                color: Color.fromARGB(255, 6, 20, 97),
                fontWeight: FontWeight.w600),
          ),
          // leading: test(single_wird_category.wird_cat_id, context),
          trailing: const Icon(
            Icons.arrow_forward_rounded,
            color: Color.fromARGB(255, 6, 20, 97),
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
