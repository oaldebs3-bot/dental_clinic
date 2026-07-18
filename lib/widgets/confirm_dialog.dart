import 'package:flutter/material.dart';
import 'dental_colors.dart';

Future<bool> showConfirmDialog(BuildContext context, {required String title, required String message}) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: DentalColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(message, style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء', style: TextStyle(color: Colors.white54))),
        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('تأكيد')),
      ],
    ),
  ) ?? false;
}
