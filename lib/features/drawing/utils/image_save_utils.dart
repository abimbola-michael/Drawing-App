import 'dart:io';
import 'dart:typed_data';

import 'package:drawingapp/features/drawing/widgets/drawing_painter.dart';
import 'package:drawingapp/features/drawing/models/drawing.dart';
import 'package:drawingapp/features/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class ImageSaveUtils {
  static String getNewFilePath(String filePath, String newName) {
    return "${filePath.substring(0, filePath.lastIndexOf("/"))}/$newName.png";
  }

  // Function to convert File to ui.Image
  static Future<ui.Image> loadImageFromFile(File file) async {
    final Uint8List data =
        await file.readAsBytes(); // Read the image file as bytes
    final ui.Codec codec = await ui.instantiateImageCodec(data);
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  // Rename a file
  static Future<void> deleteDrawingFile(BuildContext context,
      Future<Directory> documentPath, Drawing drawing) async {
    final directory = await documentPath;
    final appDirectory = Directory("${directory.path}/drawingapp");
    if (!appDirectory.existsSync()) {
      await appDirectory.create(recursive: true);
    }
    final path = '${directory.path}/drawingapp/${drawing.name}.png';
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  // Rename a file
  static Future<void> renameDrawingFile(BuildContext context,
      Future<Directory> documentPath, Drawing drawing, String newName) async {
    final directory = await documentPath;
    final appDirectory = Directory("${directory.path}/drawingapp");
    if (!appDirectory.existsSync()) {
      await appDirectory.create(recursive: true);
    }
    final path = '${directory.path}/drawingapp/${drawing.name}.png';
    final newPath = '${directory.path}/drawingapp/$newName.png';
    final file = File(path);
    //final newFile = File(newPath);
    if (file.existsSync()) {
      await file.rename(newPath);
    }
  }

  // Save the current drawing to a file
  static Future<void> saveDrawing(BuildContext context,
      Future<Directory> documentPath, Drawing drawing) async {
    try {
      // Get the application directory
      final directory = await documentPath;
      final appDirectory = Directory("${directory.path}/drawingapp");
      if (!appDirectory.existsSync()) {
        await appDirectory.create(recursive: true);
      }
      final path = '${directory.path}/drawingapp/${drawing.name}.png';

      // Create a new image from the canvas size
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      ui.Image? backgroundImage;
      if (drawing.backgroundImagePath != null &&
          File(drawing.backgroundImagePath!).existsSync()) {
        backgroundImage = await ImageSaveUtils.loadImageFromFile(
            File(drawing.backgroundImagePath!));
      }
      final painter = DrawingPainter(
          drawingDatas: drawing.drawingDatas,
          backgroundImage: backgroundImage,
          backgroundColor: drawing.backgroundColor);

      // Define the canvas size (change if needed)
      //final size = ui.Size(500, 500);
      if (!context.mounted) return;
      final size = ui.Size(context.width, context.height);

      painter.paint(canvas, size);
      final picture = recorder.endRecording();
      final imgBytes =
          await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData =
          await imgBytes.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      // Save the image as a file
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
      await file.writeAsBytes(buffer);
      if (drawing.filePath.isEmpty) {
        drawing.filePath = path;
      }

      print('Drawing saved to $path');
    } catch (e) {
      print('Failed to save drawing: $e');
    }
  }

  // Load a saved drawing from the file
  static Future<File?> loadDrawing(BuildContext context,
      Future<Directory> documentPath, Drawing drawing) async {
    try {
      final directory = await documentPath;
      final appDirectory = Directory("${directory.path}/drawingapp");
      if (!appDirectory.existsSync()) {
        await appDirectory.create(recursive: true);
      }
      final path = '${directory.path}/drawingapp/${drawing.name}.png';
      final file = File(path);

      if (await file.exists()) {
        // Read the saved image file and load it onto the canvas
        //final image = img.decodeImage(await file.readAsBytes())!;
        //print('Drawing loaded from $path');
        return file;
      } else {
        print('No saved drawing found.');
      }
    } catch (e) {
      print('Failed to load drawing: $e');
    }
  }
}
