import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class DrawingAppBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onDone;
  final VoidCallback? onDelete;
  final VoidCallback? onUndo;
  final String title;
  final bool hasDrawingData;
  final bool isEdit;

  const DrawingAppBar(
      {super.key,
      required this.onClose,
      required this.onDone,
      this.onUndo,
      this.onDelete,
      required this.isEdit,
      required this.title,
      required this.hasDrawingData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.black.withOpacity(0.1),
        child: Row(
          children: [
            IconButton(
              onPressed: onClose,
              icon: const Icon(EvaIcons.close),
              color: Colors.white,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (hasDrawingData && onUndo != null)
              IconButton(
                onPressed: onUndo,
                icon: const Icon(EvaIcons.undo_outline),
                color: Colors.white,
              ),
            if (isEdit && onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(EvaIcons.trash_outline),
                color: Colors.white,
              ),
            if (hasDrawingData)
              IconButton(
                onPressed: onDone,
                icon: const Icon(EvaIcons.checkmark),
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
