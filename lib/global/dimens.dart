import 'package:flutter/material.dart';

import 'vars.dart';

class Dimens {
  static BuildContext? get _context => Vars.context;

  static Size get screenSize {
    if (_context == null) return const Size(0, 0);
    return MediaQuery.of(_context!).size;
  }

  static double get screenWidth => screenSize.width;

  static double get screenHeight => screenSize.height;

  static double get drawerWidth => screenWidth * 0.8;

  static const appBarElevation = 5.0;

  static const bottomAppBarElevation = appBarElevation;
  static const bottomAppBarNotchMargin = 8.0;

  static const btnElevation = 5.0;
  static const btnIconLabelGap = 8.0;
  static const btnIconMinSize = 48.0;
  static const btnIconPaddingHorz = btnPaddingHorz / 2;
  static const btnPaddingHorz = btnPaddingVert * 3;
  static const btnPaddingVert = 8.0;
  static const btnRadius = 30.0;
  static const btnToggleMinSize = 40.0;

  static const cardElevation = 8.0;
  static const cardRadius = 12.0;
  static const cardPadding = 8.0;

  static const drawerPadding = 8.0;
  static const drawerItemPadding = 4.0;

  static const dropdownElevation = 2.0;
  static const dropdownMenuMaxHeight = 320.0;
  static const dropdownPaddingHorz = 16.0;

  static const editorPadding = 8.0;
  static const editorToolPadding = 8.0;
  static const editorToolContentPaddingHorz = editorToolContentPaddingVert * 2;
  static const editorToolContentPaddingVert = editorToolPadding;

  static const gridSpacing = 12.0;

  static const inputPadding = cardPadding * 1.5;

  static const noteGridTileHeight = 240.0;

  static const sheetTitleHeight = 64.0;
}

class Pads {
  static EdgeInsets none = EdgeInsets.zero;

  /// Short for [EdgeInsets.all]
  static EdgeInsets all(double val) => EdgeInsets.all(val);

  /// Short for [EdgeInsets.only]
  static EdgeInsets only(
          {double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.only(left: l, top: t, right: r, bottom: b);

  /// Short for [EdgeInsets.symmetric]
  static EdgeInsets sym({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  /// Short for [EdgeInsets.fromLTRB]
  static EdgeInsets ltrb(double l, double t, double r, double b) =>
      EdgeInsets.fromLTRB(l, t, r, b);

  /// Short for [EdgeInsets.symmetric] with a horizontal value
  static EdgeInsets horz(double val) => sym(h: val);

  /// Short for [EdgeInsets.symmetric] with a vertical value
  static EdgeInsets vert(double val) => sym(v: val);

  /// Short for [EdgeInsets.only] with a left value
  static EdgeInsets left(double val) => only(l: val);

  /// Short for [EdgeInsets.only] with a right value
  static EdgeInsets right(double val) => only(r: val);

  /// Short for [EdgeInsets.only] with a top value
  static EdgeInsets top(double val) => only(t: val);

  /// Short for [EdgeInsets.only] with a bottom value
  static EdgeInsets bot(double val) => only(b: val);
}

class Borders {
  static const bottomSheet =
      RoundedRectangleBorder(borderRadius: Rads.bottomSheet);
  static const btnCircle = CircleBorder();
  static const btnRounded =
      RoundedRectangleBorder(borderRadius: Rads.btnRounded);
  static const card = RoundedRectangleBorder(borderRadius: Rads.card);
}

class Rads {
  static const bottomSheet =
      BorderRadius.vertical(top: Radius.circular(Dimens.cardRadius));
  static const btnRounded = BorderRadius.all(Radius.circular(Dimens.btnRadius));
  static const card = BorderRadius.all(Radius.circular(Dimens.cardRadius));
  static const code = card;
  static const input = BorderRadius.all(Radius.circular(Dimens.cardRadius));
}