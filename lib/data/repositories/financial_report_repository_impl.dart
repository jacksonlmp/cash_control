// lib/data/repositories/financial_report_repository_impl.dart
import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/model/financial_entry_model.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/repositories/financial_report_repository.dart';

class FinancialReportRepositoryImpl implements FinancialReportRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<Map<String, List<FinancialEntry>>> getMonthlyReport(int year) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT * FROM financial_entry
      WHERE strftime('%Y', date) = ?
      ORDER BY date ASC
    ''', [year.toString()]);

    final Map<String, List<FinancialEntry>> monthlyReport = {};

    for (var row in result) {
      final entry = FinancialEntryModel.fromMap(row);
      final month = entry.date.toIso8601String().substring(0, 7); // yyyy-MM

      monthlyReport.putIfAbsent(month, () => []);
      monthlyReport[month]!.add(entry);
    }

    return monthlyReport;
  }

  @override
  Future<Map<int, List<FinancialEntry>>> getAnnualReport() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT * FROM financial_entry
      ORDER BY date ASC
    ''');

    final Map<int, List<FinancialEntry>> annualReport = {};

    for (var row in result) {
      final entry = FinancialEntryModel.fromMap(row);
      final year = entry.date.year;

      annualReport.putIfAbsent(year, () => []);
      annualReport[year]!.add(entry);
    }

    return annualReport;
  }
}
