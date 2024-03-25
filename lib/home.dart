import 'dart:math';

import 'package:flutter/material.dart';
import 'package:note_hand/pages/note_Page.dart';
import 'package:note_hand/store/__data.dart';
import 'package:note_hand/store/providers_.dart';
import 'package:note_hand/utils/routes.dart';
import 'package:note_hand/widgets/alerts/input.dart';
import 'package:note_hand/widgets/alerts/yesno.dart';
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
    Set<int> selected = {};

    void _incrementCounter() {
        // setState(() {
        //     notesAmount++;
        // });
    }

    @override
    Widget build(BuildContext context) {

        // final entriesNotifier = EntriesState.of(context).entriesNotifier;

        final entriesList = Provider.of<EntriesNotifier>(context);
        final categoriesList = Provider.of<CategoriesNotifier>(context);

        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,      // light gray
                // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,      // light gray
                // backgroundColor: Theme.of(context).colorScheme.inverseSurface,      // dark mode
                // backgroundColor: Theme.of(context).colorScheme.inversePrimary,   // violent
                title: Text(widget.title),
                actions: [
                    Menu(extraPoints: [
                        if (selected.isNotEmpty)
                            PopupMenuItem(
                                child: GestureDetector(
                                    child: const Row(children: [Expanded(child: Text('Move to archive'),)]),
                                    onTap: () async {
                                        // final r = await showConfirmDialog(context, text: "Are you sure?");
                                        // if (r == true){}
                                        Provider.of<EntriesNotifier>(context, listen: false).remove(selected);
                                        selected.clear();
                                        Navigator.of(context).pop();
                                    },
                                )
                            ),
                    ],)
                ],
            ),
            drawer: Drawer(
                child: ListView(
                    children: [
                        DrawerHeader(
                            padding: const EdgeInsets.all(60),
                            // child: Text("Menu:"),
                            // child: FloatingActionButton.extended(
                            //     label: const Text('Add category'), // <-- Text
                            //     backgroundColor: Colors.lightBlueAccent,
                            //     icon: const Icon( // <-- Icon
                            //         Icons.download,
                            //         size: 24.0,
                            //     ),
                            //     onPressed: () {},
                            // ),
                            // child: Text("Menu:"),
                            // child: FloatingActionButton.extended(
                            //     label: const Text('Add category'), // <-- Text
                            //     backgroundColor: Colors.lightBlueAccent,
                            //     icon: const Icon( // <-- Icon
                            //         Icons.download,
                            //         size: 24.0,
                            //     ),
                            //     onPressed: () {},
                            // ),
                            child: MaterialButton(
                                onPressed: () async {
                                    final title = await showInputDialog(context, 'Enter new category title:');
                                    if (title != null) {
                                        final category = Category(title);
                                        // category.save();
                                        categoriesList.add(category);
                                    }
                                },
                                color: Colors.orangeAccent,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                                // shape: const CircleBorder(),
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(48.0) ),
                                child: [
                                    const Icon(Icons.add, size: 24,),
                                    const Text('Add category'),
                                ].toRow(mainAxisAlignment: MainAxisAlignment.center),
                            ),
                            // decoration: BoxDecoration(color: Colors.green),
                        ),
                        ...categoriesList.values.map((category) {
                            return ListTile(
                                title: Text(category.name),
                                leading: const Icon(Icons.home),
                                // trailing: const Icon(Icons.arrow_downward),
                                onTap: () {
                                    // go to

                                    // TODO rename category in other menu
                                    // TODO remove category in other menu if it does not consist of points
                                    Navigator.of(context).pop();
                                },
                            );
                        })
                    ],
                ),
            ),
            body: ListView.builder(
                // itemCount: Provider.of<List<Note>>(context).length,
                itemCount: Provider.of<EntriesNotifier>(context).values.length,
                itemBuilder: (context, position) {

                    final note = entriesList.values[position];
                    final firstline = note.value.split('\n')[0];
                    final shortHand = min(firstline.length, 25);

                    final title = firstline.substring(0, shortHand) + (firstline.length > shortHand ? '...' : '');

                    return Card(
                        // color: selected.contains(entriesList.values[position].id) ? Colors.lightBlueAccent : null,
                        color: selected.contains(position) ? Colors.lightBlueAccent : null,
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    title + (title.length < note.value.length ? '...' : ''),
                                    style: const TextStyle(fontSize: 22.0),
                                ),
                                Text(
                                    note.time.toString().split(RegExp(":\\d+\\."))[0],
                                    style: const TextStyle(fontSize: 13.0, color: Colors.grey),
                                ),
                              ],
                            ),
                        ),
                    ).gestures(
                        onTap: (){
                            if (selected.isNotEmpty){
                                // final id = entriesList.values[position].id;
                                final id = position;
                                setState(() {
                                    if (selected.contains(id)) {
                                        selected.remove(id);
                                    } else {
                                        selected.add(id);
                                    }
                                });
                            }
                            else{
                                routeTo(context, screen: EntryPage(note: note,));
                            }
                        },
                        onLongPress: (){
                            setState(() {
                                selected.add(position);
                                // selected.add(entriesList.values[position].id);
                            });
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
