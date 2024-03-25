import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '__data.dart';



class AbstractNotifier<T extends HiveObject> extends ChangeNotifier{
    List<T> values = List.from([]);

    late Box<T> database;

    void add(T value) {
        values.add(value);
        database.add(value);
        notifyListeners();
    }

    /// call after object fields editing
    void update(Note note){
        notifyListeners();
        note.save();
    }

    void remove(int position){
        values.removeAt(position);
        database.deleteAt(position);
        notifyListeners();
    }
}


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

    // void addCategory(Note note) {
    //     values.add(note);
    //     database.add(note);
    //     notifyListeners();
    // }

    void add(Note note) {
        values.add(note);
        database.add(note);
        notifyListeners();
    }

    void remove(Set<int> selected){
        for (var position in selected) {
            values.removeAt(position);
            database.deleteAt(position);
        }
        // values.removeWhere((note) {
        //     if(selected.contains(note.id)){
        //         database.delete(note);               // <--- that's problem (does not delete by key)
        //         // database.deleteAt(index)          // <--- index is unknown here (may be i can separately iterate, but it can lead to any bugs (i guess))
        //         return true;
        //     }
        //     return false;
        // });
        notifyListeners();
    }

    void update(Note note){
        notifyListeners();
        note.save();
    }
}


class CategoriesNotifier extends AbstractNotifier<Category>{

    CategoriesNotifier() : super(){
        Hive.openBox<Category>('categories').then((box) {   // 1
            values = (database = box).values.toList();
            notifyListeners();
        });
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