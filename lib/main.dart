import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hand/pages/note_Page.dart';
import 'package:note_hand/store/__data.dart';
import 'package:note_hand/store/provider_.dart';

import 'home.dart';
// import 'package:styled_widget/styled_widget.dart';


void main() async {
  // final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  // await Hive.initFlutter()
  // Hive.registerAdapter(NoteAdapter());

  await Hive.initFlutter().then((value) {

    Hive.registerAdapter(NoteAdapter());
  });

  // Hive..initFlutter()..registerAdapter(NoteAdapter());

  runApp(
      App(
          notifier: await (EntriesNotifier().init())
      )
  );
}


class App extends StatelessWidget {

  final EntriesNotifier notifier;

  const App({super.key, required this.notifier});

  @override

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Notes'),
      routes: {
        'home_screen': (context) => const HomePage(),
        'note_screen': (context) => const EntryPage(),
      }
    ).wrapChangeProvider(
        (context) => notifier
    );
  }
}

