import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/src/face_detector.dart';
import 'package:open_mask/data/model/scale.dart';
import 'package:open_mask/data/services/geometry_service.dart';
import 'package:open_mask/filter/configs/filter_config.dart';
import 'package:open_mask/filter/face_geometry_calculator.dart';
import 'package:open_mask/filter/filter_image.dart';
import 'package:open_mask/filter/filter_meta.dart';
import 'package:open_mask/filter/filter_type.dart';
import 'package:open_mask/filter/templates/image_filter.dart';

/// Filter, der einen Hut auf dem Kopf platziert.
class HatFilter extends ImageFilter {
  /// Standard-Konstruktor.
  HatFilter(
      {super.id,
      required super.meta,
      required super.config,
      required super.filterImage})
      : super(
            type: FilterType.hat,
            defaultAssetPath: 'assets/images/filter/hat.png',
            defaultImageFilename: 'hat.png',
            defaultScale: const Scale(1.3, 1.2));

  /// Factory-Methode zur JSON‑Deserialisierung.
  factory HatFilter.fromJSON(final Map<String, dynamic> json) {
    Map<String, dynamic> configJson = json['config'] ?? {};

    Map<String, dynamic> filterImageJson = json['filterImage'] ?? {};
    FilterImage filterImage = FilterImage.fromJSON(filterImageJson);

    FilterConfig filterConfig = FilterConfig.fromJSON(configJson);

    return HatFilter(
        id: int.tryParse(json['id']),
        meta: FilterMeta.fromJson(json['meta']),
        config: filterConfig,
        filterImage: filterImage);
  }

  @override
  void apply(
      final Face face, final Canvas canvas, final FaceGeometryCalculator fgc) {
    if (filterImage.image == null) return;

    position = fgc.calculateDynamicFaceCenter(face);

    final Size faceSize = fgc.calculateDynamicFaceSize(face);
    final hatOffsetY = -0.75 * faceSize.height;
    // Rotation berechnen
    final totalRotation =
        fgc.calculateFaceZRotation(face, extraRotation: config.rotation);
    final rotatedOffset =
        GeometryService.rotateOffset(Offset(0, hatOffsetY), totalRotation);

    position = Offset(
        position!.dx + rotatedOffset.dx, position!.dy + rotatedOffset.dy);

    super.apply(face, canvas, fgc);
  }
}
