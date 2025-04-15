import 'package:cash_control/data/model/goal_model.dart';
import 'package:cash_control/data/repositories/goal_repository.dart';
import 'package:cash_control/data/database_helper.dart';
import 'package:cash_control/domain/models/goal.dart';
import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

class GoalRepositoryImpl implements GoalRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Goal>> getGoals() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('goals');

    return maps.map((map) => GoalModel.fromMap(map)).toList();
  }

  @override
  Future<Goal> getGoal(String name) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'goals',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return GoalModel.fromMap(maps.first);
    } else {
      throw Exception('Goal not found with name: $name');
    }
  }

  @override
  Future<int> addGoal(Goal goal) async {
    final db = await _databaseHelper.database;
    final goalModel = GoalModel(
      id: goal.id,
      name: goal.name,
      description: goal.description,
      targetValue: goal.targetValue,
      currentValue: goal.currentValue,
      deadline: goal.deadline,
    );
    return await db.insert(
      'goals',
      goalModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> deleteGoal(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> updateGoal(Goal goal) async {
    final db = await _databaseHelper.database;
    final goalModel = GoalModel(
      id: goal.id,
      name: goal.name,
      description: goal.description,
      targetValue: goal.targetValue,
      currentValue: goal.currentValue,
      deadline: goal.deadline,
    );
    return await db.update(
      'goals',
      goalModel.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  @override
  Future<int> updateCurrentValue(String id, double currentValue) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'goals',
      {
        'currentValue': currentValue,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
