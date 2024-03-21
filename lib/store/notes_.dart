
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '__data.dart';
import 'notes.__notifier.dart';



class EntriesState extends InheritedWidget{
    final NoteListChangeNotifier entriesNotifier;

    const EntriesState({super.key, required this.entriesNotifier, required Widget child})
        : super(child: child);

    static EntriesState of(BuildContext context) {
        return context.dependOnInheritedWidgetOfExactType()!;
    }

    @override
    bool updateShouldNotify(EntriesState oldWidget) {
        return oldWidget.entriesNotifier.value != entriesNotifier.value;
    }
}


extension NotesStateListExtension on Widget{
    toNoteStore(List<Note> entriesList){

        return EntriesState(
            entriesNotifier: NoteListChangeNotifier(entriesList),
            child: this,
        );
    }
}



