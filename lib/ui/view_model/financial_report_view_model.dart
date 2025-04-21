import 'package:flutter/material.dart';
import 'package:cash_control/data/services/financial_report_service.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/repositories/financial_report_repository_impl.dart';

class FinancialReportViewModel extends ChangeNotifier {
  // Instanciando o DatabaseHelper
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Criando a instância do FinancialReportRepositoryImpl com o DatabaseHelper
  late final FinancialReportRepositoryImpl _repository;

  // Agora passando o repositório para o FinancialReportService
  late final FinancialReportService _service;

  Map<String, List<FinancialEntry>> _monthlyReport = {};
  Map<int, List<FinancialEntry>> _annualReport = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<FinancialEntry>> get monthlyReport => _monthlyReport;
  Map<int, List<FinancialEntry>> get annualReport => _annualReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FinancialReportViewModel() {
    // Inicializando o repositório com o DatabaseHelper
    _repository = FinancialReportRepositoryImpl(_databaseHelper);

    // Inicializando o serviço com o repositório
    _service = FinancialReportService(_repository);
  }

  // Função para buscar o relatório mensal
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

  // Função para buscar o relatório anual
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