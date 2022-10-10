import 'package:flutter/material.dart';
import 'package:notie/store/global/theme_store.dart';
import 'package:provider/provider.dart';

import 'dimens.dart';
import 'vars.dart';

class Styles {
  static BuildContext? get _context => Vars.context;

  // TextView styles
  static TextStyle get header => TextStyle(
        color: Theme.of(_context!).primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: Themes.fontDisplay,
      );

  static TextStyle get subheader => TextStyle(
        color: Theme.of(_context!).primaryColor,
        fontSize: 14,
      );

  static TextStyle get footer => const TextStyle(
        color: Colors.black54,
      );
  static const TextStyle spacedText = TextStyle(
    letterSpacing: 0.5,
  );

  static TextStyle get error => const TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      );

  static TextStyle get mono => const TextStyle(
        fontFamily: Themes.fontMono,
        fontSize: 13,
      );

  // Widget styles
  static const TextStyle iconBtnError = TextStyle(fontFamily: Themes.fontMono);
  static const TextStyle iconBtnLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  static InputDecoration inputOutlined = InputDecoration(
    border: const OutlineInputBorder(borderRadius: Rads.input),
    contentPadding: Pads.all(Dimens.inputPadding),
  );

// Content styles
}

class Themes {
  static BuildContext? get _context => Vars.context;

  static const fontText = 'sf_text';
  static const fontDisplay = 'sf_display';
  static const fontMono = 'monospace';

  static ThemeData get light => _generateTheme(from: ThemeData.light());

  static ThemeData get dark => _generateTheme(from: ThemeData.dark());

  static ThemeMode get themeMode {
    if (_context == null) return ThemeMode.light;
    final themeStore = _context!.read<ThemeStore>();
    switch (themeStore.activeTheme) {
      case ThemeMode.system:
        final br = MediaQuery.of(_context!).platformBrightness;
        return (br == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
      case ThemeMode.light:
      case ThemeMode.dark:
        return themeStore.activeTheme;
    }
  }

  static bool get isLightMode => themeMode == ThemeMode.light;

  static bool get isDarkMode => themeMode == ThemeMode.dark;

  static ThemeData _generateTheme({required ThemeData from}) {
    final initialTheme = ThemeData(
      primarySwatch: Colors.pink,
      fontFamily: fontText,
      textTheme: from.textTheme,
    );
    return initialTheme.copyWith(
      // Global style
      backgroundColor: from.backgroundColor,
      brightness: from.brightness,
      colorScheme: initialTheme.colorScheme.copyWith(
        surface: from.colorScheme.surface,
        onSurface: from.colorScheme.onSurface,
        surfaceVariant: from.colorScheme.surfaceVariant,
        onSurfaceVariant: from.colorScheme.onSurfaceVariant,
        inverseSurface: from.colorScheme.inverseSurface,
        onInverseSurface: from.colorScheme.onInverseSurface,
      ),
      dialogBackgroundColor: from.dialogBackgroundColor,
      dividerTheme: from.dividerTheme.copyWith(
        color: from.colorScheme.onSurface.withOpacity(.25),
      ),
      hintColor: from.colorScheme.onSurface.withOpacity(.25),
      scaffoldBackgroundColor: from.scaffoldBackgroundColor,
      textTheme: initialTheme.textTheme.copyWith(
        displayLarge: initialTheme.textTheme.displayLarge
            ?.copyWith(fontFamily: fontDisplay),
        displayMedium: initialTheme.textTheme.displayMedium
            ?.copyWith(fontFamily: fontDisplay),
        displaySmall: initialTheme.textTheme.displaySmall
            ?.copyWith(fontFamily: fontDisplay),
      ),

      // Widget style
      appBarTheme: from.appBarTheme.copyWith(
        backgroundColor: from.colorScheme.surface,
        foregroundColor: from.colorScheme.onSurface,
        elevation: Dimens.appBarElevation,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: from.colorScheme.onSurface.withOpacity(.75),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomAppBarTheme: from.bottomAppBarTheme.copyWith(
        color: from.colorScheme.surface,
        elevation: Dimens.bottomAppBarElevation,
      ),
      bottomNavigationBarTheme: from.bottomNavigationBarTheme.copyWith(
        backgroundColor: from.colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: initialTheme.primaryColor,
          size: from.iconTheme.size ?? 24 * 1.25,
        ),
        selectedItemColor: initialTheme.primaryColor,
        unselectedIconTheme: IconThemeData(
          color: from.colorScheme.onSurface.withOpacity(.5),
        ),
        unselectedItemColor: from.colorScheme.onSurface.withOpacity(.5),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: from.colorScheme.surface,
        shape: Borders.bottomSheet,
      ),
      cardTheme: CardTheme(
        color: from.colorScheme.surface,
        elevation: Dimens.cardElevation,
        shape: Borders.card,
      ),
      chipTheme: ChipThemeData(
        shape:
            StadiumBorder(side: BorderSide(color: initialTheme.primaryColor)),
        backgroundColor: initialTheme.primaryColor.withOpacity(.25),
        selectedColor: initialTheme.primaryColor.withOpacity(.75),
      ),
      drawerTheme: from.drawerTheme.copyWith(
        backgroundColor: Colors.transparent,
        width: Dimens.drawerWidth,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: from.colorScheme.surface,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.cardRadius)),
        ),
      ),
    );
  }
}