// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TextData {
  String text;
  Color color;
  String font;
  Color backgroundColor;
  List<double> startPoint;
  double scale;
  double angle;
  double radius;
  TextData({
    required this.text,
    required this.color,
    required this.font,
    required this.backgroundColor,
    required this.startPoint,
    required this.scale,
    required this.angle,
    required this.radius,
  });

  TextData copyWith({
    String? text,
    Color? color,
    String? font,
    Color? backgroundColor,
    List<double>? startPoint,
    double? scale,
    double? angle,
    double? radius,
  }) {
    return TextData(
      text: text ?? this.text,
      color: color ?? this.color,
      font: font ?? this.font,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      startPoint: startPoint ?? this.startPoint,
      scale: scale ?? this.scale,
      angle: angle ?? this.angle,
      radius: radius ?? this.radius,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'color': color.value,
      'font': font,
      'backgroundColor': backgroundColor.value,
      'startPoint': startPoint,
      'scale': scale,
      'angle': angle,
      'radius': radius,
    };
  }

  factory TextData.fromMap(Map<String, dynamic> map) {
    return TextData(
      text: map['text'] as String,
      color: Color(map['color'] as int),
      font: map['font'] as String,
      backgroundColor: Color(map['backgroundColor'] as int),
      startPoint: (map['startPoint'] as List<dynamic>).cast(),
      scale: map['scale'] as double,
      angle: map['angle'] as double,
      radius: map['radius'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TextData.fromJson(String source) =>
      TextData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TextData(text: $text, color: $color, font: $font, backgroundColor: $backgroundColor, startPoint: $startPoint, scale: $scale, angle: $angle, radius: $radius)';
  }

  @override
  bool operator ==(covariant TextData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.text == text &&
        other.color == color &&
        other.font == font &&
        other.backgroundColor == backgroundColor &&
        listEquals(other.startPoint, startPoint) &&
        other.scale == scale &&
        other.angle == angle &&
        other.radius == radius;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        color.hashCode ^
        font.hashCode ^
        backgroundColor.hashCode ^
        startPoint.hashCode ^
        scale.hashCode ^
        angle.hashCode ^
        radius.hashCode;
  }
}
