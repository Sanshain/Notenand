import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_hand/pages/settings_page.dart';
import 'package:note_hand/widgets/extensions_.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

import '../store/__data.dart';
import '../store/providers_.dart';
import '../widgets/alerts/choice.dart';
import '../widgets/alerts/input.dart';
import '../widgets/alerts/yesno.dart';
import '../widgets/menu.dart';

class EntryPage extends StatefulWidget {
  final Note? note;

  const EntryPage({super.key, this.note});

  @override
  State<EntryPage> createState() => EntryState();
}

class EntryState extends State<EntryPage> {
  final borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: Colors.white38, width: 3.0),
  );

  final _editorController = TextEditingController();
  bool autofocus = false;
  String currentCategory = '';



  @override
  Widget build(BuildContext context) {

    final categoriesList = Provider.of<CategoriesNotifier>(context);

    final note = widget.note;


    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              Text(widget.note == null ? 'New note' : ('Editing...')), // $currentCategory
              if (currentCategory.isNotEmpty)
                Text(currentCategory, style: TextStyle(color: Colors.blue.shade200),),
            ],
          ),
          actions: [
            PopupMenuButton<Text>(
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: GestureDetector(
                      child: const Row(children: [
                        Expanded(
                          child: Text('To email'),
                        )
                      ]),
                      onTap: () async {
                        settingsDb = settingsDb ?? await Hive.openBox('settings');
                        var recipient = settingsDb?.get('email') ?? '';

                        final Email email = Email(
                          body: _editorController.text,
                          subject: Note.getTitle(_editorController.text),
                          recipients: [recipient],
                          // cc: ['cc@example.com'],
                          isHTML: false,
                        );

                        FlutterEmailSender.send(email);
                      },
                    )
                ),
                PopupMenuItem(
                  child: const Text('Change category').gestures(
                    onTap: () async {
                      final categoryName = await choiceDialog(
                          context, [...categoriesList.values.map((e) => e.name), '-----'], title: 'Move to'
                      );
                      if (categoryName != null) {
                        if (categoryName != '-----'){
                          final selectedCategory = categoriesList.values.firstWhere((cat) => cat.name == categoryName);
                          widget.note?.category = selectedCategory;
                          setState(() { currentCategory = ' ($categoryName)'; });
                        }
                        else{
                          widget.note?.category = null;
                          setState(() { currentCategory = ''; });
                        }

                        widget.note?.save();

                        if (mounted){
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  ),
                )
              ],
            ),
          ]),
      body: Column(
        children: [
          Flexible(
            child: TextField(
              autofocus: autofocus,
              // readOnly: readOnly,
              controller: _editorController,
              decoration: InputDecoration(
                hintText: "Enter your entry here...",
                hintStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Color.fromRGBO(99, 99, 99, .4)),
                filled: true,
                // fillColor: Colors.blue.shade100,
                fillColor: Theme.of(context).colorScheme.background,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColorLight, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColorLight, width: 1.5),
                  // borderSide: BorderSide(color: Colors.blue.shade200, width: 3.0),
                ),
              ),
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              expands: true,
              maxLines: null,
            ).padding(vertical: 5).gestures(
                // onDoubleTap: (){
                //   setState(() { readOnly = false; });
                // }
                ),
          ),
          MaterialButton(
            minWidth: double.maxFinite,
            height: 60,
            // color: Colors.blue.shade200,
            color: Theme.of(context).secondaryHeaderColor,
            onPressed: () async {
              if (_editorController.text.length > 1) {
                saveNote(context);
                Navigator.of(context).pop();
              } else {
                /// is empty
                bool? resp = await showConfirmDialog(context, text: 'The note is empty. Are you sure you want to exit?');
                if (resp == true) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
            // clipBehavior: Clip.antiAlias,
            child: const Text("Save"), // Add This
          ),
        ],
      ).padding(bottom: 15, left: 15, right: 15),
    ).popScope(context, (didPop) {
      if (_editorController.text.trim().isNotEmpty) {
        saveNote(context);
      }
      return true;
    });
  }

  void saveNote(BuildContext context) {
    final entryStore = Provider.of<EntriesNotifier>(context, listen: false);

    if (widget.note == null) {
      /// create new
      entryStore.add(Note(value: _editorController.text));
    } else {
      /// change existing
      widget.note?.value = _editorController.text;
      entryStore.update(widget.note!);
    }
  }

  @override
  void initState() {
    super.initState();
    _editorController.text = widget.note?.value ?? '';
    autofocus = widget.note == null;
    if (widget.note?.category != null){
      currentCategory = ' (${widget.note?.category?.name ?? ''})';
    }
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }
}
