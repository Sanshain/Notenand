import 'package:flutter/material.dart';



Future<String?> showInputDialog(BuildContext context, String description, {String hint = '', String ok = 'OK'}) async {

    final textFieldController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
            return AlertDialog(
                title: Text(description),
                content: TextField(
                    autofocus: true,
                    controller: textFieldController,
                    decoration: InputDecoration(hintText: hint),
                ),
                actions: <Widget>[
                    MaterialButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(ok),
                        onPressed: () {
                            Navigator.of(context).pop(textFieldController.value.text);
                        },
                    ),
                    MaterialButton(
                        color: Colors.grey,
                        textColor: Colors.white,
                        child: const Text('Cancel'),
                        onPressed: () { Navigator.of(context).pop(); },
                    ),
                ],
            );
        });
}