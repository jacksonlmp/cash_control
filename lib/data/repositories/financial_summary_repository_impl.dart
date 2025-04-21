import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/domain/enum/financial_entry_type.dart';

class FinancialSummaryRepositoryImpl {
  final DatabaseHelper _databaseHelper;

  FinancialSummaryRepositoryImpl(this._databaseHelper);

  Future<Map<String, Map<String, double>>> getMonthlyTotals() async {
    final db = await _databaseHelper.database;

    try {
      final result = await db.rawQuery('''
        SELECT 
          strftime('%Y-%m', date) as month, 
          type, 
          SUM(value) as total
        FROM financial_entry
        GROUP BY month, type
        ORDER BY month ASC;
      ''');

      final Map<String, Map<String, double>> monthlyData = {};

      for (var row in result) {
        final month = row['month'] as String;
        final type = row['type'] as String;
        final total = (row['total'] is int)
            ? (row['total'] as int).toDouble()
            : row['total'] as double;

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