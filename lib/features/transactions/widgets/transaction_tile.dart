// lib/features/transactions/widgets/transaction_tile.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final List<CategoryModel> categories;
  final VoidCallback? onTap;
  const TransactionTile(
      {super.key,
      required this.transaction,
      required this.categories,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final cat = transaction.categoryId != null
        ? categories.firstWhere((c) => c.id == transaction.categoryId,
            orElse: () => CategoryModel.defaults.last)
        : CategoryModel.defaults.last;
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: cat.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(cat.icon, style: const TextStyle(fontSize: 20))),
        ),
        title: Row(children: [
          Expanded(
              child: Text(
            transaction.description ?? l10n.noDescription,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          if (transaction.isAnomaly)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: const Text('⚠️', style: TextStyle(fontSize: 11)),
            ),
        ]),
        subtitle: Text(
          '${cat.localName(locale)} · ${DateFormat('dd/MM/yyyy').format(transaction.date)}',
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
        trailing: Text(
          '${transaction.amount.toStringAsFixed(3)} TND',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
