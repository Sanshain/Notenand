import 'package:flutter/widgets.dart';


extension UIExtension on Widget{

    toRow({CrossAxisAlignment? crossAxisAlignment}) {
        return Row(
            children: [this]
        );
    }

    toColumn() {
        return Column(
            children: [this]
        );
    }

}