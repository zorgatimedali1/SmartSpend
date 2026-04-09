// lib/features/budgets/models/budget.dart
class BudgetModel {
  final String id;
  final String userId;
  final int? categoryId;
  final String month;
  final double limitAmount;
  double spent;

  BudgetModel(
      {required this.id,
      required this.userId,
      this.categoryId,
      required this.month,
      required this.limitAmount,
      this.spent = 0});

  factory BudgetModel.fromJson(Map<String, dynamic> j) => BudgetModel(
        id: j['id'] as String,
        userId: j['user_id'] as String,
        categoryId: j['category_id'] as int?,
        month: j['month'] as String,
        limitAmount: (j['limit_amount'] as num).toDouble(),
      );

  Map<String, dynamic> toInsertJson() => {
        'id': id,
        'user_id': userId,
        'category_id': categoryId,
        'month': month,
        'limit_amount': limitAmount,
      };

  double get remaining => limitAmount - spent;
  double get progress =>
      limitAmount > 0 ? (spent / limitAmount).clamp(0.0, 1.0) : 0;
  bool get isOverBudget => spent > limitAmount;
}
