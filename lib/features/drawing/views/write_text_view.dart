import 'package:drawingapp/features/drawing/models/drawing_data.dart';
import 'package:drawingapp/features/drawing/models/text_data.dart';
import 'package:drawingapp/features/drawing/widgets/drawing_picker.dart';
import 'package:drawingapp/features/drawing/widgets/font_picker.dart';
import 'package:drawingapp/features/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../widgets/color_picker.dart';
import '../widgets/drawing_app_bar.dart';
import '../widgets/size_picker.dart';

class WriteTextView extends StatefulWidget {
  final DrawingData? drawingData;
  final VoidCallback onClose;
  final VoidCallback onDelete;
  final void Function(DrawingData drawingData) onDone;
  const WriteTextView(
      {super.key,
      this.drawingData,
      required this.onDelete,
      required this.onClose,
      required this.onDone});

  @override
  State<WriteTextView> createState() => _WriteTextViewState();
}

class _WriteTextViewState extends State<WriteTextView> {
  final TextEditingController controller = TextEditingController();
  TextData? textData;
  String currentFont = allFonts.first ?? "";
  Color currentColor = Colors.white;
  Color currentBackgroundColor = Colors.transparent;
  bool changed = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    textData = widget.drawingData?.textData;
    controller.text = textData?.text ?? "";
    if (textData != null) {
      currentColor = textData!.color;
      currentBackgroundColor = textData!.backgroundColor;
      currentFont = textData!.font;
      // currentColor = textData!.color;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateFont(String font) {
    setState(() {
      currentFont = font;
    });
  }

  void updateColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  void updateBackgroundColor(Color color) {
    setState(() {
      currentBackgroundColor = color;
    });
  }

  void updateDrawingData() {
    DrawingData drawingData;
    if (widget.drawingData == null) {
      drawingData = DrawingData(
        textData: TextData(
          text: controller.text,
          color: currentColor,
          font: currentFont,
          backgroundColor: currentBackgroundColor,
          //startPoint: [(context.width / 2) - 15, (context.height / 2) - 15],
          startPoint: [],

          scale: 1,
          angle: 0,
          radius: 20,
        ),
      );
    } else {
      drawingData = widget.drawingData!;
      drawingData.textData!.text = controller.text;
      drawingData.textData!.color = currentColor;
      drawingData.textData!.backgroundColor = currentBackgroundColor;
      drawingData.textData!.font = currentFont;
    }
    widget.onDone(drawingData);
    widget.onClose();
  }

  void requestFocus() {
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: requestFocus,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.3),
        child: Stack(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: currentBackgroundColor,
                ),
                child: IntrinsicWidth(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: currentFont,
                        color: currentColor),
                    autofocus: true,
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      hintText: "",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontFamily: currentFont,
                        color: currentColor.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: currentColor == Colors.white
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
            DrawingAppBar(
              title: "Write",
              isEdit: widget.drawingData != null,
              onClose: widget.onClose,
              onDone: updateDrawingData,
              onDelete: widget.onDelete,
              hasDrawingData: true,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DrawingPicker(
                labels: const ["Text Color", "Background Color", "Font"],
                children: [
                  // SizePicker(
                  //   maxSize: 10,
                  //   selectedSize: currentThickness,
                  //   onSelect: updateThickness,
                  //   title: "Font Size",
                  // ),
                  ColorPicker(
                    colorType: "Text",
                    selectedColor: currentColor,
                    onSelect: updateColor,
                  ),
                  ColorPicker(
                    colorType: "Background",
                    selectedColor: currentBackgroundColor,
                    onSelect: updateBackgroundColor,
                  ),
                  FontPicker(selectedFont: currentFont, onSelect: updateFont)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
