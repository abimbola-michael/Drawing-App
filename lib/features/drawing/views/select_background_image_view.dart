import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/drawing_app_bar.dart';

class SelectedBackgroundImageView extends StatefulWidget {
  final String? currentImagePath;
  final VoidCallback onClose;
  final void Function(String? imagePath) onImageChanged;
  const SelectedBackgroundImageView(
      {super.key,
      this.currentImagePath,
      required this.onClose,
      required this.onImageChanged});

  @override
  State<SelectedBackgroundImageView> createState() =>
      _SelectedBackgroundImageViewState();
}

class _SelectedBackgroundImageViewState
    extends State<SelectedBackgroundImageView> {
  String? currentBackgroundImagePath;
  String? prevBackgroundImagePath;

  @override
  void initState() {
    super.initState();
    currentBackgroundImagePath = widget.currentImagePath;
    prevBackgroundImagePath = widget.currentImagePath;
  }

  void updateBackgroundImage(String imagePath) {
    widget.onImageChanged(imagePath);
    setState(() {
      currentBackgroundImagePath = imagePath;
    });
  }

  void closeImageSelection() {
    widget.onImageChanged(prevBackgroundImagePath);
    widget.onClose();
  }

  void saveImageChange() {
    widget.onClose();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      File image = File(imageFile.path);
      currentBackgroundImagePath = image.path;
      updateBackgroundImage(currentBackgroundImagePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          DrawingAppBar(
            title: "Image",
            isEdit: widget.currentImagePath != null,
            onClose: closeImageSelection,
            onDone: saveImageChange,
            hasDrawingData: true,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: pickImage,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                  child: const Text(
                    "Upload Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
