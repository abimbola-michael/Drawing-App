// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PathData {
  Color color;
  int thickness;
  List<double> startPoint;
  List<List<double>> pathPoints;
  PathData({
    required this.color,
    required this.thickness,
    required this.startPoint,
    required this.pathPoints,
  });

  PathData copyWith({
    Color? color,
    int? thickness,
    List<double>? startPoint,
    List<List<double>>? pathPoints,
  }) {
    return PathData(
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      startPoint: startPoint ?? this.startPoint,
      pathPoints: pathPoints ?? this.pathPoints,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color.value,
      'thickness': thickness,
      'startPoint': startPoint,
      'pathPoints': pathPoints,
    };
  }

  factory PathData.fromMap(Map<String, dynamic> map) {
    return PathData(
      color: Color(map['color'] as int),
      thickness: map['thickness'] as int,
      startPoint: (map['startPoint'] as List<dynamic>).cast(),
      pathPoints: (map['pathPoints'] as List<dynamic>)
          .map((e) => (e as List).cast<double>())
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PathData.fromJson(String source) =>
      PathData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PathData(color: $color, thickness: $thickness, startPoint: $startPoint, pathPoints: $pathPoints)';
  }

  @override
  bool operator ==(covariant PathData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.color == color &&
        other.thickness == thickness &&
        listEquals(other.startPoint, startPoint) &&
        listEquals(other.pathPoints, pathPoints);
  }

  @override
  int get hashCode {
    return color.hashCode ^
        thickness.hashCode ^
        startPoint.hashCode ^
        pathPoints.hashCode;
  }
}
