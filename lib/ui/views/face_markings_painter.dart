import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:open_mask/data/services/face_detection_service.dart';
import 'package:open_mask/data/services/geometry_service.dart';

/// Ein [CustomPainter], welcher die Gesichtserkennung des [FaceDetectionService] visualisiert.
class FaceMarkingsPainter extends CustomPainter {
  /// Standard-Konstruktor.
  /// <ul>
  ///   <li>[faces] Liste der analysierten Gesichter, die visualisiert werden sollen. </li>
  ///   <li>[imageSize] Größe des Originalbildes. </li>
  ///   <li>[isFrontCamera] Gibt an, ob die verwendete Kamera die Frontkamera ist und das Preview daher gespiegelt ist. </li>
  ///   <li>[showLandmarks] Gibt an, ob erkannte Punkte wie Nasen, Augen, Ohren, etc. ebenfalls visualisiert werden sollen. </li>
  /// </ul>
  FaceMarkingsPainter(final List<Face> faces, final Size imageSize,
      {final bool isFrontCamera = true, final bool showLandmarks = true})
      : _faces = faces,
        _imageSize = imageSize,
        _showLandmarks = showLandmarks,
        _isFrontCamera = isFrontCamera;

  /// Liste der analysierten Gesichter, die visualisiert werden sollen.
  final List<Face> _faces;

  /// Größe des Originalbildes.
  final Size _imageSize;

  /// Gibt an, ob die verwendete Kamera die Frontkamera ist und das Preview daher gespiegelt ist.
  final bool _isFrontCamera;

  /// Gibt an, ob erkannte Punkte wie Nasen, Augen, Ohren, etc. ebenfalls visualisiert werden sollen.
  final bool _showLandmarks;

  @override
  void paint(final Canvas canvas, final Size size) {
    // richtige Zuordnung von Breite und Höhe
    final double canvasWidth = min(size.width, size.height);
    final double canvasHeight = max(size.width, size.height);
    final double originalWidth = min(_imageSize.width, _imageSize.height);
    final double originalHeight = max(_imageSize.width, _imageSize.height);
    // Scale ausrechnen
    final double scaleX = canvasWidth / originalWidth;
    final double scaleY = canvasHeight / originalHeight;

    // Debug-Ausgabe:
    print('FaceMarkingsPainter:');
    print('Canvas size: $size, Image size: $_imageSize');
    print('ScaleX: $scaleX, ScaleY: $scaleY');
    print(_faces.length);

    for (final Face face in _faces) {
      double left = _isFrontCamera
          ? size.width - face.boundingBox.left * scaleX // spiegeln
          : face.boundingBox.left * scaleX;
      double top = face.boundingBox.top * scaleY;
      double right = _isFrontCamera
          ? size.width - face.boundingBox.right * scaleX // spiegeln
          : face.boundingBox.right * scaleX;
      double bottom = face.boundingBox.bottom * scaleY;

      final Rect faceRect = Rect.fromLTRB(left, top, right, bottom);

      final double faceWidthPortion =
          ((faceRect.width < 0) ? -faceRect.width : faceRect.width) /
              canvasWidth;
      final double faceHeightPortion =
          ((faceRect.height < 0) ? -faceRect.height : faceRect.height) /
              canvasHeight;
      final double facePortion = (faceWidthPortion + faceHeightPortion) / 2;

      final double faceRectRadius = 70.0 * facePortion;
      final roundedFaceRect = RRect.fromRectAndCorners(faceRect,
          topLeft: Radius.circular(faceRectRadius),
          topRight: Radius.circular(faceRectRadius),
          bottomLeft: Radius.circular(faceRectRadius),
          bottomRight: Radius.circular(faceRectRadius));

      final Paint faceRectPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0 * facePortion
        ..color = Colors.white;
      final Paint faceRectInnerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * facePortion
        ..color = Colors.blueAccent;

      // Debug-Ausgabe
      //print('Gesichtsbreite: ${faceRect.width}');
      //print('Gesichtshöhe: ${faceRect.height}');
      //print('Canvas-Breite: $canvasWidth');
      //print('Canvas-Höhe: $canvasHeight');
      //print('Gesichtshöhe: ${faceRect.height}');
      //print('Anteil der Gesichtsbreite: $faceWidthPortion');
      //print('Anteil der Gesichtshöhe: $faceHeightPortion');
      //print('Anteil des Gesichts: $facePortion');

      final totalRotation = GeometryService.calculateFaceZRotation(face,
          inverseX: _isFrontCamera);

      // Canvas-Transformationen
      canvas.save();

      // Um Mittelpunkt des Gesichts rotieren
      canvas.translate(faceRect.center.dx, faceRect.center.dy);
      canvas.rotate(_isFrontCamera ? -totalRotation : totalRotation);
      canvas.translate(-faceRect.center.dx, -faceRect.center.dy);

      canvas.drawRRect(roundedFaceRect, faceRectPaint);
      canvas.drawRRect(roundedFaceRect, faceRectInnerPaint);

      canvas.restore();

      if (!_showLandmarks) {
        continue;
      }
      // Gesichts-Features:
      if (face.landmarks.isNotEmpty) {
        List<Offset> points = List.from([], growable: true);
        for (final FaceLandmarkType landmarkType in face.landmarks.keys) {
          if (face.landmarks[landmarkType] == null) {
            continue;
          }
          Point<int> landmarkPosition = face.landmarks[landmarkType]!.position;
          double x = _isFrontCamera
              ? size.width - landmarkPosition.x.toDouble() * scaleX // spiegeln
              : landmarkPosition.x.toDouble() * scaleX;
          double y = landmarkPosition.y.toDouble() * scaleY;

          Offset offset = Offset(x, y);
          points.add(offset);
        }

        final strokeWidth = 3.0 * facePortion;
        final Paint pointPaint = Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = strokeWidth
          ..color = Colors.white.withAlpha(150)
          ..strokeCap = StrokeCap.round;

        canvas.drawPoints(PointMode.points, points, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant final FaceMarkingsPainter oldDelegate) {
    return oldDelegate._faces != _faces;
  }
}
