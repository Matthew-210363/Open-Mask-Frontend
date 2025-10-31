import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:open_mask/data/model/scale.dart';
import 'package:open_mask/filter/i_filter.dart';

class FaceFilterPainter extends CustomPainter {
  FaceFilterPainter({
    required final List<Face> faces,
    required final Size imageSize,
    required final bool isFrontCamera,
    required final IFilter filter,
  })  : _imageSize = imageSize,
        _faces = faces,
        _isFrontCamera = isFrontCamera,
        _filter = filter;

  final List<Face> _faces;
  final Size _imageSize;
  final bool _isFrontCamera;
  final IFilter _filter;

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
    final Scale scale = Scale(scaleX, scaleY);

    // Debug-Ausgabe:
    print('Face Filter:');
    print('Canvas size: $size, Image size: $_imageSize');
    print('ScaleX: $scaleX, ScaleY: $scaleY');

    for (final Face face in _faces) {
      _filter.apply(face, canvas, size, scale, _isFrontCamera);
    }
  }

  @override
  bool shouldRepaint(covariant final FaceFilterPainter oldDelegate) {
    return oldDelegate._faces != _faces || oldDelegate._filter != _filter;
  }
}
