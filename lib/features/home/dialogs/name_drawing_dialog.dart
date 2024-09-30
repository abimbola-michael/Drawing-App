import 'package:drawingapp/features/drawing/widgets/dialog_button.dart';
import 'package:drawingapp/features/home/models/drawing.dart';
import 'package:drawingapp/features/home/providers/drawing_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameDrawingDialog extends ConsumerStatefulWidget {
  final Drawing drawing;
  const NameDrawingDialog({super.key, required this.drawing});

  @override
  ConsumerState<NameDrawingDialog> createState() => _NameDrawingDialogState();
}

class _NameDrawingDialogState extends ConsumerState<NameDrawingDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final controller = TextEditingController(text: widget.drawing.name);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveDrawing(BuildContext context, WidgetRef ref) {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final name = controller.text;
    //drawing.name = name;

    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Drawing Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            // if (message != null) ...[
            //   const SizedBox(height: 4),
            //   Text(
            //     message!,
            //     style: const TextStyle(fontSize: 14),
            //   )
            // ],
            const SizedBox(height: 10),
            TextFormField(
              // key: formKey,
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(fontSize: 14),
              ),
              validator: (value) {
                // if (value == null) return null;
                if (value == null || value.isEmpty) {
                  return "Name is required";
                }
                final nameExist =
                    ref.read(drawingListProvider.notifier).getDrawing(value) !=
                        null;
                if (nameExist) {
                  return "Name already used, Try Another";
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DialogButton(
                    backgroundColor: Colors.red,
                    title: "Cancel",
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DialogButton(
                    title: "Save",
                    onPressed: () => saveDrawing(context, ref),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

extension DialogExtension on BuildContext {
  Future showNameDrawingDialog({required Drawing drawing}) {
    return showDialog(
        context: this,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: NameDrawingDialog(drawing: drawing),
          );
        });
  }
}
