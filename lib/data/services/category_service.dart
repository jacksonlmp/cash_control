import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/data/repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  Future<void> registerCategory(Category category) async {
    await _repository.register(category);
  }
}
