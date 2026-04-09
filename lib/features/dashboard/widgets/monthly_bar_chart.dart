// lib/features/dashboard/widgets/monthly_bar_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatelessWidget {
  final Map<String, double> data;
  const MonthlyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final maxVal = entries.map((e) => e.value).fold(0.0, (a, b) => a > b ? a : b);
    final color = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: SizedBox(
          height: 180,
          child: BarChart(BarChartData(
            maxY: maxVal * 1.2 == 0 ? 100 : maxVal * 1.2,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                    BarTooltipItem('${rod.toY.toStringAsFixed(0)} TND',
                        const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= entries.length) return const SizedBox.shrink();
                  return Padding(padding: const EdgeInsets.only(top: 4),
                      child: Text(entries[idx].key, style: Theme.of(context).textTheme.bodySmall));
                },
              )),
            ),
            gridData: FlGridData(
              show: true, drawVerticalLine: false,
              horizontalInterval: maxVal > 0 ? maxVal / 4 : 25,
              getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 0.5),
            ),
            borderData: FlBorderData(show: false),
            barGroups: entries.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
              BarChartRodData(toY: e.value.value, color: color, width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
            ])).toList(),
          )),
        ),
      ),
    );
  }
}
