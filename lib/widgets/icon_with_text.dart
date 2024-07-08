import 'package:flutter/material.dart';

class IconWithWidget extends StatelessWidget {
  const IconWithWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  final Icon icon;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8),
        text,
      ],
    );
  }
}
