// lib/features/dashboard/widgets/anomaly_banner.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnomalyBanner extends StatelessWidget {
  final int count;
  const AnomalyBanner({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Row(children: [
        const Text('⚠️', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$count anomalie${count > 1 ? 's' : ''} détectée${count > 1 ? 's' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF92400E), fontSize: 14)),
          const Text('Des dépenses inhabituelles ont été détectées',
              style: TextStyle(color: Color(0xFFB45309), fontSize: 12)),
        ])),
        TextButton(
          onPressed: () => context.go('/transactions'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF92400E), padding: EdgeInsets.zero),
          child: const Text('Voir'),
        ),
      ]),
    );
  }
}
