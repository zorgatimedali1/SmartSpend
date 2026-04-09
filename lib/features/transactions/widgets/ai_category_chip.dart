// lib/features/transactions/widgets/ai_category_chip.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AiCategoryChip extends StatelessWidget {
  final bool loading;
  final String? label;
  const AiCategoryChip({super.key, this.loading = false, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (loading)
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: Theme.of(context).colorScheme.primary),
          )
        else
          const Text('✨', style: TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        Text(
          loading ? 'Classification IA...' : 'Suggéré par IA: $label',
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500),
        ),
      ]),
    );
  }
}
