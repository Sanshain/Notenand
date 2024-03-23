import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
                    child: const Row(children: [Expanded(child: Text('Exit'),)]),
                    onTap: () => Platform.operatingSystem == 'android' ? SystemNavigator.pop() : exit(0),
                )
            ),
        ]);
    }

}