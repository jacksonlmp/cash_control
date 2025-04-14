import 'package:cash_control/data/repositories/financial_entry_repository.dart';
import 'package:cash_control/data/services/category_service.dart';
import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/domain/models/financial_entry.dart';

class FinancialEntryService {
  final FinancialEntryRepository _repository;
  final CategoryService _categoryService;

  FinancialEntryService(this._repository, this._categoryService);

  Future<void> registerFinancialEntry(FinancialEntry financialEntry) async {
    await _repository.register(financialEntry);
  }

  Future<List<Category>> findAllCategories() async {
    return await _categoryService.findAllCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.delete(id);
  }

}
