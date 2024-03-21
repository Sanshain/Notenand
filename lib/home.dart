import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_hand/store/__data.dart';
import 'package:note_hand/store/notes_.dart';

class HomePage extends StatefulWidget {

    const HomePage({super.key, required this.title});

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

        final entriesNotifier = EntriesState.of(context).entriesNotifier;

        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
            ),
            // body: ListView.builder(
            //     itemCount: notesAmount,
            //     itemBuilder: (context, position) {
            //         return Card(
            //             child: Padding(
            //                 padding: const EdgeInsets.all(16.0),
            //                 child: Text(position.toString(), style: const TextStyle(fontSize: 22.0),),
            //             ),
            //         );
            //     },
            // ),
            body: ValueListenableBuilder<List<Note>>(
                valueListenable: entriesNotifier,
                builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, position) {
                            return Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(position.toString(), style: const TextStyle(fontSize: 22.0),),
                                ),
                            );
                        },
                    );
                },
            ),
            floatingActionButton: FloatingActionButton(
                // onPressed: _incrementCounter,
                onPressed: (){
                    entriesNotifier.add(Note(value: ''));
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
        );
    }
}
