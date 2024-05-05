import 'dart:math';

import 'package:flutter/material.dart';
import 'package:note_hand/pages/note_Page.dart';
import 'package:note_hand/store/__data.dart';
import 'package:note_hand/store/providers_.dart';
import 'package:note_hand/utils/routes.dart';
import 'package:note_hand/widgets/alerts/choice.dart';
import 'package:note_hand/widgets/alerts/input.dart';
import 'package:note_hand/widgets/alerts/yesno.dart';
import 'package:note_hand/widgets/extensions_.dart';
import 'package:note_hand/widgets/menu.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'Notes'});

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// stated fields:

  bool initialized = false;
  int notesAmount = 3;
  Set<int> selected = {};
  Category? usedCategory;
  bool inArchive = false;

  SettingsNotifier? settingsStore;
  late EntriesNotifier entriesList;
  late CategoriesNotifier categoriesList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    settingsStore = Provider.of<SettingsNotifier>(context);

    entriesList = Provider.of<EntriesNotifier>(context);

    categoriesList = Provider.of<CategoriesNotifier>(context);

    if (!initialized && settingsStore!.state.defaultCategory.isNotEmpty) {
      usedCategory = Category(settingsStore!.state.defaultCategory);
      initialized = true;
      // usedCategory = categoriesList.values.firstWhere((kind) => kind.name == settingsStore!.state.defaultCategory);
      // entriesList.values = entriesList.getByCategory(categoryName: settingsStore!.state.defaultCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final entriesNotifier = EntriesState.of(context).entriesNotifier;

    final settings = settingsStore!.state;

    // final entriesList = Provider.of<EntriesNotifier>(context);

    final entriesStore = Provider.of<EntriesNotifier>(context, listen: false);

    final localDiction = AppLocalizations.of(context);

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant, // light gray
        // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,      // light gray
        // backgroundColor: Theme.of(context).colorScheme.inverseSurface,      // dark mode
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,   // violent
        title: Text(usedCategory?.name ?? (inArchive ? (localDiction?.archive ?? 'Archive') : (AppLocalizations.of(context)?.appTitle ?? widget.title))),
        actions: [
          Menu(
            hideBase: selected.isNotEmpty || (usedCategory != null),
            extraPoints: [
              if (usedCategory != null && selected.isEmpty)
                PopupMenuItem(
                    child: GestureDetector(
                      child: const Row(children: [
                        Icon(Icons.arrow_back, color: Colors.blue,),
                        Expanded(
                          child: Text('  Back'),
                        )
                      ]),
                      onTap: () {
                        setState(() {
                          usedCategory = null;
                        });
                        entriesList.values = entriesList.getByCategory(categoryName: usedCategory?.name).toList();

                        Navigator.of(context).pop();
                      }
                    )),
              if (usedCategory != null && selected.isEmpty)
                PopupMenuItem(
                    child: GestureDetector(
                      child: const Row(children: [
                        Expanded(
                          child: Text('Rename category'),
                        )
                      ]),
                      onTap: () async {
                        final title = await showInputDialog(context, 'Rename category', text: usedCategory?.name ?? '');
                        if (title != null) {
                          usedCategory?.name = title;
                          categoriesList.update(usedCategory!);

                          // usedCategory?.save();

                          // // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          // categoriesList.notifyListeners();
                        }
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                  )
                ),
              if (usedCategory != null && selected.isEmpty)
                PopupMenuItem(
                    child: GestureDetector(
                  child: const Row(children: [
                    Expanded(
                      child: Text('Remove category'),
                    )
                  ]),
                  onTap: () async {
                    final affirmed = await showConfirmDialog(
                      context,
                      text:
                          'Are tou sure you want to delete the category? ${entriesList.values.isNotEmpty ? '${entriesList.values.length} entries will be removed permanently!' : ''}',
                    );
                    if (affirmed == true) {
                      categoriesList.remove(categoriesList.values.indexOf(usedCategory!));
                      setState(() {
                        usedCategory = null;
                      });
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                )),
              if (inArchive == false && categoriesList.values.isNotEmpty && selected.isNotEmpty)
                PopupMenuItem(
                    child: GestureDetector(
                  child: const Row(children: [
                    Expanded(
                      child: Text('To category'),
                    )
                  ]),
                  onTap: () async {
                    final categoryName = await choiceDialog(context, categoriesList.values.map((e) => e.name), title: 'Move to');
                    if (categoryName != null) {
                      final selectedCategory = categoriesList.values.firstWhere((cat) => cat.name == categoryName);

                      entriesList.values.where((e) => selected.contains(e.id)).forEach((entry) {
                        entry.category = selectedCategory;
                        entriesList.update(entry);
                      });

                      // for (final entry in selected) {
                      //     entriesList.values.firstWhere((e) => e.id == entry);
                      //     // print(entry);
                      //     // entriesList.values[entry].category = selectedCategory;
                      //     // entriesList.values[entry].save();
                      // }
                    }

                    Future.delayed(const Duration(milliseconds: 350), () {
                      setState(() {
                        selected.clear();
                      });
                    });

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                )),
              if (selected.isNotEmpty) ...[
                if (inArchive)
                  PopupMenuItem(
                      child: GestureDetector(
                    child: const Row(children: [
                      Expanded(
                        child: Text('Back'),
                      )
                    ]),
                    onTap: () async {
                      entriesStore.moveToArchive(selected, back: true);
                      selected.clear();

                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  )),
                PopupMenuItem(
                    child: GestureDetector(
                  child: Row(children: [
                    Expanded(
                      child: Text(inArchive ? 'Remove' : 'Move to archive'),
                    )
                  ]),
                  onTap: () async {
                    if (inArchive) {
                      final r = await showConfirmDialog(context, text: 'Are you sure you want to remove the notes?');
                      if (r == true) {
                        entriesStore.remove(selected);
                      }
                    } else {
                      entriesStore.moveToArchive(selected);
                    }

                    selected.clear();
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                )),
              ]
            ],
          )
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
                  final title = await showInputDialog(context, 'Enter new category title');
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48.0)),
                child: [
                  const Icon(
                    Icons.add,
                    size: 24,
                  ),
                  // const Text('Add category'),
                  Text(AppLocalizations.of(context)?.addCategoryButton ?? 'Add category'),
                ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              ),
              // decoration: BoxDecoration(color: Colors.green),
            ).sized(height: 180),
            if (usedCategory != null || inArchive)
              ListTile(
                // title: const Text('All'),
                title: Text(localDiction?.all ?? 'All'),
                leading: const Icon(Icons.home),
                // trailing: const Icon(Icons.arrow_downward),
                onTap: () {
                  setState(() {
                    usedCategory = null;
                    inArchive = false;
                  });
                  entriesList.values = entriesList.getByCategory(categoryName: usedCategory?.name).toList();

                  Navigator.of(context).pop();
                },
              ),
            ...categoriesList.values.map((category) {
              return ListTile(
                title: Text(category.name),
                // leading: const Icon(Icons.home),
                // trailing: const Icon(Icons.arrow_downward),
                onTap: () {
                  // go to

                  entriesList.values = entriesList.getByCategory(categoryName: category?.name).toList();
                  Future.delayed(const Duration(microseconds: 450), () {
                    setState(() {
                      usedCategory = category;
                      inArchive = false;
                    });
                  });

                  // TODO rename category in other menu
                  // TODO remove category in other menu if it does not consist of points
                  Navigator.of(context).pop();
                },
              );
            }),
            ListTile(
              // title: const Text('Archive'),
              title: Text(localDiction?.archive ?? "Archive"),
              // textColor: Colors.grey,
              leading: const Icon(Icons.archive_outlined),
              // trailing: const Icon(Icons.arrow_downward),
              onTap: () {
                setState(() => usedCategory = null);
                entriesList.values = entriesList.getByCategory(categoryName: usedCategory?.name, isArchived: true).toList();

                Future.delayed(const Duration(microseconds: 450), () {
                  setState(() {
                    inArchive = true;
                  });
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: settingsStore?.loaded != true
          ? const SpinKitRotatingCircle(
              color: Colors.white,
              size: 50.0,
            )
          : ListView.builder(
              // itemCount: Provider.of<List<Note>>(context).length,
              itemCount: Provider.of<EntriesNotifier>(context).values.length,
              itemBuilder: (context, position) {
                final note = entriesList.values[position];

                final title = note.thetitle;

                // final title = firstline.substring(0, shortedTitle);

                if (settings.showKindsInList && usedCategory == null && note.category != null) {
                  return const SizedBox(height: 0);
                }

                return Card(
                  color: selected.contains(entriesList.values[position].id) ? Colors.lightBlueAccent : null,
                  // color: selected.contains(position) ? Colors.lightBlueAccent : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          // title[0].toUpperCase() + title.substring(1),
                          style: const TextStyle(fontSize: 22.0),
                        ),
                        [
                          Text(
                            note.time.toString().split(RegExp(":\\d+\\."))[0],
                            style: const TextStyle(fontSize: 13.0, color: Colors.grey),
                          ),
                          if (note.category != null)
                            Text(
                              note.category?.name ?? '',
                              style: const TextStyle(fontSize: 13.0, color: Colors.black26),
                            ).padding(horizontal: 10).decorated(borderRadius: const BorderRadius.all(Radius.circular(20)), color: Colors.blue.shade100),
                        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      ],
                    ),
                  ),
                ).gestures(onTap: () {
                  if (selected.isNotEmpty) {
                    final id = entriesList.values[position].id;
                    // final id = position;
                    setState(() {
                      if (selected.contains(id)) {
                        selected.remove(id);
                      } else {
                        selected.add(id);
                      }
                    });
                  } else {
                    routeTo(context,
                        screen: EntryPage(
                          note: note,
                        ));
                  }
                }, onLongPress: () {
                  setState(() {
                    final id = entriesList.values[position].id;
                    selected.add(id);
                    // selected.add(position);
                    // selected.add(entriesList.values[position].id);
                  });
                });
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
        onPressed: () {
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
