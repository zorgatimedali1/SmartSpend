// lib/features/dashboard/widgets/category_pie_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../transactions/models/category.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<int, double> data;
  final List<CategoryModel> categories;
  const CategoryPieChart({super.key, required this.data, required this.categories});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();
    final entries = widget.data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          SizedBox(
            height: 200,
            child: PieChart(PieChartData(
              pieTouchData: PieTouchData(touchCallback: (event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                    _touchedIndex = -1; return;
                  }
                  _touchedIndex = response!.touchedSection!.touchedSectionIndex;
                });
              }),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: entries.asMap().entries.map((e) {
                final isTouched = e.key == _touchedIndex;
                final cat = widget.categories.firstWhere((c) => c.id == e.value.key,
                    orElse: () => CategoryModel.defaults.last);
                return PieChartSectionData(
                  color: cat.color,
                  value: e.value.value,
                  title: isTouched ? '${(e.value.value / total * 100).toStringAsFixed(0)}%' : '',
                  radius: isTouched ? 60 : 50,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }).toList(),
            )),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12, runSpacing: 8,
            children: entries.take(6).map((e) {
              final cat = widget.categories.firstWhere((c) => c.id == e.key,
                  orElse: () => CategoryModel.defaults.last);
              return Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 10, height: 10,
                    decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('${cat.nameFr} ${(e.value / total * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall),
              ]);
            }).toList(),
          ),
        ]),
      ),
    );
  }
}
