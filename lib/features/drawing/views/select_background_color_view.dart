import 'package:drawingapp/features/shared/colors.dart';
import 'package:flutter/material.dart';

import '../widgets/color_picker.dart';
import '../widgets/drawing_app_bar.dart';

class SelectBackgroundColorView extends StatefulWidget {
  final Color currentBackgroundColor;
  final VoidCallback onClose;
  final void Function(Color color) onColorChanged;
  const SelectBackgroundColorView(
      {super.key,
      required this.currentBackgroundColor,
      required this.onClose,
      required this.onColorChanged});

  @override
  State<SelectBackgroundColorView> createState() =>
      _SelectBackgroundColorViewState();
}

class _SelectBackgroundColorViewState extends State<SelectBackgroundColorView> {
  Color currentBackgroundColor = primaryColor;
  Color prevBackgroundColor = primaryColor;

  @override
  void initState() {
    super.initState();
    currentBackgroundColor = widget.currentBackgroundColor;
    prevBackgroundColor = widget.currentBackgroundColor;
  }

  void updateBackgroundColor(Color color) {
    widget.onColorChanged(color);
    setState(() {
      currentBackgroundColor = color;
    });
  }

  void closeColorSelection() {
    widget.onColorChanged(prevBackgroundColor);
    widget.onClose();
  }

  void saveColorChange() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          DrawingAppBar(
            title: "Color",
            isEdit: false,
            onClose: closeColorSelection,
            onDone: saveColorChange,
            hasDrawingData: true,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  colorType: "Background",
                  selectedColor: currentBackgroundColor,
                  onSelect: updateBackgroundColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
