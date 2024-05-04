import 'package:flutter/material.dart';
import 'package:note_hand/store/__data.dart';
import 'package:styled_widget/styled_widget.dart';

class DropDownList extends StatelessWidget {

    final List<String> categoriesList;
    final void Function(String? v)? onChange;
    final GlobalKey<State<StatefulWidget>>? dropdownState;
    final String defaultValue;
    final Color? color;

    const DropDownList(this.categoriesList, {
        super.key, this.onChange, this.dropdownState, required this.defaultValue, this.color
    });

    @override
    Widget build(BuildContext context) {
        return DropdownButton<String>(
            key: dropdownState,
            // decoration: InputDecoration(
            //   contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            //   filled: true,
            //   fillColor: Colors.grey[200],
            // ),
            alignment: AlignmentDirectional.centerEnd,
            style: const TextStyle(backgroundColor: Colors.white),
            isExpanded: true,
            selectedItemBuilder: (BuildContext context) {
                return categoriesList.map<Widget>((String item) {
                    return Container(
                        alignment: Alignment.centerRight,
                        // width: 180,
                        child: Text(
                            item,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                backgroundColor: Colors.white54,
                                color: color ?? Colors.black
                            ),
                        )
                    );
                }).toList();
            },
            items: categoriesList.map((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                        value,
                        style: const TextStyle(backgroundColor: Colors.white54, color: Colors.black),
                    ).alignment(Alignment.centerLeft).padding(right: 5),
                );
            }).toList(),
            // value: settings.defaultCategory,
            value: defaultValue,
            onChanged: onChange,
            // add extra sugar..
            icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black38,),
            // iconSize: 42,
            underline: const SizedBox(),
        ).paddingDirectional(end: 10);
    }

}


Widget buildDropDownList(List<String> categoriesList, {onChange, dropdownState, required Settings settings}) {
    return DropdownButton<String>(
        key: dropdownState,
        // decoration: InputDecoration(
        //   contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        //   filled: true,
        //   fillColor: Colors.grey[200],
        // ),
        alignment: AlignmentDirectional.centerEnd,
        style: const TextStyle(backgroundColor: Colors.white),
        isExpanded: true,
        selectedItemBuilder: (BuildContext context) {
            // return [...categoriesList.values.map((e) => e.name), ''].map<Widget>((String item) {
            return [...categoriesList, ''].map<Widget>((String item) {
                return Container(
                    alignment: Alignment.centerRight,
                    // width: 180,
                    child: Text(
                        item,
                        textAlign: TextAlign.end,
                        style: const TextStyle(backgroundColor: Colors.white54, color: Colors.black),
                    )
                );
            }).toList();
        },
        items: [...categoriesList, ''].map((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                    value,
                    style: const TextStyle(backgroundColor: Colors.white54, color: Colors.black),
                ).alignment(Alignment.centerLeft).padding(right: 5),
            );
        }).toList(),
        value: settings.defaultCategory,
        onChanged: (_) {
            if (_ != null) {
                // setState(() {
                //     settings.defaultCategory = _ ?? '';
                // });
            }
        },
        // add extra sugar..
        icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black38,),
        // iconSize: 42,
        underline: const SizedBox(),
    ).paddingDirectional(end: 10);
}


class DropDownField extends StatelessWidget {

    final String desc;
    final List<String> values;
    final void Function(String? v)? onChange;
    final GlobalKey<State<StatefulWidget>>? dropdownState;
    final String defaultValue;
    final Color? color;

    const DropDownField(
        this.desc, this.values, {
            super.key, this.onChange, this.dropdownState, required this.defaultValue, this.color
        }
    );

    @override
    Widget build(BuildContext context) {

        return [
            Text(desc),
            SizedBox(
                width: 120,
                // DropdownButtonFormField
                // DropdownButton
                child: DropDownList(values,
                    color: color,
                    dropdownState: dropdownState,
                    defaultValue: defaultValue,
                    onChange: onChange,
                )
            ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(top: 30);
    }

}