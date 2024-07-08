import 'package:flutter/material.dart';
import 'package:nami_assignment/core/extensions.dart';

class SmartAttendLogo extends StatelessWidget {
  const SmartAttendLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.22),
            blurRadius: 15,
            offset: const Offset(-7, 7),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            'assets/images/smart_attend_logo.png',
          ),
        ),
      ),
    );
  }
}
