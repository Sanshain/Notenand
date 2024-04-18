import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_hand/pages/settings_page.dart';

import 'package:note_hand/utils/routes.dart';


class Menu extends StatelessWidget {

    final List<PopupMenuItem<Text>> extraPoints;

    const Menu({super.key, this.extraPoints = const []});

    @override
    Widget build(BuildContext context) {
        return PopupMenuButton<Text>(itemBuilder: (context) =>
        [
            ...extraPoints,
            PopupMenuItem(
                child: GestureDetector(
                    child: const Row(children: [Expanded(child: Text('Settings'),)]),
                    onTap: () {
                        routeTo(context, screen: const SettingsPage());
                    },
                )
            ),
            PopupMenuItem(
                child: GestureDetector(
                    child: const Row(children: [Expanded(child: Text('About'),)]),
                    onTap: () => Platform.operatingSystem == 'android' ? SystemNavigator.pop() : exit(0),
                )
            ),
            PopupMenuItem(
                child: GestureDetector(
                    child: const Row(children: [Expanded(child: Text('Exit'),)]),
                    onTap: () => Platform.operatingSystem == 'android' ? SystemNavigator.pop() : exit(0),
                )
            ),
        ]);
    }

}