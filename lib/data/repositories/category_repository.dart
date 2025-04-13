import 'package:cash_control/domain/models/category.dart';

abstract class CategoryRepository {
  Future<void> register(Category category);
  Future<List<Category>> findAll();
  Future<void> delete(String id);
}
