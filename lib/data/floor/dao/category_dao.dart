import 'package:floor/floor.dart';
import '../entities/category_entity.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM category')
  Future<List<CategoryEntity>> findAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategory(CategoryEntity category);

  @Query('DELETE FROM category WHERE id = :id')
  Future<void> deleteCategory(String id);
}
