import 'package:cash_control/domain/models/financial_entry.dart';

abstract class FinancialReportRepository {
  Future<Map<String, List<FinancialEntry>>> getMonthlyReport(int year);
  Future<Map<int, List<FinancialEntry>>> getAnnualReport();
}
