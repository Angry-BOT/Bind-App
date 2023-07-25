import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'my_picker.dart';

class DropDownField<T> extends HookWidget {
  final List<T> values;
  final Function(T) onSelect;
  final T value;
  final String suffixText;

  DropDownField({
    required this.values,
    required this.onSelect,
    required this.value,
    this.suffixText = '',
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
        text: value != null ? '$value $suffixText' : null);
    return TextField(
      controller: controller,
      decoration: InputDecoration(suffixIcon: Icon(Icons.keyboard_arrow_down)),
      readOnly: true,
      onTap: () async {
        final selected = await showCupertinoDialog(
          context: context,
          builder: (context) => MyPcker(
            values: values,
            value: value,
            suffixText: suffixText,
          ),
        );
        if (selected != null) {
          controller.text = "$selected $suffixText";
          onSelect(selected);
        }
      },
    );
  }
}
