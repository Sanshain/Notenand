import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hand/pages/note_Page.dart';
import 'package:note_hand/store/provider_.dart';

import 'home.dart';
// import 'package:styled_widget/styled_widget.dart';


void main() async {
  await Hive.initFlutter();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
        (context) => EntriesNotifier()
    );
  }
}

