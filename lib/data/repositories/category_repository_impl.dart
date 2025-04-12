import 'package:cash_control/data/model/category_model.dart';
import 'package:cash_control/data/repositories/category_repository.dart';

import '../../domain/models/category.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final List<CategoryModel> _categories = [];

  @override
  Future<void> register(Category category) async {
    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
    );
    _categories.add(categoryModel);
  }
}
