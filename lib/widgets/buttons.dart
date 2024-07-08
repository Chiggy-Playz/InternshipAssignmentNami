import 'dart:async';

import 'package:flutter/material.dart' hide FilledButton, OutlinedButton;
import 'package:flutter/material.dart' as material;

class FilledButton extends StatelessWidget {
  const FilledButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final FutureOr Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 7),
                  ),
                ]),
      child: material.FilledButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class OutlinedButton extends StatelessWidget {
  const OutlinedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final FutureOr Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: material.OutlinedButton(
        style: const ButtonStyle(),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
