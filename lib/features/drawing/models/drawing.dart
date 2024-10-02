// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:drawingapp/features/drawing/models/drawing_data.dart';

class Drawing {
  String filePath;
  String name;
  String timeCreated;
  String timeModified;
  List<DrawingData> drawingDatas;
  Color? backgroundColor;
  String? backgroundImagePath;
  Drawing({
    required this.filePath,
    required this.name,
    required this.timeCreated,
    required this.timeModified,
    required this.drawingDatas,
    this.backgroundColor,
    this.backgroundImagePath,
  });

  Drawing copyWith({
    String? filePath,
    String? name,
    String? timeCreated,
    String? timeModified,
    List<DrawingData>? drawingDatas,
    Color? backgroundColor,
    String? backgroundImagePath,
  }) {
    return Drawing(
      filePath: filePath ?? this.filePath,
      name: name ?? this.name,
      timeCreated: timeCreated ?? this.timeCreated,
      timeModified: timeModified ?? this.timeModified,
      drawingDatas: drawingDatas ?? this.drawingDatas,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filePath': filePath,
      'name': name,
      'timeCreated': timeCreated,
      'timeModified': timeModified,
      'drawingDatas': drawingDatas.map((x) => x.toMap()).toList(),
      'backgroundColor': backgroundColor?.value,
      'backgroundImagePath': backgroundImagePath,
    };
  }

  factory Drawing.fromMap(Map<String, dynamic> map) {
    return Drawing(
      filePath: map['filePath'] as String,
      name: map['name'] as String,
      timeCreated: map['timeCreated'] as String,
      timeModified: map['timeModified'] as String,
      drawingDatas: List<DrawingData>.from(
        (map['drawingDatas'] as List<dynamic>).map<DrawingData>(
          (x) => DrawingData.fromMap(x as Map<String, dynamic>),
        ),
      ),
      backgroundColor: map['backgroundColor'] != null
          ? Color(map['backgroundColor'] as int)
          : null,
      backgroundImagePath: map['backgroundImagePath'] != null
          ? map['backgroundImagePath'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Drawing.fromJson(String source) =>
      Drawing.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Drawing(filePath: $filePath, name: $name, timeCreated: $timeCreated, timeModified: $timeModified, drawingDatas: $drawingDatas, backgroundColor: $backgroundColor, backgroundImagePath: $backgroundImagePath)';
  }

  @override
  bool operator ==(covariant Drawing other) {
    if (identical(this, other)) return true;

    return other.filePath == filePath &&
        other.name == name &&
        other.timeCreated == timeCreated &&
        other.timeModified == timeModified &&
        listEquals(other.drawingDatas, drawingDatas) &&
        other.backgroundColor == backgroundColor &&
        other.backgroundImagePath == backgroundImagePath;
  }

  @override
  int get hashCode {
    return filePath.hashCode ^
        name.hashCode ^
        timeCreated.hashCode ^
        timeModified.hashCode ^
        drawingDatas.hashCode ^
        backgroundColor.hashCode ^
        backgroundImagePath.hashCode;
  }
}
