import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_hand/widgets/extensions_.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:note_hand/widgets/extensions_.dart';

import '../store/__data.dart';
import '../store/providers_.dart';
import '../utils/validators.dart';
import '../widgets/alerts/yesno.dart';



Box<dynamic>? settingsDB;


class SettingsPage extends StatefulWidget {

    const SettingsPage({super.key});

    @override
    State<SettingsPage> createState() => EntryState();
}

class EntryState extends State<SettingsPage> {

    int attempts = 0;
    final _form = GlobalKey<FormState>();

    final emailController = TextEditingController();
    final FocusNode emailFocusNode = FocusNode();

    @override
    void initState() {
        super.initState();

        Hive.openBox('settings').then((settings){
            settingsDB = settings;
            setState(() {
                emailController.text = settingsDB?.get('email') ?? '';
            });
        });

        // autofocus = widget.note == null;
    }

    @override
    Widget build(BuildContext context) {


        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                title: const Text('Settings'),
            ),
            body: <Widget>[
                Row(children: <Widget>[
                    TextFormField(
                        // focusNode: emailFocusNode,

                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,

                        // autovalidateMode: AutovalidateMode.always,
                        validator: validateEmail,

                        style: const TextStyle(color: Colors.blueGrey),
                        decoration: const InputDecoration(
                            // hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                            // hintText: 'Enter valid e-mail',
                            labelText: 'Enter e-mail',
                        ),
                    ).expanded(),
                ]),
                const Expanded(child: Text('')),
                MaterialButton(
                    minWidth: double.maxFinite,
                    height: 60,
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () async {

                        if (_form.currentState?.validate() == true){
                            settingsDB = settingsDB ?? await Hive.openBox('settings');
                            settingsDB?.put('email', emailController.value.text);
                        }

                    },
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                    // clipBehavior: Clip.antiAlias,
                    child: const Text("Save"), // Add This
                ),
            ].toColumn().toForm(key: _form).padding(
                bottom: 15,
                left: 15, right: 15
            ),
        ).popScope(context, (didPop) {
            if (_form.currentState?.validate() == true){
                if (settingsDB != null){
                    settingsDB?.put('email', emailController.value.text);
                }
                else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Db error. Try again please'),
                    ));
                    return ++attempts > 1; // one attempt
                }
            }
            return true;
        });
    }

    @override
    void dispose() {
        emailController.dispose();
        super.dispose();
    }

}
