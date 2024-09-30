// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:drawingapp/features/shared/colors.dart';
import 'package:flutter/material.dart';

import 'picker_item.dart';

class SizePicker extends StatelessWidget {
  final String title;
  final int maxSize;
  final int? selectedSize;
  final ValueChanged<int> onSelect;
  const SizePicker({
    Key? key,
    required this.maxSize,
    this.selectedSize,
    required this.onSelect,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickerItem(
        title: title,
        itemCount: maxSize,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => onSelect(index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                      border: selectedSize != index
                          ? null
                          : Border.all(color: Colors.white, width: 2)),
                  alignment: Alignment.center,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              CircleAvatar(
                backgroundColor:
                    selectedSize == index ? Colors.white : Colors.transparent,
                radius: 2,
              ),
            ],
          );
        });
  }
}
