import 'package:flutter/material.dart';


Future<bool?> showConfirmDialog(BuildContext context, {title = '', required text}) {

    // set up the buttons
    Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed:  () {
            Navigator.of(context).pop(false);
        },
    );

    Widget continueButton = TextButton(
        child: const Text("Ok"),
        onPressed:  () {
            Navigator.pop(context, true);
        },
    );

    // set up the AlertDialog
    AlertDialog messageBox = AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
            cancelButton,
            continueButton,
        ],
    );

    // show the dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
            return messageBox;
        },
    );
}