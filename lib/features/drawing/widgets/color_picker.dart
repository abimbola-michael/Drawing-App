import 'package:drawingapp/features/drawing/widgets/picker_item.dart';
import 'package:flutter/material.dart';

List<Color> allColors = [
  Colors.white,
  Colors.black,
  ...Colors.primaries,
  ...Colors.accents
];

class ColorPicker extends StatelessWidget {
  final String colorType;
  final Color? selectedColor;
  final ValueChanged<Color> onSelect;
  const ColorPicker(
      {super.key,
      required this.onSelect,
      this.colorType = "",
      this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return PickerItem(
        title: colorType.isEmpty ? "Color" : "$colorType color",
        itemCount: allColors.length,
        itemBuilder: (context, index) {
          final color = allColors[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => onSelect(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: selectedColor != color
                          ? null
                          : Border.all(color: Colors.white, width: 2)),
                ),
              ),
              const SizedBox(height: 2),
              CircleAvatar(
                backgroundColor:
                    selectedColor == color ? Colors.white : Colors.transparent,
                radius: 2,
              ),
            ],
          );
        });
  }
}
