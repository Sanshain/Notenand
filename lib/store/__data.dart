
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class Note extends HiveObject{

    // @HiveField(1) int? id;
    @HiveField(1) late int id;
    @HiveField(2) String value = '';

    @HiveField(3) DateTime? lastTime;

    DateTime? _time;

    DateTime get time {
        _time = _time ?? DateTime.fromMillisecondsSinceEpoch(id~/1000);
        return _time!;
    }

    Note({int? id, this.value = '', DateTime? lastTime}){
        this.id = id ?? DateTime.now().microsecondsSinceEpoch;
        lastTime = lastTime ?? time;
    }
}