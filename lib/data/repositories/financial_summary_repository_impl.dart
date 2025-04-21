import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';

class FinancialSummaryRepositoryImpl {
  final AppDatabase _database;

  FinancialSummaryRepositoryImpl(this._database);

  Future<Map<String, Map<String, double>>> getMonthlyTotals() async {
    try {
      final results = await _database.financialEntryDao.getMonthlyTotals();

      final Map<String, Map<String, double>> monthlyData = {};

      for (var row in results) {
        final month = row.month;
        final type = row.type;
        final total = row.total;

        monthlyData.putIfAbsent(month, () => {});

        final entryType = FinancialEntryType.values.firstWhere(
              (e) => e.name.toUpperCase() == type.toUpperCase(),
          orElse: () => FinancialEntryType.despesa,
        );

        monthlyData[month]![entryType.name] = total;
      }

      return monthlyData;
    } catch (e, stackTrace) {
      print('Erro ao obter totais mensais: $e');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }
}
