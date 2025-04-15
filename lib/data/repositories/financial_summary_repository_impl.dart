import 'package:cash_control/data/database_helper.dart';

class FinancialSummaryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Map<String, Map<String, double>>> getMonthlyTotals() async {
    final db = await _databaseHelper.database;

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
      final total = row['total'] is int
          ? (row['total'] as int).toDouble()
          : row['total'] as double;

      monthlyData.putIfAbsent(month, () => {});
      monthlyData[month]![type] = total;
    }

    return monthlyData;
  }
}
