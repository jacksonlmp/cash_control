import 'package:floor/floor.dart';
import '../entities/financial_entry_entity.dart';
import '../entities/monthly_total_view.dart';

@dao
abstract class FinancialEntryDao {
  @Query('SELECT * FROM financialentryentity')
  Future<List<FinancialEntryEntity>> findAll();

  @insert
  Future<void> insertEntry(FinancialEntryEntity entry);

  @delete
  Future<void> deleteEntry(FinancialEntryEntity entry);

  @Query('SELECT * FROM MonthlyTotalView')
  Future<List<MonthlyTotalView>> getMonthlyTotals();
}
