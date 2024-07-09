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

class _VerificationPageState extends ConsumerState<VerificationPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeOut,
        ),
      );
      setState(() {});
      animationController!.forward();
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar.AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 160),
              if (animationController != null)
                AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        MediaQuery.of(context).size.height *
                            (1 - animation!.value),
                        0.0,
                      ),
                      child: child,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                    ],
                  ),
                ),
              const Expanded(child: SizedBox()),
              Center(
                child: Text(
                  "Powered by Lucify",
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ));
  }
}
