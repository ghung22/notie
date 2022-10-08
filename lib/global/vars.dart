import 'package:flutter/material.dart';
import 'package:notie/global/debug.dart';

class Vars {
  static const appName = 'Notie';

  static const animationBlink = Duration(milliseconds: 25);
  static const animationFlash = Duration(milliseconds: 75);
  static const animationSwift = Duration(milliseconds: 150);
  static const animationFast = Duration(milliseconds: 300);
  static const animationSlow = Duration(milliseconds: 600);
  static const animationSluggish = Duration(milliseconds: 1200);

  static BuildContext? get context {
    if (_context == null) {
      Debug.print(
        null,
        'Global context is null (did you forget to call Vars.init(context)?)',
        minLevel: DiagnosticLevel.warning,
      );
    }
    return _context;
  }

  static BuildContext? _context;

  static void init(BuildContext context) => _context = context;
}