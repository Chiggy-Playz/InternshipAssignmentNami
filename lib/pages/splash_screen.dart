import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/pages/login.dart';

class SplashScreenPage extends ConsumerStatefulWidget {
  const SplashScreenPage({super.key});

  static const String routePath = '/splash';
  static const String routeName = 'Splash';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SplashScreenPageState();
}

class SplashScreenPageState extends ConsumerState<SplashScreenPage>
    with TickerProviderStateMixin {
  double opacity = 0.0;
  double whiteBoxSize = 2000;
  double imageSize = 12;
  double textOpacity = 0.0;
  Color? scaffoldColor;
  Color? textColor;
  // I'm sorry its 2am and i cant think straight 😭
  double moveUp = 0.0;

  // Durations
  Duration whiteBoxDuration = const Duration(milliseconds: 1000);
  Duration imageSizeDuration = const Duration(milliseconds: 1000);
  Duration textDuration = const Duration(milliseconds: 1000);

  // Curves
  Curve whiteBoxCurve = Curves.easeOutSine;
  Curve imageSizeCurve = Curves.easeOutQuad;
  Curve textCurve = Curves.easeOutSine;

  Animation? scaffoldBackgroundAnimation;
  AnimationController? scaffoldBackgroundController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(animate);
  }

  @override
  void dispose() {
    scaffoldBackgroundController!.dispose();
    super.dispose();
  }

  Future<void> animate(_) async {
    scaffoldBackgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    scaffoldBackgroundAnimation = ColorTween(
      begin: context.colorScheme.primary,
      end: Colors.white,
    ).animate(scaffoldBackgroundController!)
      ..addListener(() {
        setState(() {});
      });

    setState(() {
      whiteBoxSize = 128;
    });
    await Future.delayed(whiteBoxDuration - const Duration(milliseconds: 100));
    setState(() {
      imageSize = 128;
    });
    await Future.delayed(imageSizeDuration);
    setState(() {
      textOpacity = 1.0;
    });
    await Future.delayed(textDuration);

    // Before moving the things up, set curves and durations same so there is no mismatch

    setState(() {
      whiteBoxCurve = Curves.easeOutQuad;
      imageSizeCurve = Curves.easeOutQuad;
      textCurve = Curves.easeOutQuad;

      whiteBoxDuration = const Duration(milliseconds: 1000);
      imageSizeDuration = const Duration(milliseconds: 1000);
      textDuration = const Duration(milliseconds: 1000);
    });

    setState(() {
      scaffoldColor = Colors.white;
      textColor = context.colorScheme.primary;
      moveUp = 290;
    });
    scaffoldBackgroundController!.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    context.go(LoginPage.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          scaffoldBackgroundAnimation?.value ?? context.colorScheme.primary,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: whiteBoxDuration,
            curve: whiteBoxCurve,
            top: MediaQuery.of(context).size.height * 0.5 -
                whiteBoxSize / 2 -
                moveUp,
            left: MediaQuery.of(context).size.width * 0.5 - whiteBoxSize / 2,
            child: AnimatedContainer(
              duration: whiteBoxDuration,
              curve: whiteBoxCurve,
              width: whiteBoxSize,
              height: whiteBoxSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.22),
                    blurRadius: 15,
                    offset: const Offset(-7, 7),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: imageSizeDuration,
            curve: imageSizeCurve,
            top: MediaQuery.of(context).size.height * 0.5 -
                imageSize / 2 -
                moveUp,
            left: MediaQuery.of(context).size.width * 0.5 - imageSize / 2,
            child: AnimatedContainer(
              curve: imageSizeCurve,
              duration: imageSizeDuration,
              width: imageSize,
              height: imageSize,
              child: Center(
                child: Image.asset(
                  'assets/images/smart_attend_logo.png',
                  height: imageSize,
                  width: imageSize,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: textDuration,
            curve: textCurve,
            top: MediaQuery.of(context).size.height * 0.5 +
                whiteBoxSize / 2 -
                moveUp,
            left: MediaQuery.of(context).size.width * 0.45 - 100 * textOpacity,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedOpacity(
                opacity: textOpacity,
                duration: textDuration,
                curve: textCurve,
                child: AnimatedDefaultTextStyle(
                  duration: textDuration,
                  curve: textCurve,
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: textColor ?? context.colorScheme.onPrimary,
                  ),
                  child: const Text("SmartAttend"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
