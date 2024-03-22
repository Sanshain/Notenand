import 'package:flutter/material.dart';


void routeTo(BuildContext context, {Widget? screen}) {
    if (screen != null){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => screen),
        );
    }
}