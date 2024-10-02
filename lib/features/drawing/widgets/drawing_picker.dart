import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrawingPicker extends StatefulWidget {
  final List<Widget> children;
  final List<String> labels;
  const DrawingPicker(
      {super.key, required this.children, required this.labels});

  @override
  State<DrawingPicker> createState() => _DrawingPickerState();
}

class _DrawingPickerState extends State<DrawingPicker> {
  int tabIndex = 0;
  void updateTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      height: 115,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: IndexedStack(
              index: tabIndex,
              children: widget.children,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.labels.length, (index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => updateTabIndex(index),
                  child: Container(
                    // alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tabIndex == index
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: Text(
                      widget.labels[index],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
