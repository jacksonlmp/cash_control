import 'package:flutter/material.dart';
import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/repositories/financial_summary_repository_impl.dart';
import 'package:cash_control/data/services/financial_summary_service.dart';
import 'package:cash_control/ui/view_model/monthly_financial_chart_view_model.dart';

class ChartScreen extends StatelessWidget {
  final AppDatabase database;
  final FinancialSummaryService _summaryService;

  ChartScreen({super.key, required this.database})
      : _summaryService = FinancialSummaryService(
    FinancialSummaryRepositoryImpl(database),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Evolução Mensal",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, Map<String, double>>>(
        future: _summaryService.getMonthlyFinancialTotals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar dados: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          }

          final data = snapshot.data ?? {};
          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Sem dados para exibir.",
                style: TextStyle(color: Colors.white),
              ),
            );
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
