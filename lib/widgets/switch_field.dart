import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class SwitchField extends StatelessWidget {

  final bool defaultValue;
  final void Function(bool) onChange;
  final String desc;

  const SwitchField(this.desc, {super.key, required this.defaultValue, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return [
      // const Text('Show category on list page (beta)'),
      Text(desc),
      CupertinoSwitch(
        value: defaultValue,
        activeColor: Colors.lightBlueAccent,
        onChanged: onChange,
        // onChanged: (value) {
        //     setState(() {
        //         settings.showKindsInList = value;
        //     });
        // },
      ),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(top: 30);
  }
}
