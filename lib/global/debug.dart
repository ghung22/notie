// ignore_for_file: avoid_print

import "dart:core";
import "dart:core" as core show print;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Debug {
  static bool get isDebug => kDebugMode;

  static void print(
    BuildContext? context,
    String message, {
    bool fullOutput = true,
    DiagnosticLevel minLevel = DiagnosticLevel.debug,
  }) {
    final now = DateTime.now();
    final time = '${now.month}.${now.day}/${now.hour}:${now.minute}:${now.second}';
    final tree = context?.widget.toStringDeep(prefixOtherLines: '>') ?? 'null';
    final str = '[$time - $tree]: $message';
    debugPrint(str);
  }
}