import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_hand/pages/about_page.dart';
import 'package:note_hand/pages/settings_page.dart';

import 'package:note_hand/utils/routes.dart';
import 'package:note_hand/widgets/extensions_.dart';
import 'package:styled_widget/styled_widget.dart';


class Menu extends StatelessWidget {

    final List<PopupMenuItem<Text>> extraPoints;
    final bool hideBase;

    const Menu({super.key, this.hideBase = false, this.extraPoints = const []});

    @override
    Widget build(BuildContext context) {

        final basePoints = <PopupMenuItem<Text>>[
            PopupMenuItem(
                child: GestureDetector(
                    child: const Row(children: [Expanded(child: Text('Settings'),)]),
                    onTap: () {
                        routeTo(context, screen: const SettingsPage());
                    },
                ).expanded().toRow()
            ),
            PopupMenuItem(
                child: GestureDetector(
                    child: const Row(children: [Expanded(child: Text('About'),)]),
                    onTap: () {
                        routeTo(context, screen: const AboutPage());
                    },
                ).expanded().toRow()
            ),
            PopupMenuItem(
                child: GestureDetector(
                    child: const Row(children: [Expanded(child: Text('Exit'),)]),
                    onTap: () => Platform.operatingSystem == 'android' ? SystemNavigator.pop() : exit(0),
                ).expanded().toRow()
            ),
        ];

        return PopupMenuButton<Text>(itemBuilder: (context) =>
        [
            ...extraPoints,
            if (hideBase == false)
                ...basePoints
        ]);
    }

}