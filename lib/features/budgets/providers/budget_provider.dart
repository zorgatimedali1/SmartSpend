// lib/features/budgets/providers/budget_provider.dart
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/budget.dart';
import '../repositories/budget_repository.dart';
import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transaction_provider.dart';

class BudgetState {
  final List<BudgetModel> budgets;
  final bool isLoading;
  final String? error;
  final String currentMonth;
  const BudgetState(
      {this.budgets = const [],
      this.isLoading = false,
      this.error,
      required this.currentMonth});
  BudgetState copyWith(
          {List<BudgetModel>? budgets,
          bool? isLoading,
          String? error,
          String? currentMonth}) =>
      BudgetState(
          budgets: budgets ?? this.budgets,
          isLoading: isLoading ?? this.isLoading,
          error: error,
          currentMonth: currentMonth ?? this.currentMonth);
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier(this.ref)
      : super(BudgetState(
            currentMonth: DateFormat('yyyy-MM').format(DateTime.now()))) {
    _load();
    ref.listen<TransactionState>(transactionProvider, (previous, next) {
      if (state.budgets.isEmpty) return;
      _recalculateBudgetSpent(next.transactions);
    });
  }
  final Ref ref;
  final _repo = BudgetRepository.instance;

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    try {
      final budgets = await _repo.fetchForMonth(state.currentMonth);
      _recalculateBudgetSpent(
          ref.read(transactionProvider).transactions, budgets);
      state = state.copyWith(budgets: budgets, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load budgets');
    }
  }

  void _recalculateBudgetSpent(List<TransactionModel> transactions,
      [List<BudgetModel>? budgets]) {
    final updatedBudgets = (budgets ?? state.budgets).map((b) {
      b.spent = transactions
          .where((t) =>
              t.categoryId == b.categoryId &&
              DateFormat('yyyy-MM').format(t.date) == state.currentMonth)
          .fold(0, (sum, t) => sum + t.amount);
      return b;
    }).toList();
    state = state.copyWith(budgets: updatedBudgets);
  }

  Future<void> refresh() => _load();

  Future<void> upsert(BudgetModel budget) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final saved = await _repo.upsert(budget);
      final list = [...state.budgets];
      final idx = list.indexWhere((b) => b.id == saved.id);
      if (idx >= 0)
        list[idx] = saved;
      else
        list.add(saved);
      state = state.copyWith(budgets: list, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to save budget');
    }
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = state.copyWith(
        budgets: state.budgets.where((b) => b.id != id).toList());
  }
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>(
    (ref) => BudgetNotifier(ref));
