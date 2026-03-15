import 'package:open_mask/data/services/auth_service.dart';
import 'package:open_mask/filter/configs/filter_config.dart';
import 'package:open_mask/filter/filter_meta.dart';
import 'package:open_mask/filter/filter_type.dart';
import 'package:open_mask/filter/templates/composite_filter.dart';
import 'package:open_mask/filter/templates/hat_filter.dart';
import 'package:open_mask/filter/templates/left_eye_filter.dart';
import 'package:open_mask/filter/templates/mask_filter.dart';
import 'package:open_mask/filter/templates/mustache_filter.dart';
import 'package:open_mask/filter/templates/right_eye_filter.dart';

import 'i_filter.dart';

/// Factory-Klasse zum Erstellen von konkreten Filter-Instanzen.
class FilterFactory {
  /// Erzeugt einen neuen Filter mit dem passenden Typ.
  static IFilter create(final FilterType type,
      {final bool isCreatedByUser = false}) {
    FilterMeta meta = isCreatedByUser
        ? FilterMeta(
            createdBy: AuthService.instance.user, createdAt: DateTime.now())
        : FilterMeta();
    switch (type) {
      case FilterType.composite:
        meta.name = 'Composite-Filter';
        return CompositeFilter(meta: meta);
      case FilterType.mustache:
        meta.name = 'Schnurrbart';
        return MustacheFilter(
            meta: meta, config: FilterConfig(), filterImage: null);
      case FilterType.hat:
        meta.name = 'Hut';
        return HatFilter(meta: meta, config: FilterConfig(), filterImage: null);
      case FilterType.mask:
        meta.name = 'Maske';
        return MaskFilter(
            meta: meta, config: FilterConfig(), filterImage: null);
      case FilterType.leftEye:
        meta.name = 'Linkes Auge';
        return LeftEyeFilter(
            meta: meta, config: FilterConfig(), filterImage: null);
      case FilterType.rightEye:
        meta.name = 'Rechtes Auge';
        return RightEyeFilter(
            meta: meta, config: FilterConfig(), filterImage: null);

      // TODO: weitere Filterarten
    }
  }

  /// Stellt einen Filter aus einem JSON-Objekt wieder her.
  static IFilter fromJSON(final Map<String, dynamic> json) {
    FilterType filterType = filterTypeFromString(json['type']);
    switch (filterType) {
      case FilterType.composite:
        return CompositeFilter.fromJSON(json);
      case FilterType.mustache:
        return MustacheFilter.fromJSON(json);
      case FilterType.hat:
        return HatFilter.fromJSON(json);
      case FilterType.mask:
        return MaskFilter.fromJSON(json);
      case FilterType.leftEye:
        return LeftEyeFilter.fromJSON(json);
      case FilterType.rightEye:
        return RightEyeFilter.fromJSON(json);
      // TODO: weitere Filterarten
    }
  }
}
