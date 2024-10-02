import 'package:drawingapp/features/drawing/utils/image_save_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../drawing/models/drawing.dart';

class DrawingListNotifier extends StateNotifier<List<Drawing>> {
  DrawingListNotifier(super.state);
  final drawingsBox = Hive.box<String>("drawings");

  int getDrawingIndex(String name) {
    return state.indexWhere((element) => element.name == name);
  }

  Drawing? getDrawing(String name) {
    final index = getDrawingIndex(name);
    return index == -1 ? null : state[index];
  }

  void addDrawing(Drawing drawing) {
    state = [...state, drawing];
    drawingsBox.put(drawing.name, drawing.toJson());
  }

  void updateDrawingName(Drawing drawing, String newName) {
    final newFilePath =
        ImageSaveUtils.getNewFilePath(drawing.filePath, newName);
    state = state
        .map((e) => e.name == drawing.name
            ? e.copyWith(name: newName, filePath: newFilePath)
            : e)
        .toList();
    drawingsBox.delete(drawing.name);
    drawingsBox.put(newName,
        drawing.copyWith(name: newName, filePath: newFilePath).toJson());
  }

  void updateDrawing(Drawing drawing) {
    state = state.map((e) => e.name == drawing.name ? drawing : e).toList();
    drawingsBox.put(drawing.name, drawing.toJson());
  }

  void deleteDrawing(Drawing drawing) {
    state = state.where((element) => element.name != drawing.name).toList();
    drawingsBox.delete(drawing.name);
  }
}

final drawingListProvider =
    StateNotifierProvider<DrawingListNotifier, List<Drawing>>((ref) {
  final drawingsBox = Hive.box<String>("drawings");
  final drawings = drawingsBox.values.map((e) => Drawing.fromJson(e)).toList();
  return DrawingListNotifier(drawings);
});
