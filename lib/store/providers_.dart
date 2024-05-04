import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '__data.dart';


class SettingsNotifier extends ChangeNotifier{

    Settings? state;

    late Box<Settings> store;

    SettingsNotifier({Future<Box<Settings>>? box}){

        (box ?? Hive.openBox<Settings>('settings')).then((database) {
            store = database;
            state = database.get('settings');
            if (state != null){
                notifyListeners();
            }
        });
    }

    void update(){
        notifyListeners();
        state?.save();
    }
}



class AbstractNotifier<T extends HiveObject> extends ChangeNotifier{
    List<T> values = List.from([]);

    late Box<T> database;

    void add(T value) {
        values.add(value);
        database.add(value);
        notifyListeners();
    }

    /// call after object fields editing
    void update(T note){
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
            values = database.values.where((entry) => entry.isArchived == false).toList();
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

    void moveToArchive(Set<int> selected, {bool back = false}) {

        final sortedSelected = selected.toList(growable: false)
            ..sort((a, b) => a.compareTo(b));
        for (int i = sortedSelected.length - 1; i >= 0; i--) {
            final id = sortedSelected[i];
            final movingNotes = values.where((item) => item.id == id).toList();

            for (var note in movingNotes) {
                note.isArchived = !back;
                values.remove(note);
                note.save();
            }
        }
        notifyListeners();
    }

    void remove(Set<int> selected){
        // for (var position in selected) {
        //     values.removeAt(position);
        //     database.deleteAt(position);
        // }

        final sortedSelected = selected.toList(growable: false)..sort((a, b) => a.compareTo(b));
        for (int i = sortedSelected.length - 1; i >= 0; i--) { final id = sortedSelected[i];

            int index = database.values.toList().indexWhere((item) {
                if (item.id == id) {
                    values.remove(item);
                    return true;
                }
                return false;
            });
            database.deleteAt(index);
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

    Iterable<Note> getByCategory({Category? category, bool isArchived = false}){
        if (category == null) {

            values = database.values
                .where((note) => note.isArchived == isArchived)
                .toList();
        }
        else{

            values = database.values
                .where((entry) => entry.isArchived == isArchived)
                .where((entry) => entry.category == category)
                .toList();
        }
        notifyListeners();
        return values;
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