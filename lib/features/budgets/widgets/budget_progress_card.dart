// lib/features/budgets/widgets/budget_progress_card.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../models/budget.dart';
import '../../transactions/models/category.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetModel budget;
  final CategoryModel category;
  final String currency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetProgressCard({
    super.key,
    required this.budget,
    required this.category,
    required this.currency,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isOver = budget.isOverBudget;
    final progressColor =
        isOver ? Theme.of(context).colorScheme.error : category.color;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: category.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(category.icon,
                      style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(category.localName(locale),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  if (isOver)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(l10n.overBudget,
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.w600)),
                    ),
                ])),
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      const Icon(Icons.edit_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(l10n.editTransaction),
                    ])),
                PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      const Icon(Icons.delete_outlined,
                          size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(l10n.delete,
                          style: const TextStyle(color: Colors.red)),
                    ])),
              ],
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
            ),
          ]),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: budget.progress,
              minHeight: 8,
              backgroundColor: progressColor.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${l10n.spent}: ${budget.spent.toStringAsFixed(3)} $currency',
                style: Theme.of(context).textTheme.bodySmall),
            Text(
              isOver
                  ? '-${budget.remaining.abs().toStringAsFixed(3)} $currency'
                  : '${l10n.remaining}: ${budget.remaining.toStringAsFixed(3)} $currency',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOver
                      ? Theme.of(context).colorScheme.error
                      : category.color),
            ),
          ]),
          const SizedBox(height: 4),
          Text(
              '${l10n.budgetLimit}: ${budget.limitAmount.toStringAsFixed(3)} $currency',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5))),
        ]),
      ),
    );
  }
}
