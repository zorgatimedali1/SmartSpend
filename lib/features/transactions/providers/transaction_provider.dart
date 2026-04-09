// lib/features/transactions/providers/transaction_provider.dart
// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/constants/app_constants.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../repositories/transaction_repository.dart';

class TransactionState {
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;
  final bool isLoading;
  final bool isAiLoading;
  final String? error;

  const TransactionState({
    this.transactions = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isAiLoading = false,
    this.error,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    List<CategoryModel>? categories,
    bool? isLoading,
    bool? isAiLoading,
    String? error,
  }) =>
      TransactionState(
        transactions: transactions ?? this.transactions,
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        isAiLoading: isAiLoading ?? this.isAiLoading,
        error: error,
      );

  double get totalExpenses => transactions.fold(0, (s, t) => s + t.amount);
  List<TransactionModel> get anomalies =>
      transactions.where((t) => t.isAnomaly).toList();

  Map<int, double> get spendingByCategory {
    final map = <int, double>{};
    for (final t in transactions) {
      if (t.categoryId != null)
        map[t.categoryId!] = (map[t.categoryId!] ?? 0) + t.amount;
    }
    return map;
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier() : super(const TransactionState()) {
    _init();
  }

  final _repo = TransactionRepository.instance;
  final _ai = AiService.instance;

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final categories = await _repo.fetchCategories();
    final transactions = await _repo.fetchAll();
    state = state.copyWith(
        transactions: transactions, categories: categories, isLoading: false);
  }

  Future<void> refresh() => _init();

  Future<int?> suggestCategory(String description) async {
    if (description.trim().length < 3) return null;
    state = state.copyWith(isAiLoading: true);
    try {
      final id = await _ai.categorize(description);
      print('AI categorization result for "$description": $id');
      state = state.copyWith(isAiLoading: false);
      return id == AppConstants.catOther ? null : id;
    } catch (e) {
      print('AI categorization failed: $e');
      state = state.copyWith(isAiLoading: false);
      return null;
    }
  }

  Future<Map<String, dynamic>?> addTransaction(TransactionModel tx) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      Map<String, dynamic>? anomalyInfo;
      if (tx.categoryId != null) {
        final recent =
            await _repo.fetchRecentAmountsForCategory(tx.categoryId!);
        if (recent.isNotEmpty) {
          final catName = state.categories
              .firstWhere((c) => c.id == tx.categoryId,
                  orElse: () => CategoryModel.defaults.last)
              .nameEn;
          anomalyInfo = await _ai.detectAnomaly(
              amount: tx.amount, categoryName: catName, recentAmounts: recent);
        }
      }
      final enriched = tx.copyWith(
        isAnomaly: anomalyInfo?['is_anomaly'] == true,
        anomalyScore: anomalyInfo?['score'] as double?,
      );
      final saved = await _repo.insert(enriched);
      state = state.copyWith(
          transactions: [saved, ...state.transactions], isLoading: false);
      return anomalyInfo?['is_anomaly'] == true ? anomalyInfo : null;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur lors de l\'enregistrement');
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updated = await _repo.update(tx);
      state = state.copyWith(
        transactions:
            state.transactions.map((t) => t.id == tx.id ? updated : t).toList(),
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Erreur de mise à jour');
    }
  }

  Future<void> deleteTransaction(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.delete(id);
      state = state.copyWith(
        transactions: state.transactions.where((t) => t.id != id).toList(),
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Erreur de suppression');
    }
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
        (_) => TransactionNotifier());

final categoriesProvider = Provider<List<CategoryModel>>(
    (ref) => ref.watch(transactionProvider).categories);

final anomalyCountProvider =
    Provider<int>((ref) => ref.watch(transactionProvider).anomalies.length);
