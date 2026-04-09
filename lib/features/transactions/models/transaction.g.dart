// lib/features/transactions/models/transaction.g.dart
// GENERATED CODE — run: flutter pub run build_runner build
// ignore_for_file: type=lint

part of 'transaction.dart';

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{for (int i = 0; i < n; i++) reader.readByte(): reader.read()};
    return TransactionModel(
      id: f[0] as String,
      userId: f[1] as String,
      amount: f[2] as double,
      description: f[3] as String?,
      categoryId: f[4] as int?,
      isAnomaly: f[5] as bool,
      anomalyScore: f[6] as double?,
      date: f[7] as DateTime,
      createdAt: f[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.userId)
      ..writeByte(2)..write(obj.amount)
      ..writeByte(3)..write(obj.description)
      ..writeByte(4)..write(obj.categoryId)
      ..writeByte(5)..write(obj.isAnomaly)
      ..writeByte(6)..write(obj.anomalyScore)
      ..writeByte(7)..write(obj.date)
      ..writeByte(8)..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
