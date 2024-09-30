import 'dart:io';

import 'package:drawingapp/features/home/models/drawing.dart';
import 'package:drawingapp/features/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';

class DrawingItem extends StatelessWidget {
  final Drawing drawing;
  final VoidCallback onPressed;
  final List<String> actions;
  final ValueChanged<String> onActionSelected;
  const DrawingItem(
      {super.key,
      required this.drawing,
      required this.onPressed,
      required this.actions,
      required this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.2),
              ),
              child: !File(drawing.filePath).existsSync()
                  ? const Icon(
                      EvaIcons.image,
                      color: Colors.grey,
                    )
                  : Image.file(
                      File(drawing.filePath),
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drawing.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${drawing.timeModified.toDateTime.date} ${drawing.timeModified.toDateTime.time}",
                    style: const TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            PopupMenuButton<String>(
              itemBuilder: (context) {
                return actions.map((action) {
                  return PopupMenuItem<String>(
                    value: action,
                    child: Text(
                      action,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList();
              },
              onSelected: onActionSelected,
              child: const Icon(EvaIcons.more_vertical),
            )
          ],
        ),
      ),
    );
  }
}
