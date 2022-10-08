import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'global/debug.dart';
import 'global/routes.dart' as rt;
import 'global/strings.dart';
import 'global/styles.dart';
import 'store/data/note_store.dart';
import 'store/global/language_store.dart';
import 'store/global/theme_store.dart';

void main() {
  Debug.print(null, 'App started at ${DateTime.now()}');
  runApp(MultiProvider(
    providers: [
      Provider<LanguageStore>(create: (_) => LanguageStore()),
      Provider<NoteStore>(create: (_) => NoteStore()),
      Provider<ThemeStore>(create: (_) => ThemeStore()),
    ],
    child: const Notie(),
  ));
}

class Notie extends StatelessWidget {
  const Notie({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) {
          return MaterialApp(
            title: 'Notie',
            debugShowCheckedModeBanner: true,
            // Theme
            themeMode: context.read<ThemeStore>().activeTheme,
            theme: Themes.light,
            darkTheme: Themes.dark,
            // Locale
            locale: Strings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // Routes
            initialRoute: '/',
            onGenerateRoute: rt.Router.generateRoute,
          );
        }
    );
  }
}