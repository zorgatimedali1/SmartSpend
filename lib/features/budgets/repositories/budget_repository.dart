// lib/features/budgets/repositories/budget_repository.dart
// ignore_for_file: avoid_print

import '../../../core/constants/app_constants.dart';
import '../../../core/services/supabase_service.dart';
import '../models/budget.dart';

class BudgetRepository {
  BudgetRepository._();
  static final BudgetRepository instance = BudgetRepository._();
  final _client = SupabaseService.client;

  Future<List<BudgetModel>> fetchForMonth(String month) async {
    final data = await _client
        .from(AppConstants.tableBudgets)
        .select()
        .eq('user_id', SupabaseService.currentUserId!)
        .eq('month', month)
        .timeout(AppConstants.apiTimeout);
    return (data as List).map((e) => BudgetModel.fromJson(e)).toList();
  }

  Future<BudgetModel> upsert(BudgetModel budget) async {
    print('Upserting budget: ${budget.toInsertJson()}');
    try {
      final data = await _client
          .from(AppConstants.tableBudgets)
          .upsert(budget.toInsertJson(),
              onConflict: 'user_id, category_id, month')
          .select()
          .single()
          .timeout(AppConstants.apiTimeout);
      print('Upsert successful: $data');
      return BudgetModel.fromJson(data);
    } catch (e) {
      print('Upsert failed: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    await _client
        .from(AppConstants.tableBudgets)
        .delete()
        .eq('id', id)
        .timeout(AppConstants.apiTimeout);
  }
}
