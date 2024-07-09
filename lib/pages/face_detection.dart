import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/modules/face_detection/providers.dart';
import 'package:nami_assignment/pages/verification.dart';
import 'package:nami_assignment/widgets/appbar.dart' as appbar;
import 'package:nami_assignment/widgets/buttons.dart' as buttons;

final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

class FaceDetectionPage extends ConsumerStatefulWidget {
  const FaceDetectionPage({super.key});

  static const String routePath = '/face_detection';
  static const String routeName = 'Face Detection';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FaceDetectionPageState();
}

class _FaceDetectionPageState extends ConsumerState<FaceDetectionPage> {
  CameraController? controller;
  CameraDescription? camera;
  late Timer timer;

  bool isDetectingFace = false;

  @override
  void initState() {
    super.initState();
    timer = Timer(
      Duration.zero,
      () {},
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appbar.AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _loadCamera(),
                builder: (context, snapshot) {
                  while (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading camera'),
                    );
                  }

                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CameraPreview(
                        controller!,
                        child: const Stack(
                          children: [
                            PreviewEllipseOverlay(),
                            PreviewProgressOverlay(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Very original name, I'm aware
            const FaceDetectionContinued(),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCamera() async {
    if (controller != null) {
      return;
    }
    final cameras = await availableCameras();
    if (mounted && cameras.isEmpty) {
      context.showErrorSnackBar('No camera found');
    }
    camera = cameras[0];
    controller = CameraController(
      camera!,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.nv21,
      enableAudio: false,
    );
    await controller!.initialize();
    setState(() {});
    await startDetection();
  }

  Future<void> startDetection() async {
    // Detect face from camera
    // If face is detected, start timer
    // If face is not detected, stop timer

    controller!.startImageStream(
      (image) async {
        if (isDetectingFace) return;
        if (!mounted || ref.read(timerHandlerProvider) == 0) return;
        await tryDetect(image);
        isDetectingFace = false;
      },
    );
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas

    final sensorOrientation = camera!.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera!.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  Future<void> tryDetect(CameraImage image) async {
    isDetectingFace = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);

    if (faces.isEmpty && timer.isActive) {
      timer.cancel();
      if (mounted) {
        ref.read(timerHandlerProvider.notifier).reset();
      }
      return;
    }

    if (timer.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (ref.read(timerHandlerProvider) == 0) {
        timer.cancel();
        return;
      }
      ref.read(timerHandlerProvider.notifier).decrement();
    });
  }
}

class FaceDetectionContinued extends ConsumerStatefulWidget {
  const FaceDetectionContinued({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FaceDetectionContinuedState();
}

class _FaceDetectionContinuedState
    extends ConsumerState<FaceDetectionContinued> {
  @override
  Widget build(BuildContext context) {
    int timerCount = ref.watch(timerHandlerProvider);

    return Column(
      children: [
        const SizedBox(height: 32.0),
        Center(
          child: Text(
            "$timerCount seconds left",
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // const SizedBox(height: 8.0),
        Center(
          child: Text(
            "Keep your app in the foreground",
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        buttons.FilledButton(
          onPressed: timerCount == 0
              ? () {
                  context.push(VerificationPage.routePath);
                }
              : null,
          child: Text(
            "Capture",
            style: context.textTheme.bodyLarge!.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          "Powered by Lucify",
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class PreviewEllipseOverlay extends ConsumerStatefulWidget {
  const PreviewEllipseOverlay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreviewEllipseOverlay();
}

class _PreviewEllipseOverlay extends ConsumerState<PreviewEllipseOverlay> {
  @override
  Widget build(BuildContext context) {
    int timerCount = ref.watch(timerHandlerProvider);

    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 96.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.elliptical(250, 344),
          color: Colors.white,
          strokeWidth: 2,
          dashPattern: const [8, 8],
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                style: BorderStyle.none,
              ),
              borderRadius: const BorderRadius.all(
                Radius.elliptical(250, 344),
              ),
              color:
                  context.colorScheme.primary.withOpacity(0.2 * timerCount / 5),
            ),
          ),
        ),
      ),
    );
  }
}

class PreviewProgressOverlay extends ConsumerStatefulWidget {
  const PreviewProgressOverlay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreviewProgressOverlayState();
}

class _PreviewProgressOverlayState
    extends ConsumerState<PreviewProgressOverlay> {
  @override
  Widget build(BuildContext context) {
    int timerCount = ref.watch(timerHandlerProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
            color: Colors.black.withOpacity(0.3)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LinearProgressIndicator(
            value: (5 - timerCount) / 5,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
            minHeight: 20,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
