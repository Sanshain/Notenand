import 'package:flutter/material.dart';

///
/// окно выбора из нескольких вариантов
///
Future<String?> choiceDialog(BuildContext context, Iterable<String> options, {title = ''}) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
            return SimpleDialog(
                title: Text(title),
                children: [
                    for (var option in options)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SimpleDialogOption(
                                onPressed: () => Navigator.pop(context, option),
                                child: Text(option),
                            ),
                        )
                ]
            );
        }
    );
}