import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/repositories/financial_report_repository_impl.dart';

class FinancialReportService {
  final _repository = FinancialReportRepositoryImpl();

  Future<Map<String, List<FinancialEntry>>> getMonthlyReport(int year) {
    return _repository.getMonthlyReport(year);
  }

  Future<Map<int, List<FinancialEntry>>> getAnnualReport() {
    return _repository.getAnnualReport();
  }
}
