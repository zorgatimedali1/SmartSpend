// lib/features/dashboard/providers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../transactions/models/transaction.dart';

class DashboardData {
  final double totalThisMonth;
  final double totalLastMonth;
  final int anomalyCount;
  final Map<int, double> spendingByCategory;
  final Map<String, double> monthlyTotals;
  final List<TransactionModel> recentTransactions;
  const DashboardData({
    this.totalThisMonth = 0, this.totalLastMonth = 0, this.anomalyCount = 0,
    this.spendingByCategory = const {}, this.monthlyTotals = const {},
    this.recentTransactions = const [],
  });
}

final dashboardProvider = Provider<DashboardData>((ref) {
  final txs = ref.watch(transactionProvider).transactions;
  final now = DateTime.now();
  final thisMonthKey = DateFormat('yyyy-MM').format(now);
  final lastMonthKey = DateFormat('yyyy-MM').format(DateTime(now.year, now.month - 1));

  final thisMonth = txs.where((t) => DateFormat('yyyy-MM').format(t.date) == thisMonthKey);
  final lastMonth = txs.where((t) => DateFormat('yyyy-MM').format(t.date) == lastMonthKey);

  final monthlyTotals = <String, double>{};
  for (var i = 5; i >= 0; i--) {
    final dt = DateTime(now.year, now.month - i);
    final key = DateFormat('yyyy-MM').format(dt);
    final label = DateFormat('MMM').format(dt);
    monthlyTotals[label] = txs.where((t) => DateFormat('yyyy-MM').format(t.date) == key)
        .fold(0, (s, t) => s + t.amount);
  }

  final spendingByCategory = <int, double>{};
  for (final t in txs) {
    if (t.categoryId != null) {
      spendingByCategory[t.categoryId!] = (spendingByCategory[t.categoryId!] ?? 0) + t.amount;
    }
  }

  return DashboardData(
    totalThisMonth: thisMonth.fold(0, (s, t) => s + t.amount),
    totalLastMonth: lastMonth.fold(0, (s, t) => s + t.amount),
    anomalyCount: txs.where((t) => t.isAnomaly).length,
    spendingByCategory: spendingByCategory,
    monthlyTotals: monthlyTotals,
    recentTransactions: txs.take(5).toList(),
  );
});
