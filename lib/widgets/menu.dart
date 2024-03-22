import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Menu extends StatelessWidget{

    const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Text>(itemBuilder: (context) => [
        PopupMenuItem(
            child: GestureDetector(
                child: const Row(children: [Expanded(child: Text('exit'),)]),
                onTap: () => Platform.operatingSystem == 'android' ? SystemNavigator.pop() : exit(0),
            )
        ),
    ]);
  }

}