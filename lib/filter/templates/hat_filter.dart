import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/src/face_detector.dart';
import 'package:open_mask/data/model/scale.dart';
import 'package:open_mask/filter/filter_type.dart';
import 'package:open_mask/filter/templates/image_filter.dart';

/// Filter, der einen Hut auf dem Kopf platziert.
class HatFilter extends ImageFilter {
  HatFilter({super.id, required super.meta, required super.config})
      : super(type: FilterType.hat);

  /// Factory-Methode zur JSON‑Deserialisierung.
  factory HatFilter.fromJSON(final Map<String, dynamic> json) =>
      HatFilter(id: json['id'], meta: json['meta'], config: json['config']);

  @override
  void apply(final Face face, final Canvas canvas, final Size canvasSize,
      final Scale scale, final bool isFrontCamera) {
    // Position über Stirnmitte berechnen
    // Bild skalieren und auf den Kopf zeichnen

    if (image == null) {
      if (!isLoading) {
        load();
      }
      return;
    }

    final landmarks = face.landmarks;

    final double canvasWidth = min(canvasSize.width, canvasSize.height);

    // Wichtige Landmarken prüfen
    final leftEye = landmarks[FaceLandmarkType.leftEye];
    final rightEye = landmarks[FaceLandmarkType.rightEye];
    final noseBase = landmarks[FaceLandmarkType.noseBase];

    if (leftEye == null || rightEye == null || noseBase == null) return;

    // Gesichtszentrum und Breite/Höhe bestimmen
    final faceCenter = Offset(face.boundingBox.center.dx * scale.scaleX,
        face.boundingBox.center.dy * scale.scaleX);

    final faceWidth = face.boundingBox.width * scale.scaleX;

    final faceHeight = face.boundingBox.height * scale.scaleY;

    // Stirnposition oberhalb des Gesichts
    final foreheadCenter =
        Offset(faceCenter.dx, face.boundingBox.top * scale.scaleY);

    // Gesichtsrotation (Neigung)
    final faceRotation =
        (isFrontCamera ? -face.headEulerAngleX! : face.headEulerAngleX!) *
            pi /
            180;

    // Skalierung & Offsets aus Config
    final configScaleX = config.scale.scaleX;
    final configScaleY = config.scale.scaleY;

    final hatWidth = faceWidth * configScaleX;
    final hatHeight = faceHeight * configScaleY;

    final offsetX = (config.offset.dx) * faceWidth;
    final offsetY = (config.offset.dy) * faceHeight;

    // Rotation kombinieren
    final extraRotation =
        (isFrontCamera ? -config.rotation : config.rotation) * pi / 180;
    double totalRotation = faceRotation + extraRotation;

    // Bild korrekt transformieren und malen
    final hatRect = Rect.fromCenter(
      center: Offset(
          isFrontCamera
              ? canvasWidth - foreheadCenter.dx
              : foreheadCenter.dx + offsetX,
          foreheadCenter.dy + offsetY),
      width: hatWidth,
      height: hatHeight,
    );

    canvas.save();

    // Rotation um Mittelpunkt des Bildes (nicht des Canvas!)
    //canvas.translate(hatRect.center.dx, hatRect.center.dy);
    //canvas.rotate(totalRotation);

    // Das Bild zeichnen
    /*final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.cyanAccent;
    canvas.drawRect(hatRect, paint);*/
    paintImage(
      canvas: canvas,
      rect: hatRect,
      image: image!,
      opacity: config.opacity,
      filterQuality: FilterQuality.high,
    );

    canvas.restore();
  }
}
