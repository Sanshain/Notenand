import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_hand/pages/note_Page.dart';
import 'package:note_hand/store/__data.dart';
import 'package:note_hand/store/provider_.dart';
import 'package:note_hand/utils/routes.dart';
import 'package:note_hand/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends StatefulWidget {

    const HomePage({super.key, this.title = 'Notes'});

    // This class is the configuration for the state. It holds the values (in this
    // case the title) provided by the parent (in this case the App widget) and
    // used by the build method of the State. Fields in a Widget subclass are
    // always marked "final".

    final String title;

    @override State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
    int notesAmount = 3;

    void _incrementCounter() {
        // setState(() {
        //     notesAmount++;
        // });
    }

    @override
    Widget build(BuildContext context) {

        // final entriesNotifier = EntriesState.of(context).entriesNotifier;

        final entriesList = Provider.of<EntriesNotifier>(context).values;

        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
                actions: const [
                    Menu()
                ],
            ),
            body: ListView.builder(
                // itemCount: Provider.of<List<Note>>(context).length,
                itemCount: Provider.of<EntriesNotifier>(context).values.length,
                itemBuilder: (context, position) {

                    final note = entriesList[position];
                    // final line = note.value.split('\n')[0];
                    final title = note.value.substring(0, min(note.value.length, 25));

                    return Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                title + (title.length < note.value.length ? '...' : ''),
                                style: const TextStyle(fontSize: 22.0),
                            ),
                        ),
                    ).gestures(
                        onTap: (){
                            routeTo(context, screen: EntryPage(note: note,));
                        }
                    );
                },
            ),
            // body: ValueListenableBuilder<List<Note>>(
            //     valueListenable: entriesNotifier,
            //     builder: (context, value, _) {
            //         return ListView.builder(
            //             itemCount: Provider.of<List<Note>>(context).length,
            //             itemBuilder: (context, position) {
            //                 return Card(
            //                     child: Padding(
            //                         padding: const EdgeInsets.all(16.0),
            //                         child: Text(position.toString(), style: const TextStyle(fontSize: 22.0),),
            //                     ),
            //                 );
            //             },
            //         );
            //     },
            // ),
            floatingActionButton: FloatingActionButton(
                // onPressed: _incrementCounter,
                onPressed: (){
                    // entriesNotifier.add(Note(value: ''));

                    routeTo(context, screen: const EntryPage());

                    // Provider.of<EntriesNotifier>(context, listen: false).add(
                    //     Note(value: '')
                    // );
                },
                tooltip: 'New note',
                child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
        );
    }
}
