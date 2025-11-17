import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:open_mask/data/services/camera_service.dart';
import 'package:open_mask/data/services/face_detection_service.dart';
import 'package:provider/provider.dart';

import 'face_markings_painter.dart';

/// View, welches ein Filter-Overlay über darstellt, welches Gesichtserkennungsmarkierungen mithilfe vom [FaceMarkingsPainter] darstellt.
class FaceMarkingsView extends StatelessWidget {
  /// Standard-Konstruktor.
  /// <ul>
  ///   <li>[showMarkings] Gibt an, ob Markierungen angezeigt werden sollen. </li>
  ///   <li>[showLandmarks] Gibt an, ob erkannte Punkte wie Nasen, Augen, Ohren, etc. ebenfalls visualisiert werden sollen. </li>
  /// </ul>
  const FaceMarkingsView(
      {super.key,
      final bool showMarkings = true,
      final bool showLandmarks = true})
      : _showLandmarks = showLandmarks,
        _showMarkings = showMarkings;

  /// Gibt an, ob Markierungen angezeigt werden sollen.
  final bool _showMarkings;

  /// Gibt an, ob erkannte Punkte wie Nasen, Augen, Ohren, etc. ebenfalls visualisiert werden sollen.
  final bool _showLandmarks;

  @override
  Widget build(final BuildContext context) {
    final faceDetectionService = Provider.of<FaceDetectionService>(context);
    final cameraService = Provider.of<CameraService>(context);

    if (!_showMarkings || faceDetectionService.imageSize == null) {
      return Container();
    }

    print('Face Detector View build');
    return CustomPaint(
      foregroundPainter: FaceMarkingsPainter(
          faceDetectionService.faces, faceDetectionService.imageSize!,
          isFrontCamera:
              cameraService.cameraController?.description.lensDirection ==
                  CameraLensDirection.front,
          showLandmarks: _showLandmarks),
      size: (cameraService.cameraController?.value.previewSize != null)
          ? cameraService.cameraController!.value.previewSize!
          : Size.zero,
    );
  }
}
