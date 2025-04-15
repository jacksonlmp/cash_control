import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../ui/view_model/financial_report_view_model.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;

    Future.microtask(() {
      final viewModel = context.read<FinancialReportViewModel>();
      viewModel.fetchMonthlyReport(selectedYear);
      viewModel.fetchAnnualReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FinancialReportViewModel>(
      create: (_) => FinancialReportViewModel()
        ..fetchMonthlyReport(selectedYear)
        ..fetchAnnualReport(),
      child: Consumer<FinancialReportViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Relatórios Financeiros'),
              backgroundColor: Colors.black,
            ),
            backgroundColor: Colors.black,
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.error != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.fetchMonthlyReport(selectedYear);
                      viewModel.fetchAnnualReport();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildYearSelector(viewModel),
                  const SizedBox(height: 24),
                  const Text('Relatório Mensal',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  ...viewModel.monthlyReport.entries.map(
                        (entry) =>
                        _buildReportCard(entry.key, entry.value),
                  ),
                  const SizedBox(height: 24),
                  const Text('Relatório Anual',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  ...viewModel.annualReport.entries.map(
                        (entry) =>
                        _buildReportCard(entry.key.toString(), entry.value),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearSelector(FinancialReportViewModel viewModel) {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (index) => currentYear - index);

    return DropdownButtonFormField<int>(
      dropdownColor: Colors.black,
      value: selectedYear,
      decoration: const InputDecoration(
        labelText: 'Ano',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      style: const TextStyle(color: Colors.white),
      items: years
          .map((year) => DropdownMenuItem(
        value: year,
        child: Text(
          year.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ))
          .toList(),
      onChanged: (year) {
        if (year != null) {
          setState(() {
            selectedYear = year;
          });
          viewModel.fetchMonthlyReport(year);
        }
      },
    );
  }

  Widget _buildReportCard(String title, List entries) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...entries.map<Widget>((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(entry.name,
                            style: const TextStyle(color: Colors.white))),
                    Text(
                      formatter.format(entry.value),
                      style: TextStyle(
                        color: entry.type.name == 'receita'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}


