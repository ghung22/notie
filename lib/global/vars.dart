import 'package:flutter/material.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/routes.dart';

import 'styles.dart';

class Vars {
  static const appName = 'Notie';

  static const animationBlink = Duration(milliseconds: 25);
  static const animationFlash = Duration(milliseconds: 75);
  static const animationSwift = Duration(milliseconds: 150);
  static const animationFast = Duration(milliseconds: 300);
  static const animationSlow = Duration(milliseconds: 600);
  static const animationSluggish = Duration(milliseconds: 1200);

  static List<int> get textSizes {
    return List.generate(20 - 6, (i) => i + 6)
      ..addAll(List.generate(10, (i) => i * 2 + 22))
      ..addAll(List.generate(8, (i) => i * 4 + 36));
  }

  static BuildContext? get context {
    if (_context == null) {
      Debug.warning(null,
          'Global context is null (did you forget to call Vars.init(context)?)');
    }
    return _context;
  }

  static BuildContext? _context;

  static void init(BuildContext context) {
    if (_context != null) return;
    _context = context;

    Themes.updateSystemUi(reason: 'Vars.init');
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      if (!RouteController.inEditor) {
        Future.delayed(Vars.animationSlow,
            () => Themes.updateSystemUi(reason: 'Brightness changed'));
      }
    };
  }
}

class Formats {
  static const lower = 'lower';
  static const caps = 'caps';
  static const upper = 'upper';
}

enum SortType {
  byDefault,
  byName,
  byColor,
  byCreateTime,
  byUpdateTime,
  byDeleteTime,
}

enum SortOrder {
  ascending,
  descending,
}