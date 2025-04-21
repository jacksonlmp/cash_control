import 'package:cash_control/data/floor/app_database.dart';
import 'package:cash_control/data/floor/mapper/goal_mapper.dart';
import 'package:cash_control/data/repositories/goal_repository.dart';
import 'package:cash_control/domain/models/goal.dart';

class GoalRepositoryImpl implements GoalRepository {
  final AppDatabase database;

  GoalRepositoryImpl(this.database);

  @override
  Future<List<Goal>> getGoals() async {
    final entities = await database.goalDao.findAll();
    return entities.map((e) => e.toModel()).toList();
  }

  @override
  Future<Goal> getGoal(String name) async {
    final entity = await database.goalDao.findByName(name);
    if (entity != null) {
      return entity.toModel();
    } else {
      throw Exception('Goal not found with name: $name');
    }
  }

  @override
  Future<int> addGoal(Goal goal) async {
    return await database.goalDao.insertGoal(goal.toEntity());
  }

  @override
  Future<int> updateGoal(Goal goal) async {
    return await database.goalDao.updateGoal(goal.toEntity());
  }

  @override
  Future<void> deleteGoal(String id) async {
    final all = await database.goalDao.findAll();
    final target = all.firstWhere((e) => e.id == id);
    await database.goalDao.deleteGoal(target);
  }

  @override
  Future<void> updateCurrentValue(String id, double currentValue) async {
    await database.goalDao.updateCurrentValue(id, currentValue);
  }
}
