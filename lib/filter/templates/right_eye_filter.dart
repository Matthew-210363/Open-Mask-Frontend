import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/src/face_detector.dart';
import 'package:open_mask/filter/configs/filter_config.dart';
import 'package:open_mask/filter/face_geometry_calculator.dart';
import 'package:open_mask/filter/filter_image.dart';
import 'package:open_mask/filter/filter_meta.dart';
import 'package:open_mask/filter/filter_type.dart';
import 'package:open_mask/filter/templates/image_filter.dart';

/// Filter, dessen Position auf dem rechten Auge basiert. Wird nicht angezeigt, wenn das Auge geschlossen ist.
class RightEyeFilter extends ImageFilter {
  /// Standard-Konstruktor.
  RightEyeFilter(
      {super.id,
      required super.meta,
      required super.config,
      required super.filterImage})
      : super(
            type: FilterType.rightEye,
            defaultAssetPath: 'assets/images/filter/red_glowing_eye.png',
            defaultImageFilename: 'eye.png');

  /// Factory-Methode zur JSON‑Deserialisierung.
  factory RightEyeFilter.fromJSON(final Map<String, dynamic> json) {
    Map<String, dynamic> configJson = json['config'] ?? {};

    FilterConfig filterConfig = FilterConfig.fromJSON(configJson);

    Map<String, dynamic> filterImageJson = json['filterImage'] ?? {};
    FilterImage filterImage = FilterImage.fromJSON(filterImageJson);

    return RightEyeFilter(
        id: int.tryParse(json['id']),
        meta: FilterMeta.fromJson(json['meta']),
        config: filterConfig,
        filterImage: filterImage);
  }

  @override
  void apply(
      final Face face, final Canvas canvas, final FaceGeometryCalculator fgc) {
    final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
    if (rightEye == null || (face.rightEyeOpenProbability ?? 1) < 0.05) {
      return;
    }
    // Position transformieren
    super.position = fgc.transformPoint(rightEye.position);
    super.apply(face, canvas, fgc);
  }
}
