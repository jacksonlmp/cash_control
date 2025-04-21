import 'package:cash_control/domain/models/category.dart';
import 'package:cash_control/data/repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  Future<void> registerCategory(Category category) async {
    await _repository.register(category);
  }

  Future<List<Category>> findAllCategories() async {
    return await _repository.findAll();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.delete(id);
  }

  Future<void> addDefaultCategories() async {
    final defaultCategories = [
      Category(id: '1', name: 'Alimentação'),
      Category(id: '2', name: 'Transporte'),
      Category(id: '3', name: 'Saúde'),
      Category(id: '4', name: 'Educação'),
      Category(id: '5', name: 'Lazer'),
      Category(id: '6', name: 'Salario'),
      Category(id: '7', name: 'Investimento')
    ];
    
    final existingCategories = await _repository.findAll();

    for (var category in defaultCategories) {

      if (!existingCategories.any((cat) => cat.name == category.name)) {
        await _repository.register(category);
      }
    }
  }
}
