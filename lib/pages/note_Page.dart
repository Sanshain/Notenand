import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_hand/widgets/extensions_.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

import '../store/__data.dart';
import '../store/provider_.dart';

class EntryPage extends StatefulWidget {

  final Note? note;

  const EntryPage({
    super.key,
    this.note
  });

  @override
  State<EntryPage> createState() => EntryState();
}

class EntryState extends State<EntryPage> {

  final borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.white38, width: 3.0),
  );

  final _editorController = TextEditingController();
  bool readOnly = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New note'),
      ),
      body: Column(
        children: [
          Flexible(
            child: TextField(
              readOnly: readOnly,
              controller: _editorController,
              decoration: InputDecoration(
                hintText: "Enter your entry here...",
                hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(99, 99, 99, .4)
                ),
                filled: true,
                fillColor: Colors.blue.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 3.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColorLight, width: 3.0),
                ),
              ),
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              expands: true,
              maxLines: null,
            ).padding(vertical: 10).gestures(
              onDoubleTap: (){
                setState(() { readOnly = false; });
              }
            ),
          ),
          MaterialButton(
            minWidth: double.maxFinite,
            height: 60,
            color: Colors.blue.shade200,
            onPressed: () {
              Provider.of<EntriesNotifier>(context, listen: false).add(
                  Note(value: _editorController.text)
              );
              Navigator.of(context).pop();
            },
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
            // clipBehavior: Clip.antiAlias,
            child: const Text("Save"), // Add This
          ),
        ],
      ).padding(
          bottom: 15,
          left: 15, right: 15
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _editorController.text = widget.note?.value ?? '';
    readOnly = widget.note != null;
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

}
