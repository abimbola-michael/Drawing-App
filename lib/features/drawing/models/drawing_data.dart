// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:drawingapp/features/drawing/models/path_data.dart';
import 'package:drawingapp/features/drawing/models/text_data.dart';

class DrawingData {
  TextData? textData;
  PathData? pathData;
  DrawingData({
    this.textData,
    this.pathData,
  });

  DrawingData copyWith({
    TextData? textData,
    PathData? pathData,
  }) {
    return DrawingData(
      textData: textData ?? this.textData,
      pathData: pathData ?? this.pathData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'textData': textData?.toMap(),
      'pathData': pathData?.toMap(),
    };
  }

  factory DrawingData.fromMap(Map<String, dynamic> map) {
    return DrawingData(
      textData: map['textData'] != null
          ? TextData.fromMap(map['textData'] as Map<String, dynamic>)
          : null,
      pathData: map['pathData'] != null
          ? PathData.fromMap(map['pathData'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DrawingData.fromJson(String source) =>
      DrawingData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DrawingData(textData: $textData, pathData: $pathData)';

  @override
  bool operator ==(covariant DrawingData other) {
    if (identical(this, other)) return true;

    return other.textData == textData && other.pathData == pathData;
  }

  @override
  int get hashCode => textData.hashCode ^ pathData.hashCode;
}
