import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class GoogleMlKitViewmodel extends ChangeNotifier {
  bool isMRZLine(String text) {
    // Add logic to identify MRZ lines based on format.
    final mrzRegex = RegExp(r'^[A-Z0-9<]{44}$'); // Example for MRZ
    return mrzRegex.hasMatch(text);
  }

  Future<InputImage> convertCameraImageToInputImage(
      CameraImage cameraImage, CameraDescription cameraDescription) async {
    // Get image rotation
    final InputImageRotation rotation =
        _rotationIntToImageRotation(cameraDescription.sensorOrientation);

    // Image size
    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    // Metadata
    final InputImageMetadata metadata = InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
            InputImageFormat.nv21,
        bytesPerRow: 1);

    // Create InputImage
    final InputImage inputImage = InputImage.fromBytes(
      bytes: cameraImage.planes[0].bytes,
      metadata: metadata,
    );

    return inputImage;
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }
}
