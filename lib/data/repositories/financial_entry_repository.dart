import 'package:cash_control/domain/models/financial_entry.dart';

abstract class FinancialEntryRepository {
  Future<void> register(FinancialEntry financialEntry);
  Future<List<FinancialEntry>> findAll();
  Future<void> delete(String id);
}
