import 'package:flutter/material.dart';
import 'package:wird_book/pages/about_page.dart';
import 'package:wird_book/pages/home_page.dart';
import 'package:wird_book/pages/not_found_page.dart';
import 'package:wird_book/pages/settings_page.dart';
import 'package:wird_book/router/route_constants.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutPage());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundPage());
    }
  }
}
