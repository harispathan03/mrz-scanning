import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrz/view_model/google_ml_kit_viewmodel.dart';
import 'package:provider/provider.dart';

class GoogleMlKitPage extends StatefulWidget {
  const GoogleMlKitPage({super.key});

  @override
  State<GoogleMlKitPage> createState() => _GoogleMlKitPageState();
}

class _GoogleMlKitPageState extends State<GoogleMlKitPage> {
  late GoogleMlKitViewmodel viewModel;
  CameraController? _cameraController;
  late TextRecognizer _textRecognizer;
  bool _isProcessing = false;

  @override
  void initState() {
    viewModel = context.read<GoogleMlKitViewmodel>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await _initializeCamera();
    });
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    super.initState();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController?.initialize();
    _cameraController?.startImageStream(processCameraImage);
  }

  void processCameraImage(CameraImage cameraImage) async {
    if (_isProcessing) return;
    _isProcessing = true;
    final InputImage inputImage =
        await viewModel.convertCameraImageToInputImage(
            cameraImage, _cameraController!.description);

    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (viewModel.isMRZLine(line.text)) {
          log('Detected MRZ: ${line.text}');
        }
      }
    }

    _isProcessing = false;
  }

  void processDeviceImage(String path) async {
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(InputImage.fromFilePath(path));

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        log(line.text);
        if (viewModel.isMRZLine(line.text)) {
          log('Detected MRZ: ${line.text}');
        }
      }
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_cameraController == null || !_cameraController!.value.isInitialized) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    return Scaffold(
      body: InkWell(
          onTap: () async {
            ImagePicker picker = ImagePicker();
            XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
            if (xfile != null) {
              processDeviceImage(xfile.path);
            }
          },
          child: const Center(child: Text("Scan image from gallery"))),
      // body: CameraPreview(_cameraController!),
    );
  }
}
