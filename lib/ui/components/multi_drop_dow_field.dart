import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'my_multi_picker.dart';

class MuliDropDownField extends HookWidget {
  final List<String> values;
  final Function(List<String>) onSelect;
  final List<String> selectedValues;
  final TextEditingController controller;
  MuliDropDownField({
    required this.values,
    required this.onSelect,
    required this.selectedValues,
    required this.controller
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(suffixIcon: Icon(Icons.keyboard_arrow_down)),
      readOnly: true,
      onTap: () async {
        if(values.isEmpty){
          return;
        }
        List<String> selected = await showCupertinoDialog(
          context: context,
          builder: (context) => MyMultiPickerPcker(
            values: values,
            selectedValues: selectedValues,
          ),
        );
        selected.sort((a,b)=>a.compareTo(b));
        controller.text = selected.join(", ");
        onSelect(selected);
      },
    );
  }
}
