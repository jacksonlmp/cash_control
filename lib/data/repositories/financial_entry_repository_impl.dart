import 'package:cash_control/data/repositories/financial_entry_repository.dart';
import 'package:cash_control/domain/models/financial_entry.dart';
import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/floor/mapper/financial_entry_mapper.dart';

class FinancialEntryRepositoryImpl implements FinancialEntryRepository {
  final AppDatabase db;

  FinancialEntryRepositoryImpl(this.db);

  @override
  Future<void> register(FinancialEntry entry) async {
    await db.financialEntryDao.insertEntry(entry.toEntity());
  }

  @override
  Future<List<FinancialEntry>> findAll() async {
    final entities = await db.financialEntryDao.findAll();
    return entities.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> delete(String id) async {
    final entries = await db.financialEntryDao.findAll();
    final entry = entries.firstWhere((e) => e.id == id);
    await db.financialEntryDao.deleteEntry(entry);
  }
}
