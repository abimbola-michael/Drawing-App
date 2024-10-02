// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:drawingapp/features/shared/colors.dart';
import 'package:flutter/material.dart';

import 'picker_item.dart';

class SizeRangePicker extends StatefulWidget {
  final String title;
  final int minSize;
  final int maxSize;
  final int? selectedSize;
  final ValueChanged<int> onChange;
  const SizeRangePicker({
    Key? key,
    required this.minSize,
    required this.maxSize,
    this.selectedSize,
    required this.onChange,
    required this.title,
  }) : super(key: key);

  @override
  State<SizeRangePicker> createState() => _SizeRangePickerState();
}

class _SizeRangePickerState extends State<SizeRangePicker> {
  double value = 0;
  @override
  void initState() {
    super.initState();
    value = widget.selectedSize?.toDouble() ?? widget.minSize.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      //color: Colors.black.withOpacity(0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   widget.title,
          //   style: const TextStyle(
          //     fontSize: 12,
          //     color: Colors.white,
          //   ),
          //   maxLines: 1,
          // ),
          // const SizedBox(height: 8),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.minSize}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        "${value.toInt()}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        "${widget.maxSize}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    min: widget.minSize.toDouble(),
                    max: widget.maxSize.toDouble(),
                    value: value,
                    onChanged: (value) {
                      widget.onChange(value.toInt());
                      setState(() {
                        this.value = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
