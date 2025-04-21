import 'package:floor/floor.dart';
import '../entities/goal_entity.dart';

@dao
abstract class GoalDao {
  @Query('SELECT * FROM goals')
  Future<List<GoalEntity>> findAll();

  @Query('SELECT * FROM goals WHERE name = :name')
  Future<GoalEntity?> findByName(String name);

  @insert
  Future<int> insertGoal(GoalEntity goal);

  @update
  Future<int> updateGoal(GoalEntity goal);

  @Query('UPDATE goals SET currentValue = :currentValue WHERE id = :id')
  Future<void> updateCurrentValue(String id, double currentValue); // ← alterado

  @delete
  Future<void> deleteGoal(GoalEntity goal); // ← alterado
}
