import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '__data.dart';



class EntriesNotifier extends ChangeNotifier {
    List<Note> values = List<Note>.from([]);
    late Box<Note> database;

    EntriesNotifier() : super() {
        Hive.openBox<Note>('entries').then((box) {
            database = box;
            values = database.values.toList();
            notifyListeners();
        });
    }

    void add(Note note) {
        values.add(note);
        database.add(note);
        notifyListeners();
    }
}



extension ProviderExtensions on Widget{

    wrapProvider(List<Note> entriesList){

        return Provider<List<Note>>(
            create: (context) => entriesList,
            child: this
        );
    }


    wrapChangeProvider<T extends ChangeNotifier>(T Function(BuildContext context) oncreate){

        return ChangeNotifierProvider<T>(
            /// => expected EntriesNotifier, but got _Type
            // create: (context) => (T as T Function())(),
            create: oncreate,
            child: this
        );
    }

    multiProvider(List<ChangeNotifierProvider> providers){

        return MultiProvider(
            providers: providers,
            child: this
        );
    }


    // wrapEntriesChangeProvider(){
    //
    //     return ChangeNotifierProvider<EntriesNotifier>(
    //         create: (context) => EntriesNotifier(),
    //         child: this
    //     );
    // }
}