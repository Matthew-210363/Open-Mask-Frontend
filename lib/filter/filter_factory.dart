import 'package:open_mask/filter/filter_type.dart';
import 'package:open_mask/filter/templates/composite_filter.dart';
import 'package:open_mask/filter/templates/hat_filter.dart';
import 'package:open_mask/filter/templates/mustache_filter.dart';

import 'i_filter.dart';

class FilterFactory {
  /// Erzeugt einen Filter nach Typ und JSON‑Daten.
  static IFilter create(final Map<String, dynamic> json) {
    FilterType filterType = filterTypeFromString(json['type']);
    switch (filterType) {
      case FilterType.mustache:
        return MustacheFilter.fromJSON(json);
      case FilterType.composite:
        return CompositeFilter.fromJSON(json);
      case FilterType.hat:
        return HatFilter.fromJSON(json);
      // TODO: weitere Filterarten
    }
  }
}
