import 'package:flutter/material.dart';
import 'package:notie/widget/page/home_page.dart';

import 'vars.dart';

class Routes {
  static const String home = '/';
  static const String editor = '/editor';
  static const String settings = '/settings';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (context) {
          Vars.init(context);
          return const HomePage();
        });
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ));
    }
  }
}