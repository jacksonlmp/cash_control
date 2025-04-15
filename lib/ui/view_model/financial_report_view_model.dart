// lib/ui/view_model/financial_report_view_model.dart
import 'package:flutter/material.dart';
import 'package:cash_control/data/services/financial_report_service.dart';
import 'package:cash_control/domain/models/financial_entry.dart';

class FinancialReportViewModel extends ChangeNotifier {
  final FinancialReportService _service = FinancialReportService();

  Map<String, List<FinancialEntry>> _monthlyReport = {};
  Map<int, List<FinancialEntry>> _annualReport = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<FinancialEntry>> get monthlyReport => _monthlyReport;
  Map<int, List<FinancialEntry>> get annualReport => _annualReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMonthlyReport(int year) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _monthlyReport = await _service.getMonthlyReport(year);
    } catch (e) {
      _error = 'Erro ao carregar relatório mensal: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAnnualReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _annualReport = await _service.getAnnualReport();
    } catch (e) {
      _error = 'Erro ao carregar relatório anual: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
