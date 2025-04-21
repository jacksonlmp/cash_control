import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/floor/mapper/financial_entry_mapper.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/repositories/financial_report_repository.dart';

class FinancialReportRepositoryImpl implements FinancialReportRepository {
  final AppDatabase _database;

  FinancialReportRepositoryImpl(this._database);

  @override
  Future<Map<String, List<FinancialEntry>>> getMonthlyReport(int year) async {
    try {
      final entries = await _database.financialEntryDao.findAll();
      final Map<String, List<FinancialEntry>> monthlyReport = {};

      for (var entity in entries) {
        final model = entity.toModel();
        if (model.date.year == year) {
          final month = "${model.date.year.toString().padLeft(4, '0')}-${model.date.month.toString().padLeft(2, '0')}";

          monthlyReport.putIfAbsent(month, () => []);
          monthlyReport[month]!.add(model);
        }
      }

      return monthlyReport;
    } catch (e, stack) {
      print('Erro ao obter relatório mensal: $e');
      print('StackTrace: $stack');
      rethrow;
    }
  }

  @override
  Future<Map<int, List<FinancialEntry>>> getAnnualReport() async {
    try {
      final entries = await _database.financialEntryDao.findAll();
      final Map<int, List<FinancialEntry>> annualReport = {};

      for (var entity in entries) {
        final model = entity.toModel();
        final year = model.date.year;

        annualReport.putIfAbsent(year, () => []);
        annualReport[year]!.add(model);
      }

      return annualReport;
    } catch (e, stack) {
      print('Erro ao obter relatório anual: $e');
      print('StackTrace: $stack');
      rethrow;
    }
  }
}
