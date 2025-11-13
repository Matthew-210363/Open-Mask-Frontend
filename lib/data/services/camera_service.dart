import 'dart:io';

import 'package:camera/camera.dart';
import 'package:open_mask/data/services/snackbar_service.dart';

class CameraService {
  CameraService({this.resolutionPreset = ResolutionPreset.medium});

  late CameraController cameraController;
  late CameraDescription camera;
  final ResolutionPreset resolutionPreset;

  Future<void> initialize() async {
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } catch (e) {
      SnackBarService.showMessage('Probleme beim Finden einer Kamera');
      return;
    }
    // Bevorzugt die Frontkamera wählen:
    camera = cameras.firstWhere(
      (final camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    // Kamera Controller initialisieren:
    cameraController = CameraController(
      camera, resolutionPreset,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup
              .nv21 // Format, das für Android verwendet werden soll
          : ImageFormatGroup
              .bgra8888, // Format, das für iOS verwendet werden soll
    );
    try {
      await cameraController.initialize();
    } catch (e) {
      SnackBarService.showMessage('Initialisierung der Kamera fehlgeschlagen');
      return;
    }
  }

  Future<XFile> takePicture() async {
    if (!cameraController.value.isInitialized) {
      SnackBarService.showMessage('Kamera noch nicht initialisiert');
    }
    return await cameraController.takePicture();
  }

  void dispose() {
    cameraController.dispose();
  }
}
