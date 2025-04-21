import 'package:cash_control/data/repositories/financial_summary_repository_impl.dart';

class FinancialSummaryService {
  final FinancialSummaryRepositoryImpl _repository;

  FinancialSummaryService(this._repository);

  Future<Map<String, Map<String, double>>> getMonthlyFinancialTotals() async {
    return await _repository.getMonthlyTotals();
  }
}
