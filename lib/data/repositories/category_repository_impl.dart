import '../../domain/models/category.dart';
import 'package:cash_control/data/floor/entities/category_entity.dart';
import 'package:cash_control/data/floor/dao/category_dao.dart';
import 'category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDao _dao;

  CategoryRepositoryImpl(this._dao);

  @override
  Future<void> register(Category category) async {
    final entity = CategoryEntity(id: category.id, name: category.name);
    await _dao.insertCategory(entity);
  }

  @override
  Future<List<Category>> findAll() async {
    final entities = await _dao.findAll();
    return entities.map((e) => Category(id: e.id, name: e.name)).toList();
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteCategory(id);
  }
}
