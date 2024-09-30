import 'package:flutter/material.dart';

class PickerItem extends StatelessWidget {
  final String title;
  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  const PickerItem(
      {super.key,
      required this.title,
      required this.itemCount,
      required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.black.withOpacity(0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            ),
          )
        ],
      ),
    );
  }
}
