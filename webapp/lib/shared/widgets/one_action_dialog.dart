import 'package:flutter/material.dart';

class OneActionDialog extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback action;

  const OneActionDialog({
    required this.message,
    required this.buttonText,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: action, child: Text(buttonText)),
        ],
      ),
    );
  }
}

Future<void> showOneActionDialog(
  BuildContext context, {
  required String message,
  required String buttonText,
  required VoidCallback action,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              action();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
