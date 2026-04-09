// lib/features/transactions/screens/transactions_screen.dart
// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/filter_bar.dart';
import '../../../shared/widgets/loading_widget.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});
  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  int? _selectedCategoryId;
  bool _showAnomaliesOnly = false;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<TransactionModel> _filtered(List<TransactionModel> all) {
    var list = all;
    if (_selectedCategoryId != null)
      list = list.where((t) => t.categoryId == _selectedCategoryId).toList();
    if (_showAnomaliesOnly) list = list.where((t) => t.isAnomaly).toList();
    if (_searchCtrl.text.isNotEmpty) {
      final q = _searchCtrl.text.toLowerCase();
      list = list
          .where((t) =>
              t.description?.toLowerCase().contains(q) == true ||
              t.amount.toString().contains(q))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(transactionProvider);
    if (state.isLoading && state.transactions.isEmpty)
      return const LoadingWidget();
    final filtered = _filtered(state.transactions);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactions),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: '${l10n.search}...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        })
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ),
      body: Column(children: [
        FilterBar(
          categories: state.categories,
          selectedCategoryId: _selectedCategoryId,
          showAnomaliesOnly: _showAnomaliesOnly,
          onCategoryChanged: (id) => setState(() => _selectedCategoryId = id),
          onAnomalyToggle: (v) => setState(() => _showAnomaliesOnly = v),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Text(l10n.noTransactions,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5))),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addTransaction),
                    onPressed: () => context.go('/transactions/add'),
                  ),
                ]))
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(transactionProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final tx = filtered[i];
                      return TransactionTile(
                        transaction: tx,
                        categories: state.categories,
                        onTap: () => context.go('/transactions/edit/${tx.id}'),
                      );
                    },
                  ),
                ),
        ),
      ]),
    );
  }
}
