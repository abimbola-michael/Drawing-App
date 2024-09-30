import 'package:drawingapp/features/drawing/models/drawing_data.dart';
import 'package:drawingapp/features/drawing/widgets/color_picker.dart';
import 'package:drawingapp/features/drawing/widgets/drawing_app_bar.dart';
import 'package:drawingapp/features/drawing/widgets/drawing_painter.dart';
import 'package:drawingapp/features/drawing/widgets/size_picker.dart';
import 'package:drawingapp/features/drawing/widgets/size_range_picker.dart';
import 'package:drawingapp/features/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/path_data.dart';

class DrawingView extends StatefulWidget {
  final Color currentColor;
  final int currentThickness;
  final VoidCallback onClose;
  final void Function(List<DrawingData> drawingDatas) onDone;
  const DrawingView(
      {super.key,
      required this.currentColor,
      required this.currentThickness,
      required this.onClose,
      required this.onDone});

  @override
  State<DrawingView> createState() => _DrawingViewState();
}

class _DrawingViewState extends State<DrawingView> {
  List<DrawingData> drawingDatas = [];
  PathData? currentPathData;
  Color currentColor = Colors.white;
  Color currentBackgroundColor = Colors.blue;
  int currentThickness = 2;

  void updateThickness(int thickness) {
    setState(() {
      currentThickness = thickness;
    });
  }

  void updateColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  void undoLastPath() {
    if (drawingDatas.isEmpty) return;
    drawingDatas.removeLast();
    setState(() {});
  }

  void startPath(DragStartDetails details) {
    Offset localPosition = details.localPosition;
    final startPoint = [localPosition.dx, localPosition.dy];
    currentPathData = PathData(
      color: currentColor,
      thickness: currentThickness,
      startPoint: startPoint,
      pathPoints: [],
    );
    drawingDatas.add(DrawingData(pathData: currentPathData!));
    setState(() {});
  }

  void updatePath(DragUpdateDetails details) {
    Offset localPosition = details.localPosition;
    final nextPoint = [localPosition.dx, localPosition.dy];

    currentPathData!.pathPoints.add(nextPoint);
    setState(() {});
  }

  void endPath(DragEndDetails details) {
    currentPathData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onPanStart: startPath,
        onPanUpdate: updatePath,
        onPanEnd: endPath,
        child: Stack(
          children: [
            CustomPaint(
              painter: DrawingPainter(drawingDatas: drawingDatas),
              size: Size(context.width, context.height),
            ),
            DrawingAppBar(
              title: "Draw",
              isEdit: false,
              onClose: widget.onClose,
              onDone: () {
                widget.onDone(drawingDatas);
                widget.onClose();
              },
              onUndo: undoLastPath,
              hasDrawingData: drawingDatas.isNotEmpty,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizePicker(
                  //   maxSize: 50,
                  //   selectedSize: currentThickness,
                  //   onSelect: updateThickness,
                  //   title: "Thickness",
                  // ),
                  SizeRangePicker(
                    minSize: 1,
                    maxSize: 50,
                    onChange: updateThickness,
                    title: "Thickness",
                  ),
                  ColorPicker(
                    selectedColor: currentColor,
                    onSelect: updateColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
