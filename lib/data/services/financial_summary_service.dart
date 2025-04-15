import 'package:cash_control/data/repositories/financial_summary_repository_impl.dart';

class FinancialSummaryService {
  final FinancialSummaryRepository _repository = FinancialSummaryRepository();

  Future<Map<String, Map<String, double>>> getMonthlyFinancialTotals() async {
    return await _repository.getMonthlyTotals();
  }
}
