import 'package:flutter/material.dart';
import 'dart:ui'; //for mobile

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hand/pages/note_Page.dart';
import 'package:note_hand/pages/settings_page.dart';
import 'package:note_hand/store/__data.dart';
import 'package:note_hand/store/providers_.dart';
import 'package:note_hand/utils/langs.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home.dart';
// import 'package:styled_widget/styled_widget.dart';



final languageCodes = languages.keys;




void main() async {
  // final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  // await Hive.initFlutter()
  // Hive.registerAdapter(NoteAdapter());

  await Hive.initFlutter().then((value) {

    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(SettingsAdapter());
  });

  // Hive..initFlutter()..registerAdapter(NoteAdapter());

  final settings = await SettingsNotifier.read();
  if (settings.language.isNotEmpty) {
      final langCode = settings.language.substring(0, 2).toLowerCase();
      if (languageCodes.contains(langCode)){  // languages[langCode]
          runApp(App(
              locale: ValueNotifier<Locale?>(Locale(langCode))
          ));
          return;
      }
  }

  runApp(App(locale: ValueNotifier<Locale?>(null)));

  // runApp(const App());
}


class App extends StatelessWidget {

  const App({super.key, required this.locale});

  final ValueNotifier<Locale?> locale;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // final materialApp = MaterialApp(
    //   title: 'Hand Note',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: const HomePage(title: 'Notes'),
    //
    //   /// localization:
    //
    //   // localizationsDelegates: AppLocalizations.localizationsDelegates,
    //   // supportedLocales: AppLocalizations.supportedLocales,
    //
    //   locale: localeApp.value,
    //   localizationsDelegates: const [
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate,
    //       GlobalCupertinoLocalizations.delegate,
    //   ],
    //   supportedLocales: languageCodes.map((e) => Locale(e)),
    //
    //   /// named ROUTES:
    //
    //   routes: {
    //     'home_screen': (context) => const HomePage(),
    //     'note_screen': (context) => const EntryPage(),
    //   }
    // ).multiProvider([
    //     ChangeNotifierProvider<EntriesNotifier>(create: (context) => EntriesNotifier()),
    //     ChangeNotifierProvider<CategoriesNotifier>(create: (context) => CategoriesNotifier()),
    //     ChangeNotifierProvider<SettingsNotifier>(create: (context) => SettingsNotifier()),
    // ]);

    return ValueListenableBuilder(
        valueListenable: localeApp,
        builder: (context, value, _) {
            return MaterialApp(
                title: 'Hand Note',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                ),
                home: const HomePage(title: 'Notes'),

                /// localization:

                // localizationsDelegates: AppLocalizations.localizationsDelegates,
                // supportedLocales: AppLocalizations.supportedLocales,

                locale: localeApp.value,
                localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: languageCodes.map((e) => Locale(e)),

                /// named ROUTES:

                routes: {
                    'home_screen': (context) => const HomePage(),
                    'note_screen': (context) => const EntryPage(),
                }
            ).multiProvider([
                ChangeNotifierProvider<EntriesNotifier>(create: (context) => EntriesNotifier()),
                ChangeNotifierProvider<CategoriesNotifier>(create: (context) => CategoriesNotifier()),
                ChangeNotifierProvider<SettingsNotifier>(create: (context) => SettingsNotifier()),
            ]);
        }
    );

    // .wrapChangeProvider(
    //     (context) => EntriesNotifier()
    // );

  }
}

