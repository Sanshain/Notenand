import 'package:flutter/widgets.dart';
import 'package:styled_widget/styled_widget.dart';


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

    popScope(context, Function(bool didPop) onPop, {bool canPop = false}){
        // bool alreadyPopped = true;
        //
        // return PopScope(
        //     canPop: alreadyPopped,
        //     onPopInvoked : onPop,
        //     child: this,
        // );

        return PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
                if (didPop) return;
                onPop(true);
                Navigator.of(context).pop();
            },

            // canPop: true,
            // onPopInvoked: (didPop) {
            //     if (didPop) return;
            //     forYouGetAllData?.call();
            // },

            child: this,
        );
    }

    sized({double? height, double? width}){
        return SizedBox(
            height: height,
            child: this,
        );
    }

}