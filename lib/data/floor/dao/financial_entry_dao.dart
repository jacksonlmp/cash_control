import 'package:floor/floor.dart';
import '../entities/financial_entry_entity.dart';

@dao
abstract class FinancialEntryDao {
  @Query('SELECT * FROM financialentryentity')
  Future<List<FinancialEntryEntity>> findAll();

  @insert
  Future<void> insertEntry(FinancialEntryEntity entry);

  @delete
  Future<void> deleteEntry(FinancialEntryEntity entry);
}
