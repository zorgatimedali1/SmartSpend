// lib/features/transactions/models/transaction.dart
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String userId;
  @HiveField(2) final double amount;
  @HiveField(3) final String? description;
  @HiveField(4) final int? categoryId;
  @HiveField(5) final bool isAnomaly;
  @HiveField(6) final double? anomalyScore;
  @HiveField(7) final DateTime date;
  @HiveField(8) final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    this.description,
    this.categoryId,
    this.isAnomaly = false,
    this.anomalyScore,
    required this.date,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> j) => TransactionModel(
        id: j['id'] as String,
        userId: j['user_id'] as String,
        amount: (j['amount'] as num).toDouble(),
        description: j['description'] as String?,
        categoryId: j['category_id'] as int?,
        isAnomaly: j['is_anomaly'] as bool? ?? false,
        anomalyScore: (j['anomaly_score'] as num?)?.toDouble(),
        date: DateTime.parse(j['date'] as String),
        createdAt: DateTime.parse(j['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'user_id': userId, 'amount': amount,
        'description': description, 'category_id': categoryId,
        'is_anomaly': isAnomaly, 'anomaly_score': anomalyScore,
        'date': date.toIso8601String().substring(0, 10),
        'created_at': createdAt.toIso8601String(),
      };

  Map<String, dynamic> toInsertJson() => {
        'user_id': userId,
        'amount': amount, 'description': description,
        'category_id': categoryId, 'is_anomaly': isAnomaly,
        'anomaly_score': anomalyScore,
        'date': date.toIso8601String().substring(0, 10),
      };

  TransactionModel copyWith({
    String? id, String? userId, double? amount, String? description,
    int? categoryId, bool? isAnomaly, double? anomalyScore,
    DateTime? date, DateTime? createdAt,
  }) => TransactionModel(
        id: id ?? this.id, userId: userId ?? this.userId,
        amount: amount ?? this.amount, description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId, isAnomaly: isAnomaly ?? this.isAnomaly,
        anomalyScore: anomalyScore ?? this.anomalyScore, date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
}
