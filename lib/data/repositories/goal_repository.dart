import 'package:cash_control/domain/models/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getGoals();
  Future<Goal> getGoal(String name);
  Future<int> addGoal(Goal goal);
  Future<int> updateGoal(Goal goal);
  Future<int> deleteGoal(String id);
  Future<int> updateCurrentValue(String id, double currentValue);
}