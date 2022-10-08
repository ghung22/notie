import 'package:flutter/cupertino.dart';
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
          return FadePageRoute(builder: (context) {
            Vars.init(context);
            return const HomePage();
          });
        case Routes.editor:
          if (settings.arguments == null) {
            return SlidePageRoute(
              pageBuilder: (_, __, ___) => const EditorPage(Note()),
            );
          }
          return FadePageRoute(builder: (context) {
            if (settings.arguments is! Note) {
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

class FadePageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => Vars.animationSlow;

  FadePageRoute({builder}) : super(builder: builder);
}

class SlidePageRoute extends PageRouteBuilder {
  @override
  Duration get transitionDuration => Vars.animationSlow;

  SlidePageRoute({pageBuilder})
      : super(
          pageBuilder: pageBuilder,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}