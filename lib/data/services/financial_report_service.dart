import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/repositories/financial_report_repository.dart';

class FinancialReportService {
  final FinancialReportRepository _repository;

  FinancialReportService(this._repository);

  Future<Map<String, List<FinancialEntry>>> getMonthlyReport(int year) {
    return _repository.getMonthlyReport(year);
  }

  Future<Map<int, List<FinancialEntry>>> getAnnualReport() {
    return _repository.getAnnualReport();
  }
}

