
import 'package:hive_flutter/hive_flutter.dart';

part '__data.g.dart';


@HiveType(typeId: 0)
class Note extends HiveObject{

    // @HiveField(1) int? id;
    @HiveField(1) late int id;
    @HiveField(2) String value = '';

    @HiveField(3) DateTime? lastTime;
    @HiveField(4) Category? category;

    @HiveField(5) bool isArchived = false;

    DateTime? _time;

    DateTime get time {
        _time = _time ?? DateTime.fromMillisecondsSinceEpoch(id~/1000);
        return _time!;
    }

    Note({int? id, this.value = '', DateTime? lastTime}){
        this.id = id ?? DateTime.now().microsecondsSinceEpoch;
        lastTime = lastTime ?? time;
    }

    String get thetitle {
        return Note.getTitle(value);
    }


    static String getTitle(String body){
        final firstline = body.split('\n')[0];
        final firstLetters = firstline.split(':')[0];
        // final shortedTitle = min(firstLetters.length, 25);

        var wholeTitle = '';
        final words = firstLetters.split(' ');
        for (var w in words) {
            wholeTitle += (wholeTitle.isNotEmpty ? ' ' : '') + w;
            if (wholeTitle.length > 25){
                wholeTitle += '...';
                break;
            }
        }
        return wholeTitle;
    }
}


@HiveType(typeId: 1)
class Category extends HiveObject{
    @HiveField(1) String name;

    /// codePoint
    @HiveField(2) int? icon;

    Category(this.name);
}


@HiveType(typeId: 2)
class Settings extends HiveObject{
    /// show categorised notes in a common notes list /showAll/
    @HiveField(1) bool showKindsInList = true;

    @HiveField(2) String defaultCategory = '';

    @HiveField(3) String language = 'English';

    @HiveField(4) String? email;

    @HiveField(5) bool? darkTheme = false;
}