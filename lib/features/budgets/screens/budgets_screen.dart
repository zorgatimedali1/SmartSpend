// lib/features/budgets/screens/budgets_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../providers/budget_provider.dart';
import '../models/budget.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../widgets/budget_progress_card.dart';
import '../widgets/set_budget_sheet.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final budgetState = ref.watch(budgetProvider);
    final txState = ref.watch(transactionProvider);
    final currency = ref.watch(settingsProvider).currency;
    final locale = Localizations.localeOf(context).toString();

    if (budgetState.isLoading && budgetState.budgets.isEmpty)
      // ignore: curly_braces_in_flow_control_structures
      return const LoadingWidget();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(DateFormat('MMMM yyyy', locale).format(DateTime.now()),
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSetBudgetSheet(context, ref, null),
        tooltip: l10n.setBudget,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: () => ref.read(budgetProvider.notifier).refresh(),
        child: budgetState.budgets.isEmpty
            ? ListView(children: [
                const SizedBox(height: 120),
                Center(
                    child: Column(children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Text(l10n.noBudgets,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showSetBudgetSheet(context, ref, null),
                    child: Text(l10n.setBudget),
                  ),
                ])),
              ])
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: budgetState.budgets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final budget = budgetState.budgets[i];
                  final cat = txState.categories.firstWhere(
                      (c) => c.id == budget.categoryId,
                      orElse: () => txState.categories.last);
                  return BudgetProgressCard(
                    budget: budget,
                    category: cat,
                    currency: currency,
                    onEdit: () => _showSetBudgetSheet(context, ref, budget),
                    onDelete: () =>
                        ref.read(budgetProvider.notifier).delete(budget.id),
                  );
                },
              ),
      ),
    );
  }

  void _showSetBudgetSheet(
      BuildContext context, WidgetRef ref, BudgetModel? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SetBudgetSheet(existing: existing),
    );
  }
}
