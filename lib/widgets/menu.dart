import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_hand/generated/l10n.dart';
import 'package:note_hand/pages/about_page.dart';
import 'package:note_hand/pages/settings_page.dart';

import 'package:note_hand/utils/routes.dart';
import 'package:note_hand/widgets/extensions_.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Menu extends StatelessWidget {

    final List<PopupMenuItem<Text>> extraPoints;
    final bool hideBase;

    const Menu({super.key, this.hideBase = false, this.extraPoints = const []});

    @override
    Widget build(BuildContext context) {

        final basePoints = <PopupMenuItem<Text>>[
            PopupMenuItem(
                child: GestureDetector(
                    child: Row(children: [Expanded(child: Text(
                        AppLocalizations.of(context)?.settingsTitle ?? 'Settings'
                    ),)]),
                    onTap: () {
                        Navigator.of(context).pop();
                        routeTo(context, screen: const SettingsPage());
                    },
                ).expanded().toRow()
            ),
            PopupMenuItem(
                child: GestureDetector(
                    child: Row(children: [Expanded(child: Text(
                        AppLocalizations.of(context)?.aboutTitle ?? 'About'
                    ),)]),
                    onTap: () {
                        routeTo(context, screen: const AboutPage());
                    },
                ).expanded().toRow()
            ),
            PopupMenuItem(
                child: GestureDetector(
                    child: Row(children: [Expanded(child: Text(
                        AppLocalizations.of(context)?.exitButton ?? 'Exit'
                    ),)]),
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