import 'package:flutter/material.dart';

import '../../data/services/financial_summary_service.dart';
import '../view_model/monthly_financial_chart_view_model.dart';


class ChartScreen extends StatelessWidget {
  final FinancialSummaryService _summaryService = FinancialSummaryService();

  ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Evolução Mensal")),
      body: FutureBuilder<Map<String, Map<String, double>>>(
        future: _summaryService.getMonthlyFinancialTotals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final data = snapshot.data ?? {};
          if (data.isEmpty) {
            return const Center(child: Text("Sem dados para exibir."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: MonthlyFinancialChart(data: data),
          );
        },
      ),
    );
  }
}
