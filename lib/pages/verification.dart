import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/widgets/appbar.dart' as appbar;
import 'package:nami_assignment/widgets/buttons.dart' as buttons;

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key});

  static const String routePath = '/verification';
  static const String routeName = 'Verification';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar.AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 160),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please enter code given by professor",
                  style: context.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter Code',
                  labelText: 'Enter Code',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
              const SizedBox(height: 32),
              buttons.FilledButton(
                onPressed: () {},
                child: Text(
                  'Submit',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                "Powered by Lucify",
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ));
  }
}
