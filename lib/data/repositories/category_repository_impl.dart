import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/data/model/category_model.dart';
import 'package:cash_control/data/repositories/category_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/category.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> register(Category category) async {
    final db = await _databaseHelper.database;

    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
    );

    await db.insert(
        'category',
        categoryModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<List<Category>> findAll() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('category');

    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }
}
