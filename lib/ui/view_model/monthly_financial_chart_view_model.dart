import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyFinancialChart extends StatelessWidget {
  final Map<String, Map<String, double>> data;

  const MonthlyFinancialChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final months = data.keys.toList();
    final receitas = months.map((m) => data[m]?['RECEITA'] ?? 0.0).toList();
    final despesas = months.map((m) => data[m]?['DESPESA'] ?? 0.0).toList();

    return AspectRatio(
        aspectRatio: 1.7,
        child: BarChart(
          BarChartData(
            backgroundColor: Colors.black,
            barGroups: List.generate(months.length, (i) {
              return BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: receitas[i],
                  color: Colors.green,
                  width: 8,
                ),
                BarChartRodData(
                  toY: despesas[i],
                  color: Colors.red,
                  width: 8,
                ),
              ]);
            }),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index >= 0 && index < months.length) {
                      return Text(
                        months[index].substring(5),
                        style: const TextStyle(color: Colors.white),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) {
                    return Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Colors.white24,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
          ),
        )
    );
  }
}
