// lib/features/transactions/widgets/filter_bar.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../models/category.dart';

class FilterBar extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final bool showAnomaliesOnly;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<bool> onAnomalyToggle;

  const FilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.showAnomaliesOnly,
    required this.onCategoryChanged,
    required this.onAnomalyToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 48,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(
            label: l10n.allCategories,
            selected: selectedCategoryId == null && !showAnomaliesOnly,
            onTap: () {
              onCategoryChanged(null);
              onAnomalyToggle(false);
            },
          ),
          const SizedBox(width: 8),
          _Chip(
            label: '⚠️ ${l10n.anomaliesDetected}',
            selected: showAnomaliesOnly,
            onTap: () => onAnomalyToggle(!showAnomaliesOnly),
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 8),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _Chip(
                  label:
                      '${cat.icon} ${cat.localName(Localizations.localeOf(context).languageCode)}',
                  selected: selectedCategoryId == cat.id,
                  onTap: () => onCategoryChanged(
                      selectedCategoryId == cat.id ? null : cat.id),
                  color: cat.color,
                ),
              )),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const _Chip(
      {required this.label,
      required this.selected,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: selected ? c : Theme.of(context).dividerColor),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? c
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            )),
      ),
    );
  }
}
