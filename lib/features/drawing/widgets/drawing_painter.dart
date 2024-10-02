// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/drawing_data.dart';
import 'dart:ui' as ui;

class DrawingPainter extends CustomPainter {
  final Color? backgroundColor;
  //final String? imagePath;
  final ui.Image? backgroundImage;

  final List<DrawingData>? drawingDatas;

  DrawingPainter({
    this.backgroundColor,
    this.backgroundImage,
    this.drawingDatas,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // Draw image if the background image is loaded
    if (backgroundImage != null) {
      paintImage(
        canvas: canvas,
        image: backgroundImage!,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        fit: BoxFit
            .cover, // You can change the fit to control how the image is drawn
      );
    }
    // Draw background
    else if (backgroundColor != null) {
      Paint backgroundPaint = Paint()..color = backgroundColor!;
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    }

    if (drawingDatas != null) {
      for (int i = 0; i < drawingDatas!.length; i++) {
        final drawingData = drawingDatas![i];
        final textData = drawingData.textData;
        final pathData = drawingData.pathData;
        if (textData != null) {
          // Paint object for the background
          final paint = Paint()
            ..color = textData.backgroundColor
            ..style = PaintingStyle.fill;

          // Create TextStyle
          final style = TextStyle(
            fontSize: 30 * textData.scale,
            fontFamily: textData.font,
            color: textData.color,
          );

          // Create a TextPainter to calculate the text size
          final textPainter = TextPainter(
            text: TextSpan(
              text: textData.text,
              style: style,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );

          // Layout the text to get its dimensions
          textPainter.layout();

          // Save the canvas state before transformation
          canvas.save();

          // Text position
          final position = textData.startPoint.isEmpty
              ? Offset(
                  (size.width / 2) -
                      textPainter.width / 2, // Center horizontally
                  (size.height / 2) -
                      textPainter.height / 2, // Center vertically
                )
              : Offset(textData.startPoint[0], textData.startPoint[1]);

          if (textData.startPoint.isEmpty) {
            textData.startPoint = [position.dx, position.dy];
          }

          // First, translate the canvas to the top-left of the text position (without any offsets)
          canvas.translate(position.dx, position.dy);

          // Apply rotation around the center of the text and the background
          canvas.translate(textPainter.width / 2, textPainter.height / 2);
          canvas.rotate(textData.angle);
          canvas.translate(-textPainter.width / 2, -textPainter.height / 2);

          // Create the Rect for the background (centered around the text after translation)
          final rect = Rect.fromLTWH(
            0,
            0, // Start from 0, 0 since the canvas is already translated to position
            textPainter.width + 20, // Add padding for width
            textPainter.height + 20, // Add padding for height
          );

          // Draw the rounded rectangle background
          final RRect rRect = RRect.fromRectAndRadius(
            rect,
            Radius.circular(textData.radius),
          );
          canvas.drawRRect(rRect, paint);

          // Now draw the text centered on the background
          textPainter.paint(canvas, const Offset(10, 10)); // Offset by padding

          // Restore the canvas state after rotation and translation
          canvas.restore();
        } else if (pathData != null) {
          Paint paint = Paint()
            ..color = pathData.color
            ..strokeWidth = pathData.thickness.toDouble()
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;
          final startPoint = pathData.startPoint;
          final pathPoints = pathData.pathPoints;
          if (pathData.currentPath != null) {
            canvas.drawPath(pathData.currentPath!, paint);
            continue;
          }
          Path path = Path();
          path.moveTo(startPoint[0], startPoint[1]);
          List<double> previousPoint = startPoint;

          for (int i = 0; i < pathPoints.length; i++) {
            final nextPoint = pathPoints[i];
            // Create smooth curves using quadraticBezierTo
            List<double> midPoint = [
              (previousPoint[0] + nextPoint[0]) / 2,
              (previousPoint[1] + nextPoint[1]) / 2,
            ];
            path.quadraticBezierTo(
              previousPoint[0],
              previousPoint[1],
              midPoint[0],
              midPoint[1],
            );
            previousPoint = nextPoint;
          }

          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
