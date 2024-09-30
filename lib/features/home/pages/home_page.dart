import 'package:drawingapp/features/drawing/pages/drawing_page.dart';
import 'package:drawingapp/features/drawing/sheets/comfirmation_sheet.dart';
import 'package:drawingapp/features/home/dialogs/name_drawing_dialog.dart';
import 'package:drawingapp/features/home/providers/drawing_list_provider.dart';
import 'package:drawingapp/features/home/sheets/name_drawing_sheet.dart';
import 'package:drawingapp/features/home/widgets/drawing_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../drawing/utils/image_save_utils.dart';
import '../models/drawing.dart';

class HomePage extends ConsumerWidget {
  static const route = "/home";

  const HomePage({super.key});

  List<String> get actions => ["Rename", "Edit", "Delete"];

  void updateAction(String action, BuildContext context, WidgetRef ref,
      Drawing drawing) async {
    switch (action) {
      case "Rename":
        final newName = await context.showNameDrawingDialog(drawing: drawing);
        if (newName == null) {
          return;
        }
        if (!context.mounted) return;

        await ImageSaveUtils.renameDrawingFile(
            context, getApplicationDocumentsDirectory(), drawing, newName);
        ref
            .read(drawingListProvider.notifier)
            .updateDrawingName(drawing, newName);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name Saved Successfully')));

        break;
      case "Edit":
        gotoDrawingPage(context, drawing: drawing);
        break;
      case "Delete":
        final result = await context.showComfirmationSheet(
            title: "Delete Drawing",
            message: "Are you sure you want to delete drawing?");

        if (result == null) {
          return;
        }

        if (!context.mounted) return;

        await ImageSaveUtils.deleteDrawingFile(
            context, getApplicationDocumentsDirectory(), drawing);
        ref.read(drawingListProvider.notifier).deleteDrawing(drawing);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Drawing Deleted Successfully')));
        break;
    }
  }

  void gotoDrawingPage(BuildContext context, {Drawing? drawing}) {
    Navigator.of(context)
        .pushNamed(DrawingPage.route, arguments: {"drawing": drawing});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawings = ref.watch(drawingListProvider);
    drawings.sort((a, b) => b.timeModified.compareTo(a.timeModified));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Drawing App",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: drawings.isEmpty
          ? const Center(
              child: Text(
                "No drawings",
                style: TextStyle(fontSize: 14),
              ),
            )
          : ListView.separated(
              itemCount: drawings.length,
              itemBuilder: (context, index) {
                final drawing = drawings[index];
                return DrawingItem(
                  key: Key(drawing.name),
                  drawing: drawing,
                  actions: actions,
                  onActionSelected: (action) =>
                      updateAction(action, context, ref, drawing),
                  onPressed: () => gotoDrawingPage(context, drawing: drawing),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.black.withOpacity(0.1),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => gotoDrawingPage(context),
        label: const Text("New"),
        icon: const Icon(EvaIcons.plus),
      ),
    );
  }
}
