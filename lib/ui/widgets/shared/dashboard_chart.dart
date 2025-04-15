import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';
import 'package:cash_control/data/services/financial_entry_service.dart';

class DashboardCharts extends StatefulWidget {
  final FinancialEntryService financialEntryService;

  const DashboardCharts({
    super.key,
    required this.financialEntryService,
  });

  @override
  State<DashboardCharts> createState() => _DashboardChartsState();
}

class _DashboardChartsState extends State<DashboardCharts> {
  late Future<void> _loadDataFuture;
  List<Category> categories = [];
  List<FinancialEntry> entries = [];

  Map<String, double> totalSpentByCategory = {};
  Map<String, Category> categoryById = {};

  double totalDespesas = 0;
  double totalReceitas = 0;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    // Todas as categorias e lançamentos
    categories = await widget.financialEntryService.findAllCategories();
    entries = await widget.financialEntryService.findAllFinancialEntries();
    categoryById = { for (var c in categories) c.id: c };

    // Despesas por categoria
    totalSpentByCategory = {};
    for (var entry in entries.where((e) => e.type == FinancialEntryType.despesa)) {
      totalSpentByCategory.update(
        entry.categoryId,
        (value) => value + entry.value,
        ifAbsent: () => entry.value,
      );
    }

    // Totais gerais
    totalReceitas = entries
        .where((e) => e.type == FinancialEntryType.receita)
        .fold(0.0, (sum, e) => sum + e.value);
    totalDespesas = entries
        .where((e) => e.type == FinancialEntryType.despesa)
        .fold(0.0, (sum, e) => sum + e.value);
  }

  final List<Color> barColors = [
    Color(0xFF8A2BE2),
    Color(0xFF6A1B9A),
    Color(0xFFB388FF),
    Color(0xFF9575CD),
    Color(0xFFBA68C8),
    Color(0xFFCE93D8),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (totalSpentByCategory.isEmpty && totalDespesas == 0 && totalReceitas == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Center(
              child: Text(
                'Nenhum dado financeiro cadastrado!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        }

        final barCategoryIds = totalSpentByCategory.keys.toList();
        final maxBarValue = (totalSpentByCategory.values.toList()..sort()).isEmpty
            ? 100.0
            : ((totalSpentByCategory.values.reduce((a, b) => a > b ? a : b) * 1.3).ceilToDouble());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TÍTULO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 0, 12),
              child: Text(
                'Gastos por categorias',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Gráfico de barras
            Container(
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF22203a),
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  maxY: maxBarValue == 0 ? 100 : maxBarValue,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Exibir inteiros e múltiplos de 25
                          if (value % 25 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 36,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, meta) {
                          if (value.toInt() < barCategoryIds.length) {
                            final catId = barCategoryIds[value.toInt()];
                            final catName = categoryById[catId]?.name ?? '';
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                catName,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: List.generate(barCategoryIds.length, (ix) {
                    final catId = barCategoryIds[ix];
                    final valor = totalSpentByCategory[catId] ?? 0;
                    return BarChartGroupData(
                      x: ix,
                      barRods: [
                        BarChartRodData(
                          toY: valor,
                          color: barColors[ix % barColors.length],
                          width: 22,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: maxBarValue ~/ 4 == 0 ? 25.0 : (maxBarValue ~/ 4).toDouble(),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white24,
                      strokeWidth: 1,
                      dashArray: [6, 3],
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                  ),
                  backgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Título do gráfico
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
              child: Text(
                'Receita x Despesa',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Gráfico de pizza
            Container(
              height: 210,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF22203A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 52,
                      sections: [
                        PieChartSectionData(
                          value: totalReceitas,
                          color: const Color(0xFFE1BEE7), // receita (lilás claro)
                          title: totalReceitas > 0
                              ? '${((totalReceitas / (totalReceitas + totalDespesas)) * 100).toStringAsFixed(0)}%'
                              : '',
                          radius: 56,
                          titleStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                        ),
                        PieChartSectionData(
                          value: totalDespesas,
                          color: const Color(0xFF7C43BD), // despesa (roxo escuro)
                          title: totalDespesas > 0
                              ? '${((totalDespesas / (totalReceitas + totalDespesas)) * 100).toStringAsFixed(0)}%'
                              : '',
                          radius: 56,
                          titleStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 13,
                    left: 16,
                    child: Row(
                      children: [
                        Container(width: 17, height: 17, color: Color(0xFFE1BEE7)),
                        const SizedBox(width: 6),
                        const Text('Receita', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 20),
                        Container(width: 17, height: 17, color: Color(0xFF7C43BD)),
                        const SizedBox(width: 6),
                        const Text('Despesa', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  // Valores no centro do gráfico
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                      Text(
                        'R\$ ${(totalReceitas + totalDespesas).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
