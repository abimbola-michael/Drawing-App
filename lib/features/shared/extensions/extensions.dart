import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtension on BuildContext {
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  ThemeData get theme => Theme.of(this);
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

extension DateTimeExtension on DateTime {
  String get time => DateFormat("h:mma").format(this);
  String get date => DateFormat("d/MM/yyyy").format(this);
}

extension StringExtension on String {
  DateTime get toDateTime =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(this));
}

extension ListExtension<T> on List<T> {
  bool isSameList(List<T> otherList) {
    if (otherList.length != length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != otherList[i]) return false;
    }
    return true;
  }
}
