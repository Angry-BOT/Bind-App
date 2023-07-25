import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMultiPickerPcker extends StatefulWidget {
  const MyMultiPickerPcker({
    Key? key,
    required this.values,
    required this.selectedValues,
  }) : super(key: key);
  final List<String> values;
  final List<String> selectedValues;

  @override
  _MyMultiPickerPckerState createState() => _MyMultiPickerPckerState();
}

class _MyMultiPickerPckerState extends State<MyMultiPickerPcker> {
  late FixedExtentScrollController _controller;
  @override
  void initState() {
    _controller = FixedExtentScrollController(
      initialItem: widget.selectedValues.isNotEmpty
          ? widget.values.indexOf(widget.selectedValues.first)
          : 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      content: GestureDetector(
        onTap: () {
          final item = widget.values[selectedIndex ?? _controller.initialItem];
          setState(() {
            if (!widget.selectedValues.contains(item)) {
              widget.selectedValues.add(item);
            } else {
              widget.selectedValues.remove(item);
            }
          });
        },
        child: Stack(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                scrollController: _controller,
                itemExtent: 40,
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: theme.dividerColor,
                      ),
                    ),
                  ),
                ),
                onSelectedItemChanged: (i) {
                  selectedIndex = i;
                },
                children: widget.values
                    .map(
                      (e) => Stack(
                        children: [
                          widget.selectedValues.contains(e)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(
                right: 0,
                child: CloseButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selectedValues);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
