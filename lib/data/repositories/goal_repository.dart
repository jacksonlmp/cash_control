import 'package:cash_control/domain/models/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getGoals();
  Future<Goal> getGoal(String name);
  Future<int> addGoal(Goal goal);
  Future<int> updateGoal(Goal goal);
  Future<void> deleteGoal(String id);
  Future<void> updateCurrentValue(String id, double currentValue);
}
