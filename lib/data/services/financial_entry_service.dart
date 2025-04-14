import 'package:cash_control/data/repositories/financial_entry_repository.dart';
import 'package:cash_control/domain/models/financial_entry.dart';

class FinancialEntryService {
  final FinancialEntryRepository _repository;

  FinancialEntryService(this._repository);

  Future<void> registerFinancialEntry(FinancialEntry financialEntry) async {
    await _repository.register(financialEntry);
  }

  Future<List<FinancialEntry>> findAllCategories() async {
    return await _repository.findAll();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.delete(id);
  }

}
