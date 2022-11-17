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
  static const btnIconMinSize = iconSize;
  static const btnIconPadHorz = btnPadHorz / 2;
  static const btnPadHorz = btnPadVert * 3;
  static const btnPadVert = 8.0;
  static const btnRad = 30.0;
  static const btnToggleMinSize = 40.0;

  static const cardElevation = 8.0;
  static const cardRad = 12.0;
  static const cardPad = 8.0;

  static const drawerPad = 8.0;
  static const drawerItemPad = 4.0;

  static const dropdownElevation = 2.0;
  static const dropdownMenuMaxHeight = 320.0;
  static const dropdownPadHorz = 16.0;

  static const editorPad = 8.0;
  static const editorToolPad = 8.0;
  static const editorToolContentPadHorz = editorToolContentPadVert * 2;
  static const editorToolContentPadVert = editorToolPad;

  static const gridSpacing = 12.0;

  static const homeToolbarMaxHeight = kToolbarHeight * 2;
  static const homeToolbarPadHorz = homeToolbarPadVert * 1.5;
  static const homeToolbarPadInnerHorz = cardPad * 2;
  static const homeToolbarPadInnerVert = cardPad / 2;
  static const homeToolbarPadVert = 16.0;

  static const iconSize = 48.0;

  static const inputPad = cardPad * 1.5;

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
      BorderRadius.vertical(top: Radius.circular(Dimens.cardRad));
  static const btnRounded = BorderRadius.all(Radius.circular(Dimens.btnRad));
  static const card = BorderRadius.all(Radius.circular(Dimens.cardRad));
  static const code = card;
  static const input = BorderRadius.all(Radius.circular(Dimens.cardRad));
}