// lib/features/transactions/widgets/anomaly_badge.dart
import 'package:flutter/material.dart';

class AnomalyBadge extends StatelessWidget {
  final double? score;
  const AnomalyBadge({super.key, this.score});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: score != null ? 'Score: ${(score! * 100).toStringAsFixed(0)}%' : 'Dépense inhabituelle',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF59E0B)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Text('⚠️', style: TextStyle(fontSize: 11)),
          SizedBox(width: 4),
          Text('Anomalie', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF92400E))),
        ]),
      ),
    );
  }
}
