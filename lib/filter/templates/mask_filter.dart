import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/src/face_detector.dart';
import 'package:open_mask/filter/configs/filter_config.dart';
import 'package:open_mask/filter/face_geometry_calculator.dart';
import 'package:open_mask/filter/filter_image.dart';
import 'package:open_mask/filter/filter_meta.dart';
import 'package:open_mask/filter/filter_type.dart';
import 'package:open_mask/filter/templates/image_filter.dart';

/// Filter, welcher eine Maske über das Gesicht legt (Positionierung basierend auf der Bounding-Box des Gesichts).
class MaskFilter extends ImageFilter {
  /// Standard-Konstruktor.
  MaskFilter(
      {super.id,
      required super.meta,
      required super.config,
      required super.filterImage})
      : super(
            type: FilterType.mask,
            defaultAssetPath: 'assets/images/filter/mask.png',
            defaultImageFilename: 'mask.png',
            defaultOffset: const Offset(0.0, -25));

  /// Factory-Methode zur JSON‑Deserialisierung.
  factory MaskFilter.fromJSON(final Map<String, dynamic> json) {
    Map<String, dynamic> configJson = json['config'] ?? {};

    FilterConfig filterConfig = FilterConfig.fromJSON(configJson);

    Map<String, dynamic> filterImageJson = json['filterImage'] ?? {};
    FilterImage filterImage = FilterImage.fromJSON(filterImageJson);

    return MaskFilter(
        id: int.tryParse(json['id']),
        meta: FilterMeta.fromJson(json['meta']),
        config: filterConfig,
        filterImage: filterImage);
  }

  @override
  void apply(
      final Face face, final Canvas canvas, final FaceGeometryCalculator fgc) {
    if (filterImage.image == null) return;

    // Gesichtsdaten
    position = fgc.calculateDynamicFaceCenter(face);
    super.apply(face, canvas, fgc);
  }
}
