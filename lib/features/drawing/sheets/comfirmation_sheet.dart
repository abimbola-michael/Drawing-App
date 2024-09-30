import 'package:drawingapp/features/drawing/widgets/dialog_button.dart';
import 'package:flutter/material.dart';

class ComfirmationSheet extends StatelessWidget {
  final String title;
  final String? message;
  const ComfirmationSheet({super.key, required this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message!,
              style: const TextStyle(fontSize: 14),
            )
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DialogButton(
                  backgroundColor: Colors.red,
                  title: "No",
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DialogButton(
                  title: "Yes",
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension SheetExtension on BuildContext {
  Future showComfirmationSheet({required String title, String? message}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: this,
        builder: (context) {
          return ComfirmationSheet(title: title, message: message);
        });
  }
}
