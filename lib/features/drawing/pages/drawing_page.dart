import 'dart:io';

import 'package:drawingapp/features/drawing/enums/enums.dart';
import 'package:drawingapp/features/drawing/models/drawing_data.dart';
import 'package:drawingapp/features/drawing/sheets/comfirmation_sheet.dart';
import 'package:drawingapp/features/drawing/utils/image_save_utils.dart';
import 'package:drawingapp/features/drawing/views/drawing_view.dart';
import 'package:drawingapp/features/drawing/views/select_background_color_view.dart';
import 'package:drawingapp/features/drawing/views/select_background_image_view.dart';
import 'package:drawingapp/features/drawing/views/write_text_view.dart';
import 'package:drawingapp/features/home/dialogs/name_drawing_dialog.dart';
import 'package:drawingapp/features/home/models/drawing.dart';
import 'package:drawingapp/features/home/providers/drawing_list_provider.dart';
import 'package:drawingapp/features/shared/colors.dart';
import 'package:drawingapp/features/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import '../views/gesture_view.dart';
import '../widgets/drawing_painter.dart';

class DrawingPage extends ConsumerStatefulWidget {
  static const route = "/drawing";
  const DrawingPage({super.key});

  @override
  ConsumerState<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends ConsumerState<DrawingPage> {
  bool isUpdate = false;
  Drawing? drawing;
  List<DrawingData> drawingDatas = [];
  DrawingData? selectedDrawingData;
  //path
  Color currentColor = Colors.white;
  Color backgroundColor = primaryColor;
  String? backgroundImagePath;
  ui.Image? backgroundImage;
  int currentThickness = 2;
  DrawingMode? drawingMode;
  int currentTappedTextIndex = -1;
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final drawing = args["drawing"];
      if (this.drawing == null && drawing != null) {
        // trying to get prev drawing
        isUpdate = true;
        updateDrawingParameters(drawing!);
        this.drawing = drawing;
      }
    }
  }

  void updateDrawingParameters(Drawing drawing) {
    // adding initial drawing details
    backgroundColor = drawing.backgroundColor ?? primaryColor;
    backgroundImagePath = drawing.backgroundImagePath;
    if (backgroundImagePath != null) {
      File image = File(backgroundImagePath!);
      generateCanvasImage(image);
    }
    drawingDatas.addAll(drawing.drawingDatas);
    setState(() {});
  }

  void selectBackgroundColor() {
    drawingMode = DrawingMode.color;
    setState(() {});
  }

  void updateBackgroundColor(Color color) {
    backgroundColor = color;
    setState(() {});
  }

  void selectBackgroundImage() async {
    drawingMode = DrawingMode.image;
    currentTappedTextIndex = -1;
    setState(() {});
  }

  void updateBackgroundImage(String? imagePath) {
    backgroundImagePath = imagePath;
    if (imagePath != null) {
      generateCanvasImage(File(imagePath));
    }
  }

  void generateCanvasImage(File image) async {
    // turing the file to an imagage that can be drawn on canvas
    final img = await ImageSaveUtils.loadImageFromFile(image);
    setState(() {
      backgroundImage = img;
    });
  }

  void drawPath() {
    // this is uses to change to path drawing mode
    drawingMode = DrawingMode.path;
    currentTappedTextIndex = -1;
    setState(() {});
  }

  void writeText() {
    // this is uses to change to text writing mode

    drawingMode = DrawingMode.text;
    currentTappedTextIndex = -1;
    setState(() {});
  }

  void updateGestureStarted(int index) {
    // checking when gesture movement starts
    selectedDrawingData = drawingDatas[index];
    drawingDatas[index] = DrawingData();
    setState(() {});
  }

  void updateGestureEnded(int index, DrawingData drawingData) {
    // checking when gesture movement ends

    drawingDatas[index] = drawingData;
    selectedDrawingData = null;
    setState(() {});
  }

  void closeView([bool isDelete = false]) {
    // closing any drawing or text view

    drawingMode = null;

    if (currentTappedTextIndex != -1 && selectedDrawingData != null) {
      if (isDelete) {
        drawingDatas.removeAt(currentTappedTextIndex);
      } else {
        drawingDatas[currentTappedTextIndex] = selectedDrawingData!;
      }
    }
    currentTappedTextIndex = -1;
    selectedDrawingData = null;

    setState(() {});
  }

  void addNewDrawingDatas(List<DrawingData> newDrawingDatas) {
    // adding the drawing datas from the drawing or text view
    drawingDatas.addAll(newDrawingDatas);
    setState(() {});
  }

  void editText(int index) {
    // go to editing of text mode
    drawingMode = DrawingMode.text;
    currentTappedTextIndex = index;
    setState(() {});
  }

  void updateText(DrawingData drawingData) {
    // updating the text from the new text data

    if (currentTappedTextIndex != -1) {
      drawingDatas[currentTappedTextIndex] = drawingData;
    } else {
      drawingDatas.add(drawingData);
    }
    setState(() {});
  }

  void deleteText() {
    closeView();
  }

  void saveDrawing() async {
    //checking for modification
    if (!isModified) {
      Navigator.of(context).pop();
      return;
    }
    final dateNow = DateTime.now();
    final time = dateNow.millisecondsSinceEpoch.toString();

    // creating a new drawing for saving
    Drawing newDrawing;
    if (drawing == null) {
      //final name = DateFormat("ddMMyyyyhhmm").format(dateNow);
      // if no drawing before
      newDrawing = Drawing(
        filePath: "",
        name: "",
        timeCreated: time,
        timeModified: time,
        drawingDatas: drawingDatas,
        backgroundColor: backgroundColor,
        backgroundImagePath: backgroundImagePath,
      );
    } else {
      //modifying previous drawing
      newDrawing = drawing!.copyWith(
          timeModified: time,
          backgroundColor: backgroundColor,
          backgroundImagePath: backgroundImagePath,
          drawingDatas: drawingDatas);
    }
    if (newDrawing.name.isEmpty) {
      final name = await context.showNameDrawingDialog(drawing: newDrawing);
      if (name == null) {
        // if (!mounted) return;
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     backgroundColor: Colors.red,
        //     content: Text('Please enter a name for the drawing')));
        return;
      }
      newDrawing.name = name;
    }
    setState(() {
      loading = true;
    });
    if (!mounted) return;
    try {
      // saving drawing to file
      await ImageSaveUtils.saveDrawing(
          context, getApplicationDocumentsDirectory(), newDrawing);

      if (isUpdate) {
        ref.read(drawingListProvider.notifier).updateDrawing(newDrawing);
      } else {
        ref.read(drawingListProvider.notifier).addDrawing(newDrawing);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Drawing Saved Successfully')));
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to save drawing: $e')));
    }
  }

  void clearDrawing() {
    // clearing of all drawings
    drawingDatas.clear();
    setState(() {});
  }

  void undo() {
    // for undoing previously added drawing
    if (drawingDatas.isEmpty) return;
    drawingDatas.removeLast();
    setState(() {});
  }

// checking for any new modification
  bool get isModified =>
      (drawing == null && drawingDatas.isNotEmpty) ||
      (drawing != null &&
          (!drawingDatas.isSameList(drawing!.drawingDatas) ||
              backgroundImagePath != drawing!.backgroundImagePath ||
              backgroundColor != drawing!.backgroundColor));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: drawingMode == null,
      onPopInvoked: (pop) {
        if (pop) return;
        // making sure that app does just close when in path or text mode
        closeView();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: drawingMode != null
            ? null
            : AppBar(
                backgroundColor: Colors.black.withOpacity(0.1),
                foregroundColor: Colors.black.withOpacity(0.1),
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    if (!isModified) {
                      Navigator.of(context).pop();
                      return;
                    }
                    context
                        .showComfirmationSheet(
                            title: "Close Drawing",
                            message: "Are you sure you want to close drawing?")
                        .then((value) {
                      if (value != null) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  icon: const Icon(EvaIcons.arrow_back),
                  color: Colors.white,
                ),
                actions: [
                  if (drawingDatas.isNotEmpty)
                    IconButton(
                      onPressed: undo,
                      icon: const Icon(EvaIcons.undo_outline),
                      color: Colors.white,
                    ),
                  if (drawingDatas.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        context
                            .showComfirmationSheet(
                                title: "Clear Drawing",
                                message:
                                    "Are you sure you want to clear drawing?")
                            .then((value) {
                          if (value != null) {
                            clearDrawing();
                          }
                        });
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: saveDrawing,
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
        body: Stack(
          children: [
            CustomPaint(
              painter: DrawingPainter(
                drawingDatas: drawingDatas,
                backgroundColor: backgroundColor,
                backgroundImage: backgroundImage,
              ),
              size: Size(context.width, context.height),
            ),
            GestureView(
              drawingDatas: drawingDatas,
              onStartGesture: updateGestureStarted,
              onEndGesture: updateGestureEnded,
              onTap: editText,
            ),
            if (drawingMode == DrawingMode.path)
              DrawingView(
                currentColor: currentColor,
                currentThickness: currentThickness,
                onClose: closeView,
                onDone: addNewDrawingDatas,
              )
            else if (drawingMode == DrawingMode.text)
              WriteTextView(
                drawingData: selectedDrawingData,
                onDelete: deleteText,
                onClose: closeView,
                onDone: updateText,
              )
            else if (drawingMode == DrawingMode.color)
              SelectBackgroundColorView(
                currentBackgroundColor: backgroundColor,
                onClose: closeView,
                onColorChanged: updateBackgroundColor,
              )
            else if (drawingMode == DrawingMode.image)
              SelectedBackgroundImageView(
                currentImagePath: backgroundImagePath,
                onClose: closeView,
                onImageChanged: updateBackgroundImage,
              )
          ],
        ),
        bottomNavigationBar: drawingMode != null
            ? null
            : BottomAppBar(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                color: Colors.black.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: drawPath,
                      icon: const Icon(Icons.gesture),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: writeText,
                      icon: const Icon(OctIcons.pencil),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: selectBackgroundColor,
                      icon: const Icon(EvaIcons.color_palette),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: selectBackgroundImage,
                      icon: const Icon(EvaIcons.image),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
