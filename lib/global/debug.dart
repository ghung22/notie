import "dart:core";
import 'dart:developer' as dev show log;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class Debug {
  static bool get isDebug => kDebugMode;

  static void log(
    BuildContext? context,
    String message, {
    bool fullOutput = true,
    Level level = Level.FINE,
  }) {
    final now = DateTime.now();
    final tree = context?.widget.toStringDeep(prefixOtherLines: '>') ?? '.';
    for (final line in '\n$message\n'.split('\n')) {
      dev.log(line, time: now, name: tree.trim(), level: level.value);
    }
  }

  static void info(BuildContext? context, String message,
          {bool fullOutput = true}) =>
      log(context, message, level: Level.INFO);

  static void warning(BuildContext? context, String message,
          {bool fullOutput = true}) =>
      log(context, message, level: Level.WARNING);

  static void error(
    BuildContext? context,
    String message,
    Object e, {
    bool fullOutput = true,
  }) {
    final now = DateTime.now();
    final tree = context?.widget.toStringDeep(prefixOtherLines: '>') ?? '.';
    dev.log('!!!\n$message\n!!!',
        time: now, name: tree.trim(), level: Level.SEVERE.value, error: e);
  }
}