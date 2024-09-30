import 'package:drawingapp/features/drawing/models/drawing_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawingNotifier extends StateNotifier<List<DrawingData>> {
  DrawingNotifier(super.state);
}

final drawingProvider =
    StateNotifierProvider<DrawingNotifier, List<DrawingData>>(
        (ref) => DrawingNotifier([]));
