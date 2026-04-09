// lib/features/dashboard/screens/dashboard_screen.dart
// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';
import '../widgets/anomaly_banner.dart';
import '../../transactions/widgets/transaction_tile.dart';
import '../../../shared/widgets/loading_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txState = ref.watch(transactionProvider);
    final dashboard = ref.watch(dashboardProvider);
    final user = ref.watch(authProvider).user;
    final l10n = AppLocalizations.of(context)!;
    final isFr = Localizations.localeOf(context).languageCode == 'fr';

    if (txState.isLoading && txState.transactions.isEmpty)
      return const LoadingWidget();

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.appTitle,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          Text(
            '${isFr ? 'Bonjour' : 'Hello'} ${user?.userMetadata?['full_name']?.toString().split(' ').first ?? ''} 👋',
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w400),
          ),
        ]),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () =>
                  ref.read(transactionProvider.notifier).refresh()),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(transactionProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (dashboard.anomalyCount > 0)
              AnomalyBanner(count: dashboard.anomalyCount),
            Row(children: [
              Expanded(
                  child: SummaryCard(
                      label: l10n.thisMonth,
                      amount: dashboard.totalThisMonth,
                      icon: Icons.calendar_month_outlined,
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(width: 12),
              Expanded(
                  child: SummaryCard(
                      label: l10n.lastMonth,
                      amount: dashboard.totalLastMonth,
                      icon: Icons.history_outlined,
                      color: Theme.of(context).colorScheme.secondary)),
            ]),
            const SizedBox(height: 20),
            if (dashboard.spendingByCategory.isNotEmpty) ...[
              _SectionTitle(l10n.spendingByCategory),
              const SizedBox(height: 12),
              CategoryPieChart(
                  data: dashboard.spendingByCategory,
                  categories: txState.categories),
              const SizedBox(height: 20),
            ],
            if (dashboard.monthlyTotals.isNotEmpty) ...[
              _SectionTitle(l10n.monthlyOverview),
              const SizedBox(height: 12),
              MonthlyBarChart(data: dashboard.monthlyTotals),
              const SizedBox(height: 20),
            ],
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _SectionTitle(l10n.recentTransactions),
              TextButton(
                  onPressed: () => context.go('/transactions'),
                  child: Text(isFr ? 'Voir tout' : 'See all')),
            ]),
            const SizedBox(height: 8),
            if (dashboard.recentTransactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3)),
                    const SizedBox(height: 12),
                    Text(l10n.noTransactions,
                        style: const TextStyle(color: Colors.grey)),
                  ]),
                ),
              )
            else
              ...dashboard.recentTransactions.map((tx) => TransactionTile(
                  transaction: tx, categories: txState.categories)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w600));
}
