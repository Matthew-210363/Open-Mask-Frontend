import 'package:flutter/material.dart';
import 'package:open_mask/filter/filter_store.dart';
import 'package:open_mask/filter/i_filter.dart';
import 'package:open_mask/filter/templates/filter.dart';
import 'package:open_mask/ui/widgets/filter_grid.dart';

/// Einzelnes Filterelement, welches im [FilterGrid] benutzt wird und durch Anklicken die Auswahl als aktiven Filter ermöglicht.
class FilterTile extends StatelessWidget {
  /// Standard-Konstruktor.
  const FilterTile({super.key, required this.filter});

  /// Der konkrete, darzustellende Filter.
  final Filter filter;

  @override
  Widget build(final BuildContext context) {
    final store = FilterStore.instance;
    final isSelected = store.selectedFilter == filter as IFilter;

    return GestureDetector(
      onTap: () {
        store.selectedFilter = filter;
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(220),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              width: 45,
              height: 45,
              child: filter.meta.icon,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            filter.meta.name,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
