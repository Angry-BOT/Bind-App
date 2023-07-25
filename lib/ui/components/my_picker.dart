import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPcker<T> extends StatefulWidget {
  const MyPcker({
    Key? key,
    required this.values,
    required this.value,
    this.suffixText = '',
  }) : super(key: key);
  final List<T> values;
  final T value;
  final String suffixText;
  @override
  _MyPckerState createState() => _MyPckerState();
}

class _MyPckerState extends State<MyPcker> {
  late FixedExtentScrollController _controller;
  @override
  void initState() {
    _controller = FixedExtentScrollController(
        initialItem:
            widget.value != null ? widget.values.indexOf(widget.value!) : 0);
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
          Navigator.pop(
              context, widget.values[selectedIndex ?? _controller.initialItem]);
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
                      (e) => Center(
                        child: Text("$e ${widget.suffixText}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(right: 0, child: Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}
