
import 'package:flutter/widgets.dart';
import '__data.dart';


class NoteListChangeNotifier extends ValueNotifier<List<Note>> {

    NoteListChangeNotifier(List<Note> value) : super(value);

    // Add favorites depending on their status
    void add(Note note) {
        value.add(note);
        notifyListeners();
    }

    // Remove favorites depending on their status
    void remove(Note note) {
        if (value.contains(note)) {
            value.remove(note);
            notifyListeners();
        }
    }

    // Clear the list
    void clear() {
        value.clear();
        notifyListeners();
    }
}