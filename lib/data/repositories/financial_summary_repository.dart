abstract class FinancialSummaryRepository {
  Future<Map<String, Map<String, double>>> getMonthlyTotals();
}
