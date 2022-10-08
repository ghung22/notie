import 'package:flutter/material.dart';

class ColorBuilder {
  static Color _shade(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + factor).clamp(0, 1);
    return hsl.withLightness(lightness.toDouble()).toColor();
  }

  static Color lighter(Color color, {double magnitude = 1}) =>
      _shade(color, .2 * magnitude);

  static Color darker(Color color, {double magnitude = 1}) =>
      _shade(color, -.2 * magnitude);

  static Color onColor(Color color) =>
      color.computeLuminance() > .5 ? Colors.black : Colors.white;

  static Color onColorShadow(Color color) =>
      color.computeLuminance() > .5 ? Colors.white : Colors.black;
}

// region Template colors

class BwColors {
  static const blackHex = 0xff000000;
  static const darkHex = 0xff282828;
  static const dimHex = 0xff303030;
  static const grayHex = 0xff484848;
  static const lightHex = 0xff646464;
  static const paleHex = 0xffafafaf;
  static const whiteHex = 0xffffffff;
  static const black = Color(blackHex);
  static const dark = Color(darkHex);
  static const dim = Color(dimHex);
  static const gray = Color(grayHex);
  static const light = Color(lightHex);
  static const pale = Color(paleHex);
  static const white = Color(whiteHex);
}

class BgColors {
  static const whiteHex = BwColors.whiteHex;
  static const grayHex = BwColors.grayHex;
  static const blackHex = BwColors.blackHex;
  static const redHex = 0xffef9a9a;
  static const orangeHex = 0xffffab91;
  static const yellowHex = 0xfffff59d;
  static const greenHex = 0xffa5d6a7;
  static const tortoiseHex = 0xff80cbc4;
  static const cyanHex = 0xff80deea;
  static const blueHex = 0xff81d4fa;
  static const violetHex = 0xff9fa8da;
  static const purpleHex = 0xffb39ddb;
  static const magentaHex = 0xffce93d8;
  static const pinkHex = 0xfff48fb1;
  static const white = BwColors.white;
  static const gray = BwColors.gray;
  static const black = BwColors.black;
  static const red = Color(redHex);
  static const orange = Color(orangeHex);
  static const yellow = Color(yellowHex);
  static const green = Color(greenHex);
  static const tortoise = Color(tortoiseHex);
  static const cyan = Color(cyanHex);
  static const blue = Color(blueHex);
  static const violet = Color(violetHex);
  static const purple = Color(purpleHex);
  static const magenta = Color(magentaHex);
  static const pink = Color(pinkHex);
}

class FgColors {
  static const whiteHex = BwColors.paleHex;
  static const grayHex = BwColors.grayHex;
  static const blackHex = BwColors.darkHex;
  static const redHex = 0xffef5350;
  static const orangeHex = 0xffff7043;
  static const yellowHex = 0xffffee58;
  static const greenHex = 0xff66bb6a;
  static const tortoiseHex = 0xff26a69a;
  static const cyanHex = 0xff26c6da;
  static const blueHex = 0xff42a5f5;
  static const violetHex = 0xff5c6bc0;
  static const purpleHex = 0xff7e57c2;
  static const magentaHex = 0xffab47bc;
  static const pinkHex = 0xffec407a;
  static const white = BwColors.pale;
  static const gray = BwColors.light;
  static const black = BwColors.dark;
  static const red = Color(redHex);
  static const orange = Color(orangeHex);
  static const yellow = Color(yellowHex);
  static const green = Color(greenHex);
  static const tortoise = Color(tortoiseHex);
  static const cyan = Color(cyanHex);
  static const blue = Color(blueHex);
  static const violet = Color(violetHex);
  static const purple = Color(purpleHex);
  static const magenta = Color(magentaHex);
  static const pink = Color(pinkHex);
}

// endregion

class ColorOptions {
  static const noteColors = {
    'white': BgColors.white,
    'red': BgColors.red,
    'orange': BgColors.orange,
    'yellow': BgColors.yellow,
    'green': BgColors.green,
    'tortoise': BgColors.tortoise,
    'cyan': BgColors.cyan,
    'blue': BgColors.blue,
    'violet': BgColors.violet,
    'purple': BgColors.purple,
    'magenta': BgColors.magenta,
    'pink': BgColors.pink,
  };

  static const folderColors = {
    'white': BwColors.light,
    'red': BgColors.red,
    'orange': BgColors.orange,
    'yellow': BgColors.yellow,
    'green': BgColors.green,
    'tortoise': BgColors.tortoise,
    'cyan': BgColors.cyan,
    'blue': BgColors.blue,
    'violet': BgColors.violet,
    'purple': BgColors.purple,
    'magenta': BgColors.magenta,
    'pink': BgColors.pink,
  };
}