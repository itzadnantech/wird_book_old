import 'package:flutter/material.dart';
import 'package:wird_book/pages/athkars_page.dart';
import 'package:wird_book/pages/all_wird_sub_cat_page.dart';
import 'package:wird_book/pages/not_found_page.dart';
import 'package:wird_book/router/route_constants.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case athkarsRoute:
        return MaterialPageRoute(builder: (_) => AthkarsPage());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundPage());
    }
  }
}
