import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/store/global/theme_store.dart';
import 'package:provider/provider.dart';

import 'colors.dart';
import 'dimens.dart';
import 'vars.dart';

class Styles {
  static BuildContext? get _context => Vars.context;

  // TextView styles
  static TextStyle header = TextStyle(
    color: Theme.of(_context!).primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: Themes.fontDisplay,
  );

  static TextStyle subheader = TextStyle(
    color: Theme.of(_context!).primaryColor,
    fontSize: 14,
  );

  static TextStyle footer = TextStyle(
    color: Theme.of(_context!).colorScheme.onSurface.withOpacity(.5),
    fontSize: 14,
  );
  static const TextStyle spacedText = TextStyle(
    letterSpacing: 0.5,
  );

  static TextStyle get error => const TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      );

  // Font styles
  static TextStyle h1 = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: Themes.fontDisplay,
  );

  static TextStyle h2 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: Themes.fontDisplay,
  );

  static TextStyle h3 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: Themes.fontDisplay,
  );

  static TextStyle mono = const TextStyle(
    fontFamily: Themes.fontMono,
    fontSize: 13,
  );

  static TextStyle cursive = const TextStyle(
    fontFamily: Themes.fontCursive,
    fontSize: 20,
  );

  // Widget styles
  static const TextStyle iconBtnError = TextStyle(fontFamily: Themes.fontMono);
  static const TextStyle iconBtnLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static InputDecoration inputFilled = InputDecoration(
    border: const OutlineInputBorder(borderRadius: Rads.input),
    fillColor: Theme.of(_context!).colorScheme.surface,
    filled: true,
    contentPadding: Pads.all(Dimens.inputPad),
  );

  static InputDecoration inputBorderless = InputDecoration(
    border: InputBorder.none,
    contentPadding: Pads.all(Dimens.inputPad),
  );

  // Content styles
  static DefaultStyles quillStylesFrom({Color? background}) {
    final style = DefaultStyles.getInstance(_context!);
    final theme = Theme.of(_context!);
    background ??= theme.colorScheme.surface;
    final onBg = ColorBuilder.onColor(background);
    final onBgFaded = onBg.withOpacity(.1);
    final onBgHalf = onBg.withOpacity(.5);
    final base = TextStyle(fontFamily: Themes.fontDefault, color: onBg);
    return DefaultStyles(
      // region Base style
      paragraph: DefaultTextBlockStyle(
        style.paragraph!.style.merge(base).copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              height: 1.3,
              decoration: TextDecoration.none,
            ),
        style.paragraph!.verticalSpacing,
        style.paragraph!.lineSpacing,
        style.paragraph!.decoration,
      ),
      h1: DefaultTextBlockStyle(
        style.h1!.style.merge(base),
        style.h1!.verticalSpacing,
        style.h1!.lineSpacing,
        style.h1!.decoration,
      ),
      h2: DefaultTextBlockStyle(
        style.h2!.style.merge(base),
        style.h2!.verticalSpacing,
        style.h2!.lineSpacing,
        style.h2!.decoration,
      ),
      h3: DefaultTextBlockStyle(
        style.h3!.style.merge(base),
        style.h3!.verticalSpacing,
        style.h3!.lineSpacing,
        style.h3!.decoration,
      ),
      bold: style.bold!.merge(base),
      italic: style.italic!.merge(base),
      underline: style.underline!.merge(base),
      strikeThrough: style.strikeThrough!.merge(base),
      //endregion

      // region Content style
      inlineCode: InlineCodeStyle(
        backgroundColor: onBgFaded,
        radius: Rads.code.topLeft,
        style: style.inlineCode!.style
            .merge(base)
            .copyWith(fontFamily: Themes.fontMono),
        header1: style.inlineCode!.header1!
            .merge(base)
            .copyWith(fontFamily: Themes.fontMono),
        header2: style.inlineCode!.header2!
            .merge(base)
            .copyWith(fontFamily: Themes.fontMono),
        header3: style.inlineCode!.header3!
            .merge(base)
            .copyWith(fontFamily: Themes.fontMono),
      ),
      code: DefaultTextBlockStyle(
        style.code!.style.merge(base).copyWith(fontFamily: Themes.fontMono),
        style.code!.verticalSpacing,
        style.code!.lineSpacing,
        BoxDecoration(color: onBgFaded, borderRadius: Rads.code),
      ),
      quote: DefaultTextBlockStyle(
        style.quote!.style.merge(base).copyWith(color: onBgHalf),
        style.quote!.verticalSpacing,
        style.quote!.lineSpacing,
        BoxDecoration(
            border: Border(left: BorderSide(width: 4, color: onBgFaded))),
      ),
      link: TextStyle(
        color: theme.primaryColor,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dotted,
        decorationColor: theme.primaryColor,
      ),
      // endregion
    );
  }
}

class Themes {
  static BuildContext? get _context => Vars.context;

  static const fontDefault = 'roboto';
  static const fontText = 'sf_text';
  static const fontDisplay = 'sf_display';
  static const fontMono = 'monospace';
  static const fontCursive = 'carattere';

  static ThemeData get light => _generateTheme(from: ThemeData.light());

  static ThemeData get dark => _generateTheme(from: ThemeData.dark());

  static ThemeMode get themeMode {
    if (_context == null) return ThemeMode.light;
    final themeStore = _context!.read<ThemeStore>();
    switch (themeStore.activeTheme) {
      case ThemeMode.system:
        final br = MediaQuery.platformBrightnessOf(_context!);
        return (br == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
      case ThemeMode.light:
      case ThemeMode.dark:
        return themeStore.activeTheme;
    }
  }

  static bool get isLightMode => themeMode == ThemeMode.light;

  static bool get isDarkMode => themeMode == ThemeMode.dark;

  static void updateSystemUi({Color? surface, String? reason}) async {
    if (_context == null) return;
    Debug.info(
        _context,
        'Updating UI with surface color '
        '${surface?.value.toRadixString(16) ?? '<default>'}\n'
        'Reason: ${reason ?? 'Unknown'}');
    surface ??= (isDarkMode ? dark : light).colorScheme.surface;

    await Future.delayed(const Duration(milliseconds: 1));
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: surface,
        systemNavigationBarIconBrightness:
            ColorBuilder.colorBrightnessInvert(surface),
      ),
    );
  }

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
          borderRadius: BorderRadius.all(Radius.circular(Dimens.cardRad)),
        ),
      ),
    );
  }
}