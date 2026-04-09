// lib/features/transactions/repositories/transaction_repository.dart
// ignore_for_file: avoid_print

import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/supabase_service.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class TransactionRepository {
  TransactionRepository._();
  static final TransactionRepository instance = TransactionRepository._();

  final _client = SupabaseService.client;
  Box<Map>? _box;

  Future<Box<Map>> get _cache async {
    _box ??= await Hive.openBox<Map>(AppConstants.transactionsBox);
    return _box!;
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final data = await _client
          .from(AppConstants.tableCategories)
          .select()
          .order('id')
          .timeout(AppConstants.apiTimeout);
      return (data as List).map((e) => CategoryModel.fromJson(e)).toList();
    } catch (_) {
      return CategoryModel.defaults;
    }
  }

  Future<List<TransactionModel>> fetchAll() async {
    try {
      final data = await _client
          .from(AppConstants.tableTransactions)
          .select()
          .eq('user_id', SupabaseService.currentUserId!)
          .order('date', ascending: false)
          .order('created_at', ascending: false)
          .timeout(AppConstants.apiTimeout);
      final list =
          (data as List).map((e) => TransactionModel.fromJson(e)).toList();
      await _saveToCache(list);
      return list;
    } catch (_) {
      return await _loadFromCache();
    }
  }

  Future<List<double>> fetchRecentAmountsForCategory(int categoryId,
      {int limit = AppConstants.anomalyContextCount}) async {
    try {
      final data = await _client
          .from(AppConstants.tableTransactions)
          .select('amount')
          .eq('user_id', SupabaseService.currentUserId!)
          .eq('category_id', categoryId)
          .order('date', ascending: false)
          .limit(limit)
          .timeout(AppConstants.apiTimeout);
      return (data as List)
          .map((e) => (e['amount'] as num).toDouble())
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<TransactionModel> insert(TransactionModel tx) async {
    print('Inserting transaction: ${tx.toInsertJson()}');
    try {
      final data = await _client
          .from(AppConstants.tableTransactions)
          .insert(tx.toInsertJson())
          .select()
          .single()
          .timeout(AppConstants.apiTimeout);
      print('Insert successful: $data');
      return TransactionModel.fromJson(data);
    } catch (e) {
      print('Insert failed: $e');
      rethrow;
    }
  }

  Future<TransactionModel> update(TransactionModel tx) async {
    final data = await _client
        .from(AppConstants.tableTransactions)
        .update(tx.toInsertJson())
        .eq('id', tx.id)
        .select()
        .single()
        .timeout(AppConstants.apiTimeout);
    return TransactionModel.fromJson(data);
  }

  Future<void> delete(String id) async {
    await _client
        .from(AppConstants.tableTransactions)
        .delete()
        .eq('id', id)
        .timeout(AppConstants.apiTimeout);
  }

  Future<void> _saveToCache(List<TransactionModel> list) async {
    final box = await _cache;
    await box.clear();
    for (final tx in list) {
      await box.put(tx.id, tx.toJson());
    }
  }

  Future<List<TransactionModel>> _loadFromCache() async {
    final box = await _cache;
    return box.values
        .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
