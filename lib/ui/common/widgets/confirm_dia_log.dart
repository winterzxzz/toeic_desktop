import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showConfirmDialog(
    BuildContext context, String title, String content, Function() onConfirm) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: Text('Hủy')),
              ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                    onConfirm();
                  },
                  child: Text('Đồng ý')),
            ],
          ));
}
