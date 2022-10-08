import 'package:flutter/material.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/widget/page/editor_page.dart';
import 'package:notie/widget/page/home_page.dart';

import 'debug.dart';
import 'vars.dart';

class Routes {
  static const String home = '/';
  static const String editor = '/editor';
  static const String settings = '/settings';
}

class Router {
  static Route? generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case Routes.home:
          return MaterialPageRoute(builder: (context) {
            Vars.init(context);
            return const HomePage();
          });
        case Routes.editor:
          return MaterialPageRoute(builder: (context) {
            if (settings.arguments == null) {
              throw 'Editor page requires a Note object as argument';
            }
            return EditorPage(settings.arguments as Note);
          });
        default:
          throw 'Unknown route: ${settings.name}';
      }
    } catch (e) {
      Debug.print(null, '$e', minLevel: DiagnosticLevel.error);
    }
    return null;
  }
}