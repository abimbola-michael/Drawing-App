import 'dart:math';

import 'package:drawingapp/features/drawing/models/drawing_data.dart';
import 'package:drawingapp/features/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../models/text_data.dart';
import '../widgets/drawing_painter.dart';

class GestureView extends StatefulWidget {
  final List<DrawingData> drawingDatas;
  final void Function(int index) onStartGesture;
  final void Function(int index, DrawingData newDrawingData) onEndGesture;
  final void Function(int index) onTap;

  const GestureView(
      {super.key,
      required this.drawingDatas,
      required this.onStartGesture,
      required this.onEndGesture,
      required this.onTap});

  @override
  State<GestureView> createState() => _GestureViewState();
}

class _GestureViewState extends State<GestureView> {
  DrawingData? selectedDrawingData;
  int currentIndex = -1;
  double scale = 1.0; // Scale factor
  double angle = 0.0; // angle angle

  void selectText(Offset touchPosition) {
    // Check which text was touched
    for (int i = 0; i < widget.drawingDatas.length; i++) {
      final drawingData = widget.drawingDatas[i];
      final textData = drawingData.textData;

      if (textData == null) continue;

      if (isTouchWithinTextBounds(touchPosition, textData)) {
        selectedDrawingData = drawingData;
        currentIndex = i;
        widget.onStartGesture(currentIndex);
        scale = drawingData.textData!.scale;
        angle = drawingData.textData!.angle;

        setState(() {});

        return;
      }
    }

    // Deselect if no text is touched
    if (selectedDrawingData != null) {
      selectedDrawingData = null;
      currentIndex = -1;
      setState(() {});
    }
  }

  bool isTouchWithinTextBounds(Offset touchPoint, TextData textData,
      {double padding = 20.0}) {
    // Step 1: Get the position, size, and scale of the text

    final style = TextStyle(
      fontSize: 30 * textData.scale,
      fontFamily: textData.font,
      color: textData.color,
    );

    // Create a TextPainter to get the text size
    final textPainter = TextPainter(
      text: TextSpan(
        text: textData.text,
        style: style,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Layout the text to calculate its size
    textPainter.layout();

    // Step 2: Calculate the original bounding rectangle for the text (before transformation)
    final rect = Rect.fromLTWH(
      -textPainter.width / 2, // Center around (0, 0)
      -textPainter.height / 2,
      textPainter.width + padding, // Add custom padding for width
      textPainter.height + padding, // Add custom padding for height
    ).inflate(
        padding); // Inflate the bounds by the desired padding for better touch accuracy

    // Step 3: Apply the inverse transformations to the touch point

//Text Position
    final position = textData.startPoint.isEmpty
        ? Offset(
            (context.width / 2) - textPainter.width / 2, // Center horizontally
            (context.height / 2) - textPainter.height / 2, // Center vertically
          )
        : Offset(textData.startPoint[0], textData.startPoint[1]);

    // First translate the touch point relative to the text's center
    Offset transformedPoint = touchPoint - position;

    // Apply inverse of the rotation
    transformedPoint = rotatePoint(transformedPoint, -textData.angle);

    // Apply inverse of the scale
    transformedPoint =
        transformedPoint.scale(1 / textData.scale, 1 / textData.scale);

    // Step 4: Check if the transformed touch point is inside the inflated bounding rectangle
    return rect.contains(transformedPoint);
  }

// Helper function to rotate a point around the origin (0, 0)
  Offset rotatePoint(Offset point, double angle) {
    final sinAngle = sin(angle);
    final cosAngle = cos(angle);

    return Offset(
      point.dx * cosAngle - point.dy * sinAngle,
      point.dx * sinAngle + point.dy * cosAngle,
    );
  }

  void startScale(ScaleStartDetails details) {}

  void updateScale(ScaleUpdateDetails details) {
    Offset localPosition = details.focalPoint;

    if (selectedDrawingData == null) {
      selectText(localPosition);
    }
    if (selectedDrawingData == null) {
      return;
    }

    final prevStartPoint = selectedDrawingData!.textData!.startPoint;
    selectedDrawingData!.textData!.startPoint = [
      prevStartPoint[0] + details.focalPointDelta.dx,
      prevStartPoint[1] + details.focalPointDelta.dy
    ];

    // final startPoint = [localPosition.dx, localPosition.dy];
    // selectedDrawingData!.textData!.startPoint = startPoint;
    selectedDrawingData!.textData!.scale = scale * details.scale;
    selectedDrawingData!.textData!.angle = angle + details.rotation;

    setState(() {});
  }

  void endScale(ScaleEndDetails details) {
    if (selectedDrawingData == null) return;
    widget.onEndGesture(currentIndex, selectedDrawingData!);
    selectedDrawingData = null;
    currentIndex = -1;
    setState(() {});
  }

  void updateTapUp(TapUpDetails details) {
    // check if it is  tap
    Offset localPosition = details.localPosition;

    selectText(localPosition);

    if (currentIndex != -1) {
      widget.onTap(currentIndex);
      selectedDrawingData = null;
      currentIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: updateTapUp,
      onScaleStart: startScale,
      onScaleUpdate: updateScale,
      onScaleEnd: endScale,
      behavior: HitTestBehavior.opaque,
      child: SizedBox.expand(
        child: selectedDrawingData == null
            ? null
            : CustomPaint(
                painter: DrawingPainter(drawingDatas: [selectedDrawingData!]),
                size: Size(context.width, context.height),
              ),
      ),
    );
  }
}
