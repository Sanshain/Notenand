class Note{
    int? id;
    String value = '';
    late DateTime time;

    Note({this.id, this.value = '', DateTime? time}){
        this.time = time ?? DateTime.now();
    }
}